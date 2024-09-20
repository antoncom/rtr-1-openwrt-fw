local config, title = "vpn", "DMVPN client"

m = Map(config, title)
m.template = "vpnconfig/dmvpn"
m.pageaction = false

return m