module("luci.controller.tsmodem.index", package.seeall)

local config = "tsmodem"
local config_gsm = "tsmodem_adapter_provider"
local http = require "luci.http"
local uci = require "luci.model.uci".cursor()
local util = require "luci.util"
local ubus = require "ubus"
local log = require "tsmodem.util.log"


function index()
	if nixio.fs.access("/etc/config/tsmodem") then
		-- SIM cards setting page
		entry({"admin", "system", "sim_list"}, cbi("tsmodem/main"), translate("SIM cards settings"), 30)
		entry({"admin", "system", "sim_list", "action"}, call("do_sim_action"), nil).leaf = true

		-- SMS commands setting page
		entry({"admin", "system", "sms_commands"}, cbi("tsmodem/sms_commands"), translate("Управление по SMS"), 30)
		--entry({"admin", "system", "sms_commands", "action"}, call("sms_commands_update"), nil).leaf = true
		entry({"admin", "system", "sms_commands", "action"}, call("save_update_delete_phone"), nil).leaf = true
		entry({"admin", "system", "sms_commands", "action"}, call("action_sms"), nil).leaf = true
	end
end


function do_sim_action(action, sim_id)
	local payload = {}


	payload["sim_data"] = luci.jsonc.parse(luci.http.formvalue("sim_data"))
	payload["gsm_data"] = luci.jsonc.parse(luci.http.formvalue("adapter_data"))

	local commands = {
		switch = function(sim_id, ...)
			local conn = ubus.connect()
			if not conn then
				error("do_sim_switch_action - Failed to connect to ubus")
			end

			--[[ glear modem states ]]
			 util.ubus("tsmodem.driver", "clear_state", {})

			local resp = conn:call("tsmodem.driver", "do_switch", {})
		end,

		edit = function(sim_id, payloads)
			local allowed_sim_options = {
				"name",
				"provider",
				"balance_min",
				"signal_min",
				"timeout_bal",
				"timeout_signal",
				"timeout_reg",
				"timeout_link",
				"timeout_sim_absent",
				"timeout_ping",
				"autodetect_provider"
			}
			local allowed_gsm_options = {
				"name",
				"gate_address",
				"balance_ussd",
				"balance_mask",
			}

			for key, value in pairs(payloads["sim_data"]) do
				if util.contains(allowed_sim_options, key) then
					local ok = uci:set(config, "sim_" .. sim_id, key, value)
				end
				local ok = uci:commit(config)
			end

			local provider_id = payloads["sim_data"].provider
			for key, value in pairs(payloads["gsm_data"][provider_id]) do
				if util.contains(allowed_gsm_options, key) then
					local ok = uci:set(config_gsm, provider_id, key, value)
				end
			end
			local ok = uci:commit(config_gsm)


			--[[
			Update APN in the TSMODEM interface only if active SIN is editing.
			We have not to update APN if inactive SIM is editting, because we may break active connection.
			]]
			local resp_table = util.ubus("tsmodem.driver", "sim", {})
			local active_sim = resp_table["value"] or ""

			if (sim_id == active_sim) then
				local provider_id = uci:get(config, "sim_" .. sim_id, "provider")
				local apn_provider = uci:get(config_gsm, provider_id, "gate_address") or "APNP"
				local apn_network = uci:get("network", "tsmodem", "apn") or "APNN"

				if(apn_provider ~= apn_network) then
					uci:set("network", "tsmodem", "apn", apn_provider)
					uci:save("network")
					uci:commit("network")
				end
			end

			--[[ glear modem states ]]
			-- util.ubus("tsmodem.driver", "clear_state", {})
		end,

		default = function(...)
			http.prepare_content("text/plain")
			http.write("0")
		end
	}
	if commands[action] then
		commands[action](sim_id, payload)
		commands["default"]()
	end
end

function sms_commands_update(action)
	local payload = {}

	payload["sms_commands"] = luci.jsonc.parse(luci.http.formvalue("sms_commands"))

	local commands = {

		--[[ TODO: переписать данную функцию применительно к задаче сохранения SMS-команд в конфиге]]
		edit = function(payloads)
			local allowed_sim_options = {
				"name",
				"provider",
				"balance_min",
				"signal_min",
				"timeout_bal",
				"timeout_signal",
				"timeout_reg",
				"timeout_link",
				"timeout_sim_absent",
				"timeout_ping",
				"autodetect_provider"
			}
			local allowed_gsm_options = {
				"name",
				"gate_address",
				"balance_ussd",
				"balance_mask",
			}

			for key, value in pairs(payloads["sim_data"]) do
				if util.contains(allowed_sim_options, key) then
					local ok = uci:set(config, "sim_" .. sim_id, key, value)
				end
				local ok = uci:commit(config)
			end

			local provider_id = payloads["sim_data"].provider
			for key, value in pairs(payloads["gsm_data"][provider_id]) do
				if util.contains(allowed_gsm_options, key) then
					local ok = uci:set(config_gsm, provider_id, key, value)
				end
			end
			local ok = uci:commit(config_gsm)


			--[[
			Update APN in the TSMODEM interface only if active SIN is editing.
			We have not to update APN if inactive SIM is editting, because we may break active connection.
			]]
			local resp_table = util.ubus("tsmodem.driver", "sim", {})
			local active_sim = resp_table["value"] or ""

			if (sim_id == active_sim) then
				local provider_id = uci:get(config, "sim_" .. sim_id, "provider")
				local apn_provider = uci:get(config_gsm, provider_id, "gate_address") or "APNP"
				local apn_network = uci:get("network", "tsmodem", "apn") or "APNN"

				if(apn_provider ~= apn_network) then
					uci:set("network", "tsmodem", "apn", apn_provider)
					uci:save("network")
					uci:commit("network")
				end
			end

			--[[ glear modem states ]]
			-- util.ubus("tsmodem.driver", "clear_state", {})
		end,

		default = function(...)
			http.prepare_content("text/plain")
			http.write("0")
		end
	}
	if commands[action] then
		commands[action](sim_id, payload)
		commands["default"]()
	end
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
				local uci_id = uci:add("tsmodem_sms_commands","remote_control")
				resp["uci_id"] = uci_id

				payload['command'] = action
				payload['uci_id'] = uci_id
				uci:set("tsmodem_sms_commands", payload["uci_id"], "trusted_phone", payload["phone"])
				uci:set("tsmodem_sms_commands", payload["uci_id"], "trusted_email", payload["email"])
				uci:save("tsmodem_sms_commands")

			else
				uci:set("tsmodem_sms_commands", payload["uci_id"], "trusted_phone", payload["phone"])
				uci:set("tsmodem_sms_commands", payload["uci_id"], "trusted_email", payload["email"])
				uci:save("tsmodem_sms_commands")
			end
			uci:commit("tsmodem_sms_commands")

		end,

		delete = function(payload)

			uci:delete("tsmodem_sms_commands", payload["uci_id"])
			uci:save("tsmodem_sms_commands")
			uci:commit("tsmodem_sms_commands")
			

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
				local uci_id = uci:add("tsmodem_sms_commands","sms_command")
				resp["uci_id"] = uci_id

				payload['command'] = action
				payload['uci_id'] = uci_id
				uci:set("tsmodem_sms_commands", payload["uci_id"], "sms_command", payload["smscomm"])
				uci:set("tsmodem_sms_commands", payload["uci_id"], "shell_command", payload["shellcomm"])
				uci:save("tsmodem_sms_commands")

			else
				uci:set("tsmodem_sms_commands", payload["uci_id"], "sms_command", payload["smscomm"])
				uci:set("tsmodem_sms_commands", payload["uci_id"], "shell_command", payload["shellcomm"])
				uci:save("tsmodem_sms_commands")
			end
			uci:commit("tsmodem_sms_commands")

		end,

		delete = function(payload)

			uci:delete("tsmodem_sms_commands", payload["uci_id"])
			uci:save("tsmodem_sms_commands")
			uci:commit("tsmodem_sms_commands")
			

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