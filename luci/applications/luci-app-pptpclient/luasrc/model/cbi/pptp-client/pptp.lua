local config, title = "vpn", "PPTP client"

m = Map(config, title)
m.template = "pptp-client/pptp"
m.pageaction = false


return m