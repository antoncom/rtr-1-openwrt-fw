
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
