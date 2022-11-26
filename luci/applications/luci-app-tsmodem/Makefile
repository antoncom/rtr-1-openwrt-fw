
# Copyright 2017-2020 Dirk Brenken (dev@brenken.org)
# This is free software, licensed under the Apache License, Version 2.0

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI TechnoSkver RTR01
LUCI_DESCRIPTION:=Double SIM management for Skw92A with Sim7600 modem integration.
LUCI_DEPENDS:=+lua-md5 +lua-cjson +luci-base +luci-i18n-base-ru +luci-i18n-base-en +luci-compat +luaposix +luabitop +lpeg +libubox-lua +luasocket +comgt +coreutils +coreutils-stty +coreutils-sleep +kmod-usb-serial +kmod-usb-serial-option +kmod-usb-serial-wwan +usb-modeswitch +kmod-usb-core +luci-proto-3g
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-tsmodem
PKG_VERSION:=2.2.0
PKG_RELEASE:=20221120
PKG_LICENSE:=GPL-3.0-or-later

include $(TOPDIR)/feeds/luci/luci.mk

define Package/$(PKG_NAME)/install
	# Default config
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) $(PKG_BUILD_DIR)/root/etc/config/tsmodem $(1)/etc/config/tsmodem
	$(CP) $(PKG_BUILD_DIR)/root/etc/config/tsmodem_adapter_provider $(1)/etc/config/tsmodem_adapter_provider

	# Daemon
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/rc.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/init.d/tsmodem.init $(1)/etc/init.d/tsmodem
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/etc/init.d/tsmodem.sh $(1)/usr/sbin/tsmodem
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
