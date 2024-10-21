module("luci.controller.tsmsmscomm.index", package.seeall)

local config = "tsmsmscomm"
local http = require "luci.http"
local uci = require "luci.model.uci".cursor()
local util = require "luci.util"
local ubus = require "ubus"
local log = require "tsmodem.util.log"

function index()

		-- SMS commands setting page
		entry({"admin", "system", "sms_commands"}, cbi("tsmsmscomm/sms_commands"), "Управление по SMS", 99).leaf = true
		entry({"admin", "system", "sms_commands_2", "action"}, call("save_update_delete_phone"))
		entry({"admin", "system", "sms_commands_3", "action"}, call("action_sms"))
end

function save_update_delete_phone()
	local payload = luci.jsonc.parse(luci.http.content())
	local action = payload["action"]

	local resp = {
		["command"] = action,
	}
	
	local commands = {

		save = function(payload)

			if (payload["uci_id"] == "new") then
				local uci_id = uci:add(config,"remote_control")
				resp["uci_id"] = uci_id

				payload['command'] = action
				payload['uci_id'] = uci_id
				uci:set(config, payload["uci_id"], "trusted_phone", payload["phone"])
				uci:set(config, payload["uci_id"], "trusted_email", payload["email"])
				uci:save(config)

			else
				uci:set(config, payload["uci_id"], "trusted_phone", payload["phone"])
				uci:set(config, payload["uci_id"], "trusted_email", payload["email"])
				uci:save(config)
			end
			uci:commit(config)

		end,

		delete = function(payload)

			uci:delete(config, payload["uci_id"])
			uci:save(config)
			uci:commit(config)
			

		end,


		default = function(...)
			http.prepare_content("application/json")
			http.write(util.serialize_json(payload))
		end
	}
	if commands[action] then
		commands[action](payload)
	end
	commands["default"]()
end



function action_sms()
	local payload = luci.jsonc.parse(luci.http.content())
	local action = payload["action"]

	local resp = {
		["command"] = action,
	}
	
	local commands = {

		save = function(payload)

			if (payload["uci_id"] == "new") then
				local uci_id = uci:add(config,"sms_command")
				resp["uci_id"] = uci_id

				payload['command'] = action
				payload['uci_id'] = uci_id
				uci:set(config, payload["uci_id"], "sms_command", payload["smscomm"])
				uci:set(config, payload["uci_id"], "shell_command", payload["shellcomm"])
				uci:save(config)

			else
				uci:set(config, payload["uci_id"], "sms_command", payload["smscomm"])
				uci:set(config, payload["uci_id"], "shell_command", payload["shellcomm"])
				uci:save(config)
			end
			uci:commit(config)

		end,

		delete = function(payload)

			uci:delete(config, payload["uci_id"])
			uci:save(config)
			uci:commit(config)
			

		end,


		default = function(...)
			http.prepare_content("application/json")
			http.write(util.serialize_json(payload))
		end
	}
	if commands[action] then
		commands[action](payload)
	end
	commands["default"]()
end