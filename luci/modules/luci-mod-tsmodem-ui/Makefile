
# Copyright 2017-2020 Dirk Brenken (dev@brenken.org)
# This is free software, licensed under the Apache License, Version 2.0

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI TechnoSkver RTR02 UI module
LUCI_DESCRIPTION:=UI module for Double SIM management for Skw92A with Sim7600 modem integration.
LUCI_TYPE:=mod

PKG_NAME:=luci-mod-tsmodem-ui
PKG_VERSION:=2.2.0
PKG_RELEASE:=20221120
PKG_LICENSE:=GPL-3.0-or-later

include $(TOPDIR)/feeds/luci/luci.mk

define Package/$(PKG_NAME)/install
    # Daemon
    $(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/rc.d
    $(INSTALL_BIN) $(PKG_BUILD_DIR)/files/gwsocket.init $(1)/etc/init.d/gwsocket
    $(INSTALL_DIR) $(1)/usr/sbin
    $(INSTALL_BIN) $(PKG_BUILD_DIR)/files/gwsocket.sh $(1)/usr/sbin/gwsocket
endef


define Package/$(PKG_NAME)/prerm
	#!/bin/sh
	rm /usr/bin/gwsocket
endef

# call BuildPackage - OpenWrt buildroot signature
# $(eval $(call BuildPackage,$(PKG_NAME)))
