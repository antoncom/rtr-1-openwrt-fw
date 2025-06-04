#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tsmodem
PKG_RELEASE:=1.0.0

PKG_SOURCE_URL=https://github.com/antoncom/tsmgpio.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE=2025-06-04
#PKG_SOURCE_VERSION:=c4167e859db1b868c96b747b7106dbc03a2f0ac4
PKG_SOURCE_VERSION:=master

include $(INCLUDE_DIR)/package.mk

define Package/tsmgpio
	SUBMENU:=Lua
	SECTION:=lang
	CATEGORY:=Languages
	TITLE:=Tsmgpio - GPIO support for RTR-2
	URL:=https://github.com/antoncom/tsmgpio.git
	DEPENDS:+applogic
endef

define Package/tsmgpio/description
	Application level driver for GPIO support in RTR-2
endef

define Build/Compile
endef

define Package/tsmgpio/install
	# Source code
	$(INSTALL_DIR) $(1)/usr/lib/lua/tsmgpio
	$(CP) $(PKG_BUILD_DIR)/src/* $(1)/usr/lib/lua/tsmgpio

	# Default config
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) $(PKG_BUILD_DIR)/files/etc/config/tsmgpio $(1)/etc/config/tsmgpio

	# Daemon
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/rc.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/tsmgpio.init $(1)/etc/init.d/tsmgpio
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/tsmgpio.sh $(1)/usr/sbin/tsmgpio
endef

$(eval $(call BuildPackage,tsmgpio))
