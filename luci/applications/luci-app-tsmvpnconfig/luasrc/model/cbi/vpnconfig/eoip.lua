local config, title = "vpn", "EoIP client"

m = Map(config, title)
m.template = "vpnconfig/eoip"
m.pageaction = false

return m