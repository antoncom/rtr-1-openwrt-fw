local config, title = "vpn", "PPTP client"

m = Map(config, title)
m.template = "vpnconfig/pptp"
m.pageaction = false

return m