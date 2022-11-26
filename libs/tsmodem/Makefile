#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tsmodem
PKG_RELEASE:=2.3

PKG_SOURCE_URL=https://github.com/antoncom/tsmodem.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE=2022-11-26
PKG_SOURCE_VERSION:=aa174d6f3c32ca7a0cfaf1b231bed79398be47cc

include $(INCLUDE_DIR)/package.mk

define Package/tsmodem
	SUBMENU:=Lua
	SECTION:=lang
	CATEGORY:=Languages
	TITLE:=Tsmodem App level driver for sky92a based router.
	URL:=https://github.com/antoncom/tsmodem.git
	DEPENDS:=+luci-i18n-base-ru +luci-i18n-base-en +openssh-sftp-server +luci-compat +luaposix +luabitop +lpeg +coreutils-sleep +libubox-lua +luasocket +coreutils-stty +comgt +kmod-usb-serial +kmod-usb-serial-option +kmod-usb-serial-wwan +usb-modeswitch +kmod-usb-core +luci-app-uhttpd +luci-proto-3g
endef

define Package/tsmodem/description
	Application level modem driver for sky92a based routers.
endef

define Build/Compile
endef

define Package/tsmodem/install
	# Source code
	$(INSTALL_DIR) $(1)/usr/lib/lua/tsmodem
	$(CP) $(PKG_BUILD_DIR)/src/* $(1)/usr/lib/lua/tsmodem

	# Default config
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) $(PKG_BUILD_DIR)/etc/config/tsmodem $(1)/etc/config/tsmodem
	$(CP) $(PKG_BUILD_DIR)/etc/config/tsmodem $(1)/etc/config/tsmodem_adapter_provider

	# Daemon
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/rc.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/tsmodem.init $(1)/etc/init.d/tsmodem
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/tsmodem.sh $(1)/usr/sbin/tsmodem
endef

$(eval $(call BuildPackage,tsmodem))
