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
		entry({"admin", "system", "sim_list"}, cbi("tsmodem/main"), translate("SIM cards settings"), 30)
		entry({"admin", "system", "sim_list", "action"}, call("do_sim_action"), nil).leaf = true
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

			--[[ try to get balance ]]
			util.ubus("tsmodem.driver", "do_request_ussd_balance", { ["sim_id"] = sim_id })
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
