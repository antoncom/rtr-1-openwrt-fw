local fs  = require "nixio.fs"
local sys = require "luci.sys"
local uci = require "luci.model.uci".cursor()

local config, title = "tsmodem", "Sim list"

local m = Map(config, title)

m.template = "tsmodem/sim_list"
m.pageaction = false

return m
