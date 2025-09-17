#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tsmail
PKG_RELEASE:=3.1.0

PKG_SOURCE_URL=https://github.com/antoncom/tsmail.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE=2025-09-17
#PKG_SOURCE_VERSION:=
PKG_SOURCE_VERSION:=main

include $(INCLUDE_DIR)/package.mk

define Package/tsmail
	SUBMENU:=Lua
	SECTION:=lang
	CATEGORY:=Languages
	TITLE:=Tsmail service
	URL:=https://github.com/antoncom/tsmail.git
	DEPENDS:=+luci +lua +mailsend
endef

define Package/tsmail/description
endef

define Build/Compile
endef

define Package/tsmail/install
	# Source code
	$(INSTALL_DIR) $(1)/usr/lib/lua/tsmail
	$(CP) $(PKG_BUILD_DIR)/src/* $(1)/usr/lib/lua/tsmail

	# Default config
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) $(PKG_BUILD_DIR)/etc/config/tsmail $(1)/etc/config/tsmail

	# Daemon
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/rc.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/tsmail.init $(1)/etc/init.d/tsmail
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/tsmail.sh $(1)/usr/sbin/tsmail
endef

$(eval $(call BuildPackage,tsmail))