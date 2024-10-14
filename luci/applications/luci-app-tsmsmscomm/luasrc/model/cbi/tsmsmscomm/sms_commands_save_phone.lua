
local config, title = "tsmsmscomm", "SMS commands"

m = Map(config, title)
m.template = "tsmsmscomm/sms_commands_save_phone"
m.pageaction = false

return m
