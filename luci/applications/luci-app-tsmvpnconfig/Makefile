
# Copyright 2017-2020 Dirk Brenken (dev@brenken.org)
# This is free software, licensed under the Apache License, Version 2.0

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Tsmodem VPN configs web MVC
LUCI_DESCRIPTION:=UI/config make settings for PPTP, L2TPv2, GRE clients; DMVPN/NHRP; EoIP, L2TPv3, IPSec tunnels
LUCI_DEPENDS:=
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-tsmvpnconfig
PKG_VERSION:=1.0.0
PKG_RELEASE:=20240920
PKG_LICENSE:=GPL-3.0-or-later

include $(TOPDIR)/feeds/luci/luci.mk

$(eval $(call BuildPackage,$(PKG_NAME)))
