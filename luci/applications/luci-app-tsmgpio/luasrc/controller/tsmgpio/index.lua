-- Copyright 2015 Daniel Dickinson <openwrt@daniel.thecshore.com>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.tsmgpio.index", package.seeall)

local http = require "luci.http"
local uci = require "luci.model.uci".cursor()
local util = require "luci.util"

function index()
--	if not nixio.fs.access("/etc/config/gpio") then
--		nixio.syslog("crit", "create file /etc/config/gpio")
--		nixio.fs.writefile("/etc/config/gpio", dummy_gpio_content);
--	end
--	if not nixio.fs.access("/etc/config/gpio_files") then
--		nixio.syslog("crit", "create directory ".. uploadDir)
--		nixio.fs.mkdir(uploadDir);
--	end
	if nixio.fs.access("/etc/config/tsmgpio") then
		entry({"admin", "services", "tsmgpio"}, cbi("tsmgpio/main"),   _("GPIO"), nil).leaf = true
		entry({"admin", "services", "tsmgpio_set", "action"}, call("gpio_action"), nil).leaf = true
	end

end

function gpio_action(action)

	local resp = {
		["command"] = action,
	}
	
	local commands = {

		save = function(payload)

			util.dumptable(luci.jsonc.parse(luci.http.content()))
			local post_data = luci.jsonc.parse(luci.http.content())

			uci_data = {}
			uci_data["general"] = post_data["general"]
			uci_data["gpio"] = post_data["gpio"]

			uci:set("tsmgpio", "general", "isActive", uci_data["general"].isActive)

			for _, gpio in util.kspairs(uci_data["gpio"]) do
				for optname, optvalue in util.kspairs(gpio) do
					if(optname ~= "name") then
						uci:set("tsmgpio", gpio.name, optname, optvalue)
					end
				end
			 	uci:save("tsmgpio")
			 	uci:commit("tsmgpio")
			end
		end,

		default = function(...)
			http.prepare_content("application/json")
			http.write(util.serialize_json(uci_data))
		end
	}
	if commands[action] then
		commands[action](payload)
	end
	commands["default"]()
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