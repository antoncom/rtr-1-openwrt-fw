-- Copyright 2015 Daniel Dickinson <openwrt@daniel.thecshore.com>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.vpnconfig.index", package.seeall)

local http = require "luci.http"
local uci = require "luci.model.uci".cursor()

local dummy_cfg_content = 'config pptp \'pptp1\'\n\nconfig l2tp \'l2tp1\'\n'
local uploadDir = "/etc/config/vpnconfig_files"

function index()
	if not nixio.fs.access("/etc/config/vpnconfig") then
		nixio.syslog("crit", "create file /etc/config/vpnconfig")
		nixio.fs.writefile("/etc/config/vpnconfig", dummy_cfg_content);
	end
	if not nixio.fs.access("/etc/config/vpnconfig_files") then
		nixio.syslog("crit", "create directory ".. uploadDir)
		nixio.fs.mkdir(uploadDir);
	end

	entry({"admin", "services", "vpnconfig", "action"}, call("do_action"), nil).leaf = true
	
	entry({"admin", "services", "pptp"},   cbi("vpnconfig/pptp"),   _("PPTP Client"), 30).leaf = true
	entry({"admin", "services", "l2tp"},   cbi("vpnconfig/l2tp"),   _("L2TP Client"),   40).leaf = true
	entry({"admin", "services", "gre"},    cbi("vpnconfig/gre"),    _("GRE Client"),    50).leaf = true
	entry({"admin", "services", "dmvpn"},  cbi("vpnconfig/dmvpn"),  _("DMVPN Tunnels"),  60).leaf = true
	entry({"admin", "services", "eoip"},   cbi("vpnconfig/eoip"),   _("EoIP Tunnels"),   70).leaf = true
	entry({"admin", "services", "l2tpv3"}, cbi("vpnconfig/l2tpv3"), _("L2TPv3 Tunnels"), 80).leaf = true
	entry({"admin", "services", "ipsec"},  cbi("vpnconfig/ipsec"),  _("IPSec Tunnels"),  90).leaf = true

end

function do_action(action)
	local config = 'vpnconfig'
	local data = {}
	data.vpnType = luci.http.formvalue("type")
	data.name = luci.http.formvalue("name")
	data.isActive = luci.http.formvalue("isActive")
	if luci.http.formvalue("options") then
		data.options = luci.jsonc.parse(luci.http.formvalue("options"))
	end

	local commands = {
		add= function(...)
			uci:section(config, data.vpnType, data.name, data.options)
			uci:set(config, data.name, 'isActive', 'false')
			return run_backend_script(action, data)

		end,

		edit = function(...)
			for key, value in pairs(data.options) do
				uci:set(config, data.name, key, value)
			end
			return run_backend_script(action, data)
		end,

		delete = function(...)
			uci:delete(config, data.name)
			return run_backend_script(action, data)
		end,

		enable = function(...)
			uci:set(config, data.name, 'isActive', data.isActive)
			return run_backend_script(action, data)
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
		http.prepare_content("text/json")
		http.write_json(response)
	end

	if commands[action] then
		local success = commands[action]()
		if (success) then
			send_response(200, "Configuration applyed successfully")
			uci:commit(config)
		else
			send_response(500, "Failed to apply configuration")
			uci:revert(config)
		end
	else
		send_response(400, 'Unexpected vpnconfig action')
	end
end

function run_backend_script(action, data)
	-- TODO: call actual network configuration scripts

	-- action - add | edit | delete | enable
	-- data: 
	--    data.vpnType - type of uci config section
	--    data.name - name of uci config section
	--    data.isActive - is this VPN client enabled
	--    data.options - object with VPN client parameters - see on corresponding client page
	
	-- UCI changes will be committed if this function return 'true'. Otherwise UCI changes will be reverted.
	
	-- For IPSec - check for public key files in uploadDir
	-- their names are stored in:
	--    data.options['fileCaCertificate']
	--    data.options['fileLocalCertificate']
	--    data.options['filePubkey'] 

	return true -- 'true' on success, 'false' on error
end