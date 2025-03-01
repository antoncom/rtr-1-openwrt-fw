-- Copyright 2015 Daniel Dickinson <openwrt@daniel.thecshore.com>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.tsmgre.index", package.seeall)

local http = require "luci.http"
local uci = require "luci.model.uci".cursor()
local util = require "luci.util"
local sys  = require "luci.sys"
local ubus = require "ubus"
local conn = ubus.connect()


local dummy_cfg_content = 'config tsmgre \'tsmgre\'\n'
local uploadDir = "/etc/config/vpnconfig_files"

function index()
	if not nixio.fs.access("/etc/config/tsmgre") then
		nixio.syslog("crit", "create file /etc/config/tsmgre")
		nixio.fs.writefile("/etc/config/tsmgre", dummy_cfg_content);
	end
	if not nixio.fs.access("/etc/config/vpnconfig_files") then
		nixio.syslog("crit", "create directory ".. uploadDir)
		nixio.fs.mkdir(uploadDir);
	end

	entry({"admin", "services", "tsmgre"},   cbi("tsmgre/tsmgre"),   _("GRE-tunnel"), 30).leaf = true
	entry({"admin", "services", "tsmgre_2", "action"}, call("do_action"), nil).leaf = true

	
end

function do_action(action)
	local config = 'tsmgre'
	local data = {}
	local payload = luci.jsonc.parse(luci.http.content())

	data.vpnType = payload["type"]
	data.name = payload["name"]
	data.isActive = payload["isActive"]
	if payload["options"] then
		data.options = payload["options"]
	end


	local commands = {
		add= function(...)
			uci:section(config, data.vpnType, data.name, data.options)
			uci:set(config, data.name, 'isActive', 'false')
			return run_network_add(data)

		end,

		edit = function(...)
			for key, value in pairs(data.options) do
				uci:set(config, 'tsmgre', key, value)
			end
			return run_network_edit(data)
		end,

		delete = function(...)
			uci:delete(config, data.name)
			return run_network_delete(data)
		end,

		enable = function(...)
			uci:set(config, data.name, 'isActive', data.isActive)
			for key, value in pairs(data.options) do
				uci:set(config, 'tsmgre', key, value)
			end
			return run_network_enable(data)
		end,

		upload_file = function(...)
			local file_name
			local file
			local finished = false
			nixio.syslog("crit", "setfilehandler")
			luci.http.setfilehandler(
				function(meta, chunk, eof)
					if finished then
						nixio.syslog("crit", "filehandler call after eof to "..file_name)
						return
					end
					if not file then
						file_name = uploadDir .. "/" .. data.name .. "_" .. meta.file
						file = io.open(file_name, "w")
						nixio.syslog("crit", "create file "..file_name)
					end
					if chunk then
						file:write(chunk)
						nixio.syslog("crit", "write chunk to "..file_name)
					end
					if eof then
						file:close()
						nixio.syslog("crit", "close file "..file_name)
						finished = true
					end
				end
			)
			return finished
		end,
	}

	function send_response(code, message)
		local response = {}
		response.action = action
		response.message = message

		if code == 200 then
			response.status = 'success'
		else
			response.status = 'error'
		end
	
		http.status(code)
		http.prepare_content("application/json")
		http.write(util.serialize_json(response))
	end

	if commands[action] then
		local success, errmsg = commands[action]()
		if (success) then
			send_response(200, "Configuration applyed successfully")
			-- uci:commit(config)
			-- if (data.isActive == '0') then
			-- 	conn:call("network.interface.tsmgre", "down", {})
			-- elseif (data.isActive == '1') then
			-- 	conn:call("network.interface.tsmgre", "up", {})
			-- end
			-- conn:close()

		else
			send_response(500, errmsg)
			uci:revert(config)
			uci:revert("network")
		end
	else
		send_response(400, 'Unexpected GRE config action')
	end
end

function run_network_add(data)
	local action = "add"
	local greExt = {}
	local greInt = {}

	local ifname = data.options.localAddr

	--[[ getLocalIp() => value, errmsg ]]
	--[[ ----------------------------- ]]
	local getLocalIp = function(ifname) 
		local ifstatus = util.ubus("network.interface."..ifname, "status", {})

		if not ifstatus then return false, string.format("Ошибка: отсутствует интерфейс [%s].", ifname) end
		local ifaddr = ifstatus["ipv4-address"] and (#ifstatus["ipv4-address"] > 0) and ifstatus["ipv4-address"][1].address
		
		if not ifaddr then return false, string.format("Ошибка: не найден IP-адрес сервера для интерфейса [%s].", ifname) end
		return ifaddr, "OK"
	end
	--[[ ----------------------------- ]]
	local localAddr, errmsg = getLocalIp(data.options.localAddr)
	if not localAddr then return false, errmsg end

	greExt = {
		proto = "gre",
		peeraddr = data.options.remoteAddr,
		ipaddr = localAddr
	}
	greInt = {
		proto = "static",
		device = "@GREext",
		ipaddr = data.options.tunnelIp,
		netmask = data.options.tunnelMask
	}
	uci:section("network", "interface", "GREext", greExt)
	uci:section("network", "interface", "GREint", greInt)
	local uciOk = uci:save("network") and uci:apply(true)
	if (uciOk) then 
		uci:commit("network")
	else
		uci:revert("network")
		return false, "Ошибка: не удалось применить настройки [network]."
	end

	return true, "OK" -- 'true' on success, 'false' on error
end


function run_network_edit(data)
	local action = "edit"
	local greExt = {}
	local greInt = {}

	local ifname = data.options.localAddr

	--[[ getLocalIp() => value, errmsg ]]
	--[[ ----------------------------- ]]
	local getLocalIp = function(ifname) 
		local ifstatus = util.ubus("network.interface."..ifname, "status", {})

		if not ifstatus then return false, string.format("Ошибка: отсутствует интерфейс [%s].", ifname) end
		local ifaddr = ifstatus["ipv4-address"] and (#ifstatus["ipv4-address"] > 0) and ifstatus["ipv4-address"][1].address
		
		if not ifaddr then return false, string.format("Ошибка: не найден IP-адрес сервера для интерфейса [%s].", ifname) end
		return ifaddr, "OK"
	end
	--[[ ----------------------------- ]]
	local localAddr, errmsg = getLocalIp(data.options.localAddr)
	if not localAddr then return false, errmsg end

	greExt = {
		proto = "gre",
		peeraddr = data.options.remoteAddr,
		ipaddr = localAddr
	}
	greInt = {
		proto = "static",
		device = "@GREext",
		ipaddr = data.options.tunnelIp,
		netmask = data.options.tunnelMask
	}
	uci:tset("network", "GREext", greExt)
	uci:tset("network", "GREint", greInt)
	local uciOk = uci:save("network") and uci:apply(true)
	if (uciOk) then 
		uci:commit("network")
	else
		uci:revert("network")
		return false, "Ошибка: не удалось применить настройки [network]."
	end

	return true, "OK" -- 'true' on success, 'false' on error
end

function run_network_enable(data)
	local action = "enable"

	return true, "OK" -- 'true' on success, 'false' on error
end

function run_network_delete(data)
	local action = "delete"

	uci:delete("network", "GREint")
	uci:delete("network", "GREext")
	
	local uciOk = uci:save("network") and uci:apply(true)
	if (uciOk) then 
		uci:commit("network")
	else
		uci:revert("network")
		return false, "Ошибка: не удалось удалить настройки [network]."
	end

	return true, "OK" -- 'true' on success, 'false' on error
end