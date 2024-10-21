local util = require "luci.util"
local flist = require "luci.model.tsmodem.filelist"
local adprov = require "luci.model.tsmodem.adapter.tsmodem_adapter_provider"




local adapter_path = util.libpath() .. "/model/tsmodem/adapter"
local files = flist({path = adapter_path, grep = ".lua"})

local at, adapter_type = {}, ''
local adapter_models = {}

adapter_models["tsmodem_adapter_provider"] = adprov

-- for i=1, #files do
-- 	adapter_type = util.split(files[i], '.lua')[1]
-- 	util.perror("====== adapter_type ======")
-- 	util.perror(adapter_type)
-- 	--adapter_models[adapter_type] = require("luci.model.tsmodem.adapter." .. adapter_type)
-- end

return adapter_models
