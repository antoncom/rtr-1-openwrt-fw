#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tsmconsole
PKG_RELEASE:=2.6.0

PKG_SOURCE_URL=https://github.com/antoncom/tsmconsole.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE=2023-06-14
#PKG_SOURCE_VERSION:=76863df4cb4d989174bd0d656764b4aac299d546
PKG_SOURCE_VERSION:=tsmodem-2.6.11

include $(INCLUDE_DIR)/package.mk

define Package/tsmconsole
	SUBMENU:=Lua
	SECTION:=lang
	CATEGORY:=Languages
	TITLE:=Tsmodem helper module for "Web-console of AT-commands feature"
	URL:=https://github.com/antoncom/tsmconsole.git
	DEPENDS:=+luci +luaposix +libubox-lua
endef

define Package/tsmconsole/description
	Tsmodem helper module, which is used to provide websocket support for "Web-console of AT-commands feature".
endef

define Build/Compile
endef

define Package/tsmconsole/install
	# Source code
	$(INSTALL_DIR) $(1)/usr/lib/lua/tsmconsole
	$(CP) $(PKG_BUILD_DIR)/src/* $(1)/usr/lib/lua/tsmconsole

	# Daemon
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/rc.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/tsmconsole.init $(1)/etc/init.d/tsmconsole
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/tsmconsole.sh $(1)/usr/sbin/tsmconsole
endef

$(eval $(call BuildPackage,tsmconsole))
