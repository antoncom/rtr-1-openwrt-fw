
# Copyright 2017-2020 Dirk Brenken (dev@brenken.org)
# This is free software, licensed under the Apache License, Version 2.0

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI TechnoSkver RTR01 UI module
LUCI_DESCRIPTION:=UI module for Double SIM management for Skw92A with Sim7600 modem integration.
LUCI_TYPE:=mod

PKG_NAME:=luci-mod-tsmodem-ui
PKG_VERSION:=1.8.5
PKG_RELEASE:=20220513
PKG_LICENSE:=GPL-3.0-or-later


define Package/$(PKG_NAME)/prerm
	#!/bin/sh
	rm /usr/sbin/gwsocket
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
