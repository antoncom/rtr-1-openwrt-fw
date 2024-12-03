#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tsmjournal
PKG_RELEASE:=1.0.0

PKG_SOURCE_URL=https://github.com/antoncom/tsmjournal.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE=2024-12-03
PKG_SOURCE_VERSION:=master

include $(INCLUDE_DIR)/package.mk

define Package/tsmjournal
	SUBMENU:=Lua
	SECTION:=lang
	CATEGORY:=Languages
	TITLE:=Tsmjournal for Bitcord RTR-3 Tsmodem
	URL:=https://github.com/antoncom/tsmjournal.git
	DEPENDS:=+luaposix +libubox-lua
endef

define Package/tsmjournal/description
	Tsmjournal is used to store Application Logic log into the LevelDB
endef

define Build/Compile
endef

define Package/tsmjournal/install
	# Source code
	$(INSTALL_DIR) $(1)/usr/lib/lua/tsmjournal
	$(CP) $(PKG_BUILD_DIR)/src/* $(1)/usr/lib/lua/tsmjournal

	# Daemon
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/rc.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/tsmjournal.init $(1)/etc/init.d/tsmjournal
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/tsmjournal.sh $(1)/usr/sbin/tsmjournal
endef

$(eval $(call BuildPackage,tsmjournal))
