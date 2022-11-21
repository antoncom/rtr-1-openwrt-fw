--[[
This script has to be made as daemon.
https://oldwiki.archive.openwrt.org/inbox/procd-init-scripts
https://forum.openwrt.org/t/tracking-ubus-listeners/11360
]]

local socket = require "socket"
local bit = require "bit"
local uci = require "luci.model.uci".cursor()
local util = require "luci.util"
local log = require "luci.model.tsmodem.util.log"
local uloop = require "uloop"

local M = require 'posix.termio'
local F = require 'posix.fcntl'
local U = require 'posix.unistd'
local PSS = require 'posix.sys.socket'

-- Constants
local CNSMODES = require 'luci.model.tsmodem.constants.cnsmodes'

-- Paesers
local CREG_parser = require 'luci.model.tsmodem.parser.creg'
local CSQ_parser = require 'luci.model.tsmodem.parser.csq'
local CUSD_parser = require 'luci.model.tsmodem.parser.cusd'
local SMS_parser = require 'luci.model.tsmodem.parser.sms'
local BAL_parser = require 'luci.model.tsmodem.parser.balance'
local CNSMOD_parser = require 'luci.model.tsmodem.parser.cnsmod'
local ucs2_ascii = require 'luci.model.tsmodem.parser.ucs2_ascii'
local provider_name = require 'luci.model.tsmodem.parser.provider_name'
local check_host = require 'luci.model.tsmodem.parser.hostip'


require "luci.model.tsmodem.util.split_string"

local config = "tsmodem"
local config_gsm = "tsmodem_adapter_provider"
local section = "sim"
local dev = arg[1] or '/dev/ttyUSB1'

local modem = {}
modem.tick_size = 3000
-- Descriptor for /dev/ttyUSB2
modem.fds = nil
modem.fds_ev = nil

-- Descriptor for ping socket
modem.fds_ping = nil
modem.fds_ping_ev = nil

-- Intervals
modem.interval = {
    reg = 3000,         -- Sim registration state (checking interval)
    signal = 2000,      -- Signal strength (checking interval)
    balance = 180000,     -- Balance value (checking interval) - 60 sec. minimum to avoid Provider blocking USSD
    netmode = 3000,     -- 4G/3G mode state (checking interval)
    provider = 5000,    -- GSM provider name (autodetection checking interval)
    ping = 4000,        -- Ping GSM network (checking interval)
}

-- Helper. Need to avoid doing USSD requests too often.
modem.last_balance_request_time = os.time()

-- If GSM opeator doen't send back the balance USSD-response
-- then we should wait 1..2 mins before repeating
modem.balance_repeated_request_delay = 125 -- seconds

-- Enable debug mode here
modem.debug = true

local modem_state = {
	stm = { --[[	{
			command = "",
			value = "",					-- 0 / 1 / OK / ERROR
			time = "",
			unread = "true" }]]
	},
	reg = { --[[	{
			command = "AT+CREG?",
			value = "",					-- 0 / 1 / 2 / 3 / 4 / 5 / 6 / 7
			time = tostring(os.time()),
			unread = "true" }]]
	},
	sim = { --[[	{
			command = "~0:SIM.SEL=?",
			value = "",					-- 0 / 1
			time = "",
			unread = "true" }]]
	},
	signal = { --[[	{
			command = "AT+CSQ",
			value = "",					-- 0..31
			time = "",
			unread = "true"	}]]
	},
	balance = { --[[	{
			command = "*100#",
			value = "605",
			time = "1646539246",
			unread = "true"	}]]
	},
	usb = { --[[	{
			command = "", 				-- /dev/ttyUSB open  |  /dev/ttyUSB close
			value = "",					-- connected / disconnected
			time = "",
			unread = "true"	}]]
	},
	netmode = { --[[	{
			command = "", 				-- AT+.... __TODO__
			value = "",					-- _TODO__
			time = "",
			unread = "true"	}]]
	},
	last_at = { --[[	{
			command = "",
			value = "",
			time = "",
			unread = "true" }]]
	},
	provider_name = { --[[	{
			command = "",
			value = "",
			time = "",
			unread = "true" }]]
	},
	provider_gate = { --[[	{
			command = "",
			value = "",
			time = "",
			unread = "true"	}]]
	},
	ping = { --[[	{
			command = "",
			value = "",
			time = "",
			unread = "true"	}]]
	},
    switching = { --[[	{
			command = "",
			value = "",          -- true or false
			time = "",
			unread = "true"	}]]
	},
}


--[[ Example:  local ok, error, value = modem:get_state("sim", "value") ]]
function modem:get_state(var, param)
	local value = ""
	local v, p = tostring(var), tostring(param)
	if modem_state[v] and (#modem_state[v] > 0) and modem_state[v][#modem_state[v]][p] then
		value = modem_state[v][#modem_state[v]][p]
		return true, "", value
	else
		return false, string.format("State Var '%s' or Param '%s' are not found in list of state vars.", v, p), value
	end
end

--[[ Get provider Id from uci config ]]
function modem:get_provider_id(sim_id)
	local provider_id
	if (sim_id and (sim_id == "0" or sim_id == "1")) then
		provider_id = uci:get("tsmodem", "sim_" .. sim_id, "provider")
	end
	return provider_id or ""
end

function modem:init_mk()
	local sys  = require "luci.sys"
	sys.exec("stty -F /dev/ttyS1 1000000")
	socket.sleep(0.5)
	local fds_mk, err, errnum = F.open("/dev/ttyS1", bit.bor(F.O_RDWR, F.O_NONBLOCK))
	if not fds_mk then
		print('Could not open serial port ', err, ':', errnum)
		os.exit(1)
	end

	M.tcsetattr(fds_mk, 0, {
	   cflag = 0x1008 + M.CS8 + M.CLOCAL + M.CREAD,
	   iflag = M.IGNPAR,
	   oflag = M.OPOST,
	   cc = {
	      [M.VTIME] = 0,
	      [M.VMIN] = 1,
	   }
	})
	self.fds_mk = fds_mk

	local res, sim_id = modem:stm32comm("~0:SIM.SEL=?")
	if res == "OK" then
		modem:update_state("sim", tostring(sim_id), "~0:SIM.SEL=?")
	else
		-- TODO: log error
	end
end

function modem:init()
	if not self:is_connected(self.fds) then

		modem:unpoll()
		if self.fds then
			U.close(self.fds)

			modem:update_state("usb", "disconnected", dev .. " close")
			modem:update_state("reg", "7", "AT+CREG?")
			modem:update_state("signal", "0", "AT+CSQ")
		end

		local fds, err, errnum = F.open(dev, bit.bor(F.O_RDWR, F.O_NONBLOCK))

		if fds then
			M.tcsetattr(fds, 0, {
			   cflag = M.B115200 + M.CS8 + M.CLOCAL + M.CREAD,
			   iflag = M.IGNPAR,
			   oflag = M.OPOST,
			   cc = {
			      [M.VTIME] = 0,
			      [M.VMIN] = 1,
			   }
			})
			self.fds = fds

			modem:update_state("usb", "connected", dev .. " open", "")
			modem:update_state("reg", "7", "AT+CREG?", "")
			modem:update_state("signal", "0", "AT+CSQ", "")
            modem:update_state("reg", "0", "AT+CSQ", "")


			local ok, err, sim_id = modem:get_state("sim", "value")
			if ok and (sim_id == "1" or sim_id == "0") then
                local provider_id = modem:get_provider_id(sim_id)
				--local provider_id = uci:get(config, "sim_" .. sim_id, "provider")
				local apn_provider = uci:get(config_gsm, provider_id, "gate_address") or "APNP"
				local apn_network = uci:get("network", "tsmodem", "apn") or "APNN"
				if(apn_provider ~= apn_network) then
					uci:set("network", "tsmodem", "apn", apn_provider)
					uci:save("network")
					uci:commit("network")
				end
			end

		end

	end
end


function modem:make_ubus()
	self.conn = ubus.connect()
	if not self.conn then
		error("tsmodem: Failed to connect to ubus")
	end

	-- Сделать перебор очереди статусов, проверяя параметр "unread"
	-- и выдавать до тех пор пока unread==true

	function getFirstUnread(name)
		local n = #modem.state[name]
		if n > 0 then
			for i=1, #modem.state[name] do
				if modem.state[name][i].unread == "true" then
					return modem.state[name][i]
				end
			end
			-- If no unread states then return the last one.
			return modem.state[name][n]
		end
		return {}
	end

	function makeResponse(name)
		local r, resp = {}, {}
		local n = #modem.state[name]
		if (n > 0) then
			r = getFirstUnread(name)
			resp = util.clone(r)
			r["unread"] = "false"
		else
			resp = {
				command = "",
				value = "",
				time = "",
				unread = "",
				comment = ""
			}
		end
		return resp
	end

	local ubus_objects = {
		["tsmodem.driver"] = {
			reg = {
				function(req, msg)
					local resp = makeResponse("reg")
					self.conn:reply(req, resp);
				end, {id = ubus.INT32, msg = ubus.STRING }
			},
			sim = {
				function(req, msg)
					local resp = makeResponse("sim")
					self.conn:reply(req, resp);
				end, {id = ubus.INT32, msg = ubus.STRING }
			},
			signal = {
				function(req, msg)
					local resp = makeResponse("signal")
					self.conn:reply(req, resp);

				end, {id = ubus.INT32, msg = ubus.STRING }
			},
			balance = {
				function(req, msg)
					local resp = makeResponse("balance")
					self.conn:reply(req, resp);

				end, {id = ubus.INT32, msg = ubus.STRING }
			},

			do_request_ussd_balance = {
				function(req, msg)
					local sim_id_settings = msg["sim_id"]
					local ok, err, sim_id = modem:get_state("sim", "value")
					if(sim_id_settings == sim_id) then
						local provider_id = modem:get_provider_id(sim_id)
						local ussd_command = string.format("AT+CUSD=1,%s,15\r\n", uci:get(config_gsm, provider_id, "balance_ussd"))
                        modem.last_balance_request_time = os.time() -- Do it each time USSD request runs

						modem:update_state("balance", "", ussd_command, uci:get(config_gsm, provider_id, "balance_last_message"))
						local chunk, err, errcode = U.write(modem.fds, ussd_command)
					end
					local resp = {}

					self.conn:reply(req, resp);

				end, {id = ubus.INT32, msg = ubus.STRING }
			},

			usb = {
				function(req, msg)
					local resp = makeResponse("usb")
					self.conn:reply(req, resp);
				end, {id = ubus.INT32, msg = ubus.STRING }
			},

			stm = {
				function(req, msg)
					local resp = makeResponse("stm")
                    if not modem.tmp_stm then
                        modem.tmp_stm = 1
                    else
                         modem.tmp_stm = modem.tmp_stm + 1
                    end

                    -- if(#modem.state.stm) > 0 then
                    --     log("STM QUEUE", modem.state.stm)
                    -- end
					self.conn:reply(req, resp);

				end, {id = ubus.INT32, msg = ubus.STRING }
			},
			netmode = {
				function(req, msg)
					local resp = makeResponse("netmode")
					self.conn:reply(req, resp);

				end, {id = ubus.INT32, msg = ubus.STRING }
			},
			last_at = {
				function(req, msg)
					local resp = makeResponse("last_at")
					self.conn:reply(req, resp);

				end, {id = ubus.INT32, msg = ubus.STRING }
			},
			provider_name = {
				function(req, msg)
					local resp = makeResponse("provider_name")
					self.conn:reply(req, resp);

				end, {id = ubus.INT32, msg = ubus.STRING }
			},
			provider_gate = {
				function(req, msg)
					local resp = makeResponse("provider_gate")
					self.conn:reply(req, resp);

				end, {id = ubus.INT32, msg = ubus.STRING }
			},
			ping = {
				function(req, msg)
					local resp = makeResponse("ping")
					self.conn:reply(req, resp);

				end, {id = ubus.INT32, msg = ubus.STRING }
			},
			do_switch = {
				function(req, msg)
                    modem:update_state("switching", "true", "", "")

                    -- local resp_1 = makeResponse("sim")
                    -- resp_1.value = "true"
                    -- self.conn:reply(req, resp_1);

					local resp, n = {}, 0
					local res, sim_id = modem:stm32comm("~0:SIM.SEL=?")
					if res == "OK" then
						modem:update_state("sim", tostring(sim_id), "~0:SIM.SEL=?")
					else
                        print("tsmodem: Error while sending command ~0:SIM.SEL=? to STM32.")
					end

					if self:is_connected(self.fds) then
						n = #modem.state.usb
						if (modem.state.usb[n].value ~= "disconnected") then

							modem:unpoll()
                            print("AFTER_______UNPOLL")
							socket.sleep(0.8)

							n = #modem.state.sim

							if(modem.state.sim[n].value == "0") then
								modem:switch("1")
                                resp = makeResponse("sim")
                                --resp.value = "just-switched"
							elseif(modem.state.sim[n].value == "1") then
								modem:switch("0")
                                resp = makeResponse("sim")
                                --resp.value = "just-switched"
                            else
                                print("tsmodem: Error. Unable to switch Sim-card")
							end
						else
							resp = makeResponse("sim")
							resp.value = "not-ready-to-switch"
						end

					end

					self.conn:reply(req, resp);

				end, {id = ubus.INT32, msg = ubus.STRING }
			},
            -- [[ This ubus method update "ping" modem state ]]
            -- [[ It is used to get ping result from shell script, running in independent process ]]
            -- [[ If user or automation rule switch sim card during or just before this ubus request ]]
            -- [[ then nothing is done (ping is not updated). ]]
            -- [[ So, the ubus request affects only if sim_id in ubus request is the same as active sim id]]
            set_ping = {
                function(req, msg)
                    if msg["host"] and msg["value"] and msg["sim_id"] then
                        local host   = msg["host"]
                        local value  = msg["value"]
                        local sim_id = tostring(msg["sim_id"])
                        if value == "1" or value == "0" then
                            local _,_,active_sim_id = modem:get_state("sim", "value")
                            if not (sim_id == "1" or sim_id == "0") then
                                resp = { msg = "Param [sim_id] has to be 0 or 1. Nothing was done. "}
                            elseif sim_id == active_sim_id then
                                modem:update_state("ping", value, "ping "..host, "updated via ubus call 'set_ping'")
                                if modem.debug then print("PING says: ","UBUS", tostring(modem.interval.ping).."ms", value, "","","","Note: ping.sh do the job.") end
                                resp = { msg = "ok" }
                            elseif sim_id ~= active_sim_id and (sim_id == "0" or sim_id == "1") then
                                resp = { msg = "Active sim was switched by user or automation rules. So 'set_ping' doesn't affect this time." }
                            end
                        else
                            resp = { msg = "Param [value] has to be 0 or 1. Nothing was done. "}
                        end
                    else
                        resp = { msg = "[host], [value] and [sim_id] are required params. Nothing was done." }
                    end

                    self.conn:reply(req, resp);

                end, {id = ubus.INT32, msg = ubus.STRING }
            },
            switching = {
                function(req, msg)
                    local resp = makeResponse("switching")
                    self.conn:reply(req, resp);

                end, {id = ubus.INT32, msg = ubus.STRING }
            },
		}
	}
	self.conn:add( ubus_objects )
	self.ubus_objects = ubus_objects

end


function modem:update_state(param, value, command, comment)
	local newval = tostring(value)

	local n = #modem.state[param]

	if (n == 0) then
		local item = {
			["command"] = command,
			["value"] = newval,
			["time"] = tostring(os.time()),
			["unread"] = "true",
			["comment"] = comment
		}
		modem.state[param][1] = util.clone(item)
	elseif (n >= 1) then
		if(modem.state[param][n].value ~= newval or modem.state[param][n].command ~= command) then
			local item = {
				["command"] = command,
				["value"] = newval,
				["time"] = tostring(os.time()),
				["unread"] = "true",
				["comment"] = comment
			}
			modem.state[param][n+1] = util.clone(item)
			if n > 5 then
				table.remove(modem.state[param], 1)
			end
		--[[ Update last time of succesful registration state ]]
		elseif (param == "reg" and (newval == "1" or newval == "7")) then
			modem.state["reg"][n].time = tostring(os.time())
		--[[ Update time of last balance ussd request if balance's value is not changed ]]
		elseif (param == "balance") then
			modem.state["balance"][n].time = tostring(os.time())
		--[[ Update time of last successful ping ]]
		elseif (param == "ping") and value == "1" then
			modem.state["ping"][n].time = tostring(os.time())
		--[[ Update gate IP if possibly changed by Cell operator ]]
		elseif (param == "provider_gate") then
			modem.state["provider_gate"][n].time = tostring(os.time())
		end
	end
end

function modem:is_connected(fd)
	return fd and U.isatty(fd)
end

function modem:switch(sim_id)
	local res, val = modem:stm32comm("~0:SIM.SEL=" .. tostring(sim_id))

	if res == "OK" then

		modem:update_state("sim", sim_id, "~0:SIM.SEL=" .. tostring(sim_id), "")
		modem:update_state("stm", "OK", "~0:SIM.SEL=" .. tostring(sim_id), "")

		--[[
		Lets update network interface APN
		]]

		local provider_id = uci:get(config, "sim_" .. sim_id, "provider")
		local apn = uci:get(config_gsm, provider_id, "gate_address") or "internet"
		uci:set("network", "tsmodem", "apn", apn)
		uci:save("network")
		uci:commit("network")

	else
		modem:update_state("stm", "ERROR", "~0:SIM.SEL=" .. tostring(sim_id), "")
	end

	socket.sleep(0.2)

	modem:update_state("reg", "7", "AT+CREG?", "")
	modem:update_state("signal", "", "", "")
	modem:update_state("balance", "", "", "")
	modem:update_state("netmode", "", "", "")
	modem:update_state("provider_name", "", "", "")
	modem:update_state("ping", "", "", "")
    modem.state.ping.time = "0"
	modem:update_state("provider_gate", "", "", "")

	res, val = modem:stm32comm("~0:SIM.RST=0")

	if res == "OK" then
		modem:update_state("stm", "OK", "~0:SIM.RST=0", "")
		modem:update_state("usb", "disconnected", dev .. " close", "")

	else
		modem:update_state("stm", "ERROR", "~0:SIM.RST=0", "")
		modem:update_state("usb", "disconnected", dev .. " close", "")

	end

	socket.sleep(0.2)

	res, val = modem:stm32comm("~0:SIM.RST=1")
	if res == "OK" then
		modem:update_state("stm", "OK", "~0:SIM.RST=1", "")
		modem:update_state("usb", "disconnected", dev .. " close", "")

	else
		modem:update_state("stm", "ERROR", "~0:SIM.RST=1", "")
		modem:update_state("usb", "disconnected", dev .. " close", "")

	end
	socket.sleep(0.2)
    modem:update_state("switching", "false", "", "")
    print("SWITCHING::::::::::")
end

function modem:stm32comm(comm)
	local buf, value, status = '','',''

	U.write(self.fds_mk, comm .. "\r\n")
	socket.sleep(0.1)
	buf = U.read(self.fds_mk, 1024) or error('ERROR: no stm32 buf')

	local b = util.split(buf)
	if(b[#b] == '') then
		table.remove(b, #b)
	end

	status = b[#b]
	value = b[1]

	if(status == "OK") then
		return status, value
	else
		return "ERROR", ""
	end
end

function modem:balance_parsing_and_update(chunk)
	local ok, err, sim_id = modem:get_state("sim", "value")
    local balance = 0
	if ok then
		local provider_id = modem:get_provider_id(sim_id)
		local ussd_command = uci:get(config_gsm, provider_id, "balance_ussd")

		local balance_message = ucs2_ascii(CUSD_parser:match(chunk))
		balance_message = string.gsub(balance_message, ",", ".")

		balance = BAL_parser(sim_id):match(balance_message) or ""
		if (balance and balance ~= "") then --[[ if balance value is OK ]]
			modem:update_state("balance", balance, ussd_command, balance_message)
			uci:set(config_gsm, provider_id, "balance_last_message", balance_message)
			uci:commit(config_gsm)
		else
			if(#balance_message > 0) then -- If balance message template is wrong
				modem:update_state("balance", "-999", ussd_command, "A mistake in balance message template.")
				uci:set(config_gsm, provider_id, "balance_last_message", balance_message)
				uci:commit(config_gsm)
			elseif(chunk:find("+CUSD: 2")) then -- GSM net cancels USSD sesion
				modem:update_state("balance", "-998", ussd_command, "GSM provider cancels USSD session. We will get balance later.")
			end
		end

	else
		util.perror('driver.lua : ' .. err)
	end
    return balance
end

function modem:poll()
	if (not self.fds_ev) and modem:is_connected(self.fds) then
		self.fds_ev = uloop.fd_add(self.fds, function(ufd, events)
			local chunk, err, errcode = U.read(self.fds, 1024)
            --print(chunk)
			if chunk:find("+CREG:") then
                print(">>>>>>>>>> ", modem:get_state("usb", "value"))
				local creg = CREG_parser:match(chunk)
                if modem.debug then print("AT says: ","+CREG", tostring(modem.interval.reg).."ms", creg, "","","","Note: Sim registration state (0..5)") end
				if creg and creg ~= "" then

					--[[ GET BALANCE AS SOON AS SIM REGISTERED AND CONNECTION ESTABLISHED ]]
                    --[[ But wait 3 seconds before do it to ensure that the connection is stable ]]
                    local ok, err, lastreg = modem:get_state("reg", "value")
					if(lastreg ~= "1" and creg =="1") then
                        local timer_CUSD_SINCE_SIM_REGISTERED
                		function t_CUSD_SINCE_SIM_REGISTERED()
                			if(modem:is_connected(modem.fds)) then
                				local ok_reg, err, reg = modem:get_state("reg", "value")
                				if ok_reg and reg == "1" then
                					local ok_sim, err, sim_id = modem:get_state("sim", "value")
                					if ok_sim and (sim_id == "0" or sim_id =="1") then
                                        local provider_id = modem:get_provider_id(sim_id)
                                        if modem.debug then print("----->>> Sending BALANCE REQUEST ASAP SIM REGISTERED -----]]]") end
    									local ussd_command = string.format("AT+CUSD=1,%s,15\r\n", uci:get(config_gsm, provider_id, "balance_ussd"))
                                        modem.last_balance_request_time = os.time() -- Do it each time USSD request runs
    									-- TODO local chunk, err, errcode = U.write(modem.fds, ussd_command)
                                    end
                                end
                            end
                		end
                		timer_CUSD_SINCE_SIM_REGISTERED = uloop.timer(t_CUSD_SINCE_SIM_REGISTERED, 3000)
                    end

                    modem:update_state("reg", creg, "AT+CREG?", "")
                    modem:update_state("usb", "connected", dev .. " open", "")
				end
			elseif chunk:find("+CSQ:") then
				local signal = CSQ_parser:match(chunk)
                if modem.debug then print("AT says: ","+CSQ", tostring(modem.interval.signal).."ms", signal, "","","","Note: Signal strength, 0..31") end
				if signal and signal ~= "" then
					modem:update_state("signal", signal, "AT+CSQ", "")
				end
			elseif chunk:find("+CUSD:") then
				local bal = modem:balance_parsing_and_update(chunk)
                if modem.debug then print("AT says: ","+CUSD", tostring(modem.interval.balance).."ms", bal, "","","","Note: Sim balance, rub.") end
				--[[ Parse and update 3G/4G mode ]]
			elseif chunk:find("+CNSMOD:") then
				local netmode = CNSMOD_parser:match(chunk) or ""
				if((tonumber(netmode) ~= nil) and tonumber(netmode) <= 16) then
					if(CNSMODES[netmode] ~= nil) then
						modem:update_state("netmode", CNSMODES[netmode]:split("|")[2]:gsub("%s+", "") or "", "AT+CNSMOD?", CNSMODES[netmode])
					else
						modem:update_state("netmode", netmode, "AT+CNSMOD?", CNSMODES["0"])
					end
				end
                if modem.debug then
                    local cnsmode = CNSMODES[netmode] or " | "
                    print("AT says: ","+NSMOD", tostring(modem.interval.netmode).."ms", cnsmode:split("|")[2]:gsub("%s+", "") or "", "","","","Note: GSM mode")
                end
			elseif chunk:find("+NITZ") then
				local pname = provider_name:match(chunk)
				if pname and pname ~= "" then
					modem:update_state("provider_name", pname, "+NITZ", "")
				end
                if modem.debug then print("AT says: ","+NITZ", tostring(modem.interval.provider).."ms", pname, "","","","Note: Cell provider name") end
            elseif chunk:find("+COPS:") then
				local pcode = chunk:split('\"')
                local pname = ""
				if pcode and pcode[2] then
                    uci:foreach(config_gsm, "adapter", function(sec)
                        if sec.code == pcode[2] then
                            pname = sec.name
                            modem:update_state("provider_name", pname, "AT+COPS?", "")
                        end
                    end)
				end
                if modem.debug then print("AT says: ","+COPS", tostring(modem.interval.provider).."ms", pname, "","","","Note: Cell provider name") end
			else
				--print("LAST_AT")
				--print(chunk)
				local last_at = chunk
				if last_at and last_at ~= "" then
					modem:update_state("last_at", last_at, "", "")
				end
			end
		end, uloop.ULOOP_READ)
	end

end

function modem:unpoll()
	if(self.fds_ev) then
		self.fds_ev:delete()
		self.fds_ev = nil
	end
end



local metatable = {
	__call = function(table, ...)
		table.state = modem_state

		table:make_ubus()
		table:init_mk()

		uloop.init()
		modem:poll()

		local timer
		function t()
			modem:init()
			modem:poll()

			timer:set(modem.tick_size)
		end
		timer = uloop.timer(t)
		timer:set(modem.tick_size)


		local timer_CREG
		function t_CREG()
			if(modem:is_connected(modem.fds)) then
				local chunk, err, errcode = U.write(modem.fds, "AT+CREG?" .. "\r\n")
			end

			timer_CREG:set(modem.interval.reg)
		end
		timer_CREG = uloop.timer(t_CREG)
		timer_CREG:set(modem.interval.reg)



		local timer_CSQ
		function t_CSQ()
			if(modem:is_connected(modem.fds)) then
				local chunk, err, errcode = U.write(modem.fds, "AT+CSQ" .. "\r\n")
			end

			timer_CSQ:set(modem.interval.signal)
		end
		timer_CSQ = uloop.timer(t_CSQ)
		timer_CSQ:set(modem.interval.signal)


		local timer_CUSD
		function t_CUSD()
			if(modem:is_connected(modem.fds)) then
				--[[ Get balance only if SIM is registered in the GSM network ]]

				local ok, err, reg = modem:get_state("reg", "value")
				if ok and reg == "1" then
					local ok, err, sim_id = modem:get_state("sim", "value")
					if ok then
						if(sim_id == "0" or sim_id =="1") then
							local ok, err, last_balance_time = modem:get_state("balance", "time")
							if (tonumber(last_balance_time) and (last_balance_time ~= "0")) then
								local timecount = os.time() - tonumber(last_balance_time)
								if( timecount >= modem.interval.balance/1000 ) then
                                    --[[ Avoid noise in USSD requests ]]
                                    if (os.time() - modem.last_balance_request_time) > modem.balance_repeated_request_delay then
    									local provider_id = modem:get_provider_id(sim_id)
                                        if modem.debug then print("----------------------->>> Sending BALANCE REQUEST one time per "..tostring(modem.interval.balance/1000).."sec") end
    									local ussd_command = string.format("AT+CUSD=1,%s,15\r\n", uci:get(config_gsm, provider_id, "balance_ussd"))
                                        modem.last_balance_request_time = os.time()
    									-- TODO local chunk, err, errcode = U.write(modem.fds, ussd_command)
                                    end
								end
							end
							timer_CUSD:set(1000)
						end
					else
						util.perror("ERROR: sim or value not found in state.")
					end
				else
					timer_CUSD:set(1000)
				end
			else
				timer_CUSD:set(1000)
			end
		end
		timer_CUSD = uloop.timer(t_CUSD)
		timer_CUSD:set(1000)

		local timer_COPS
		function t_COPS()
			if(modem:is_connected(modem.fds)) then
				local chunk, err, errcode = U.write(modem.fds, "AT+COPS?" .. "\r\n")
			end
			timer_COPS:set(modem.interval.provider)
		end
		timer_COPS = uloop.timer(t_COPS)
		timer_COPS:set(modem.interval.provider)


        -- [[ Ping Google to check internet connection ]]
        local timer_PING
		function t_PING()
            function p1(r) --[[ call back is empty as not needed now. ]] end

            local _,_,sim_id = modem:get_state("sim", "value")
            local host = "8.8.8.8"
            local host_spc_sim = string.format("%s %s", host, sim_id)

            uloop.process("/usr/lib/lua/luci/model/tsmodem/util/ping.sh", {"--host", host_spc_sim }, {"PROCESS=1"}, p1)
			timer_PING:set(modem.interval.ping)
		end
		timer_PING = uloop.timer(t_PING)
		timer_PING:set(modem.interval.ping)


        --[[ Get 3G/4G status ]]
        local timer_CNSMOD
        function t_CNSMOD()
        	if(modem:is_connected(modem.fds)) then
                local _,_,reg = modem:get_state("reg", "value")
                if reg == "1" then
            		local chunk, err, errcode = U.write(modem.fds, "AT+CNSMOD?" .. "\r\n")
            		--local chunk, err, errcode = U.write(modem.fds, "AT+CNSMOD=1" .. "\r\n")
                end
        	end
            timer_CNSMOD:set(modem.interval.netmode)
        end
		timer_CNSMOD = uloop.timer(t_CNSMOD)
		timer_CNSMOD:set(modem.interval.netmode)
		-- [[ ]]

		uloop.run()
		table.conn:close()
		return table
	end
}
setmetatable(modem, metatable)
modem()
