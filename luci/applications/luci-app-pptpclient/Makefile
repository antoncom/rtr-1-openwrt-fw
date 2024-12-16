
# Copyright 2017-2020 Dirk Brenken (dev@brenken.org)
# This is free software, licensed under the Apache License, Version 2.0

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Tsmodem PPTP-Client
LUCI_DESCRIPTION:=Tsmodem PPTP-Client configutation UI
LUCI_DEPENDS:=
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-pptpclient
PKG_VERSION:=3.0.1
PKG_RELEASE:=20241216
PKG_LICENSE:=GPL-3.0-or-later

include $(TOPDIR)/feeds/luci/luci.mk

$(eval $(call BuildPackage,$(PKG_NAME)))
