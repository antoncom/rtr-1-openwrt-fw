local config, title = "vpn", "L2TP client"

m = Map(config, title)
m.template = "vpnconfig/l2tp"
m.pageaction = false

return m