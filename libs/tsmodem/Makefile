#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tsmodem
PKG_RELEASE:=3.0.1

PKG_SOURCE_URL=https://github.com/antoncom/tsmodem.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE=2024-10-21
#PKG_SOURCE_VERSION:=c4167e859db1b868c96b747b7106dbc03a2f0ac4
PKG_SOURCE_VERSION:=tsmodem-3.0.1

include $(INCLUDE_DIR)/package.mk

define Package/tsmodem
	SUBMENU:=Lua
	SECTION:=lang
	CATEGORY:=Languages
	TITLE:=Rule-based application logic framework
	URL:=https://github.com/antoncom/tsmodem.git
	DEPENDS:=+luci +luci-i18n-base-ru +openssh-sftp-server +luci-compat +luaposix +luabitop +lpeg +coreutils +libubox-lua +luasocket +comgt +kmod-usb-serial +kmod-usb-serial-option +kmod-usb-serial-wwan +usb-modeswitch +kmod-usb-core +luci-app-uhttpd +luci-proto-3g +coreutils-stty
endef

define Package/tsmodem/description
	Application logic rules are defined with custom variables.
	The "variable" is a Lua table containing such entities as: input, output, source, modifier.
	The "source" defines protocol and methods for loading initial values to the variable input.
	The "modifier" operates with variable's output value and pass-logic. Generally, it's a Lua chunk.
	User is able to add custom modifiers or use the existed ones: [func], [bash], [save], [skip], [frozen].
	Debug mode allows to check all the entities and pass-logics in form of formatted ASCII tables.
	Ordinary UBUS calls designed to get variables' value from the outside.
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
	$(CP) $(PKG_BUILD_DIR)/etc/config/tsmodem_adapter_provider $(1)/etc/config/tsmodem_adapter_provider

	# Daemon
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/rc.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/tsmodem.init $(1)/etc/init.d/tsmodem
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/tsmodem.sh $(1)/usr/sbin/tsmodem
endef

$(eval $(call BuildPackage,tsmodem))
