local config, title = "vpn", "GRE client"

m = Map(config, title)
m.template = "vpnconfig/gre"
m.pageaction = false

return m