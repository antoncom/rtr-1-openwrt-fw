
local config, title = "tsmodem", "SMS commands"

m = Map(config, title)
m.template = "tsmodem/sms_commands_save_phone"
m.pageaction = false

return m
