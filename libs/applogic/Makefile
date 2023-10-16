#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=applogic
PKG_RELEASE:=2.6.0

PKG_SOURCE_URL=https://github.com/antoncom/applogic-rules.git
PKG_MIRROR_HASH:=28309612101c4a6dd20e8bb47accf04bbfdad751b5c867db27cb49e972bf99c3
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE=2023-06-14
#PKG_SOURCE_VERSION:=a685edc31b26898da184a3ad171fb2e5a09c55af
PKG_SOURCE_VERSION:=applogic-2.6.0-tsmodem-n725

include $(INCLUDE_DIR)/package.mk

define Package/applogic
	SUBMENU:=Lua
	SECTION:=lang
	CATEGORY:=Languages
	TITLE:=Rule-based application logic framework
	URL:=https://github.com/antoncom/applogic-rules.git
	DEPENDS:=+luci +lua-cjson +luabitop +lua-md5 +luacfort
endef

define Package/applogic/description
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

define Package/applogic/install
	# Source code
	$(INSTALL_DIR) $(1)/usr/lib/lua/applogic
	$(CP) $(PKG_BUILD_DIR)/src/* $(1)/usr/lib/lua/applogic

	# Default config
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) $(PKG_BUILD_DIR)/etc/config/applogic $(1)/etc/config/applogic

	# Daemon
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/rc.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/applogic.init $(1)/etc/init.d/applogic
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/applogic.sh $(1)/usr/sbin/applogic
endef

$(eval $(call BuildPackage,applogic))
