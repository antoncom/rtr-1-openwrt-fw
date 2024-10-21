
# Copyright 2017-2020 Dirk Brenken (dev@brenken.org)
# This is free software, licensed under the Apache License, Version 2.0

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI TsmGpio MVC
LUCI_DESCRIPTION:=Tsmodem GPIO setting LuCI webpage for edit GPIO UCI setting
LUCI_DEPENDS:=+luci-mod-tsmodem-ui
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-tsmgpio
PKG_VERSION:=3.0.1
PKG_RELEASE:=20241021
PKG_LICENSE:=GPL-3.0-or-later

include $(TOPDIR)/feeds/luci/luci.mk

$(eval $(call BuildPackage,$(PKG_NAME)))
