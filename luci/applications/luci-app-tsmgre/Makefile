
# Copyright 2017-2020 Dirk Brenken (dev@brenken.org)
# This is free software, licensed under the Apache License, Version 2.0

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Tsmodem Tsmodem GRE
LUCI_DESCRIPTION:=Tsmodem GRE tunnel UI
LUCI_DEPENDS:=
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-tsmgre
PKG_VERSION:=1.0.0
PKG_RELEASE:=20250213
PKG_LICENSE:=GPL-3.0-or-later

include $(TOPDIR)/feeds/luci/luci.mk

$(eval $(call BuildPackage,$(PKG_NAME)))
