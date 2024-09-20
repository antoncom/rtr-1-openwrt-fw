local config, title = "vpn", "IPSec client"

m = Map(config, title)
m.template = "vpnconfig/ipsec"
m.pageaction = false

return m