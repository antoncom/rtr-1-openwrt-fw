
# Copyright 2017-2020 Dirk Brenken (dev@brenken.org)
# This is free software, licensed under the Apache License, Version 2.0

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI Tsmconsole View
LUCI_DESCRIPTION:=Tsmodem helper module is used to provide websocket support for "Web-console of AT-commands feature".
LUCI_DEPENDS:=+tsmconsole
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-tsmconsole
PKG_VERSION:=2.5.1
PKG_RELEASE:=20230524
PKG_LICENSE:=GPL-3.0-or-later

include $(TOPDIR)/feeds/luci/luci.mk

$(eval $(call BuildPackage,$(PKG_NAME)))
