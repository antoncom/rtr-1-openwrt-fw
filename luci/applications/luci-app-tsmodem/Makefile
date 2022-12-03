
# Copyright 2017-2020 Dirk Brenken (dev@brenken.org)
# This is free software, licensed under the Apache License, Version 2.0

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI TechnoSkver RTR01
LUCI_DESCRIPTION:=Double SIM management for Skw92A with Sim7600 modem integration.
LUCI_DEPENDS:=+tsmodem
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-tsmodem
PKG_VERSION:=2.3
PKG_RELEASE:=20221120
PKG_LICENSE:=GPL-3.0-or-later

include $(TOPDIR)/feeds/luci/luci.mk

$(eval $(call BuildPackage,$(PKG_NAME)))
