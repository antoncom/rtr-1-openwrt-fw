#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tsmvpn
PKG_VERSION:=0.3

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL=https://github.com/Makskuk/vpnconfig.git
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/tsmvpn
	SUBMENU:=Lua
	SECTION:=lang
	CATEGORY:=Languages
	TITLE:=Vpnconfig
	URL:=https://github.com/Makskuk/vpnconfig.git
	DEPENDS:=+luci
endef

define Package/tsmvpn/description
  vpnconfig
endef

define Build/Compile
endef

define Package/tsmvpn/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/
	$(CP) $(PKG_BUILD_DIR)/luasrc/* $(1)/usr/lib/lua/luci/
endef

$(eval $(call BuildPackage,tsmvpn))
