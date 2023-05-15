#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tsmstm
PKG_RELEASE:=2.5

PKG_SOURCE_URL=https://github.com/antoncom/tsmstm.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE=2023-05-15
PKG_SOURCE_VERSION:=ccc877b8b289b206d6dc42c5ab0eb81430133785

include $(INCLUDE_DIR)/package.mk

define Package/tsmstm
	SUBMENU:=Lua
	SECTION:=lang
	CATEGORY:=Languages
	TITLE:=STM32 AT-protocol realisation on ubus
	URL:=https://github.com/antoncom/tsmstm.git
	DEPENDS:=coreutils-stty
endef

define Package/tsmstm/description
	Tsmstm lib makes it possible to send AT-commands to STM32 via UBUS object.
endef

define Build/Compile
endef

define Package/tsmstm/install
	# Source code
	$(INSTALL_DIR) $(1)/usr/lib/lua/tsmstm
	$(CP) $(PKG_BUILD_DIR)/src/* $(1)/usr/lib/lua/tsmstm

	# Daemon
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/rc.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/tsmstm.init $(1)/etc/init.d/tsmstm
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/tsmstm.sh $(1)/usr/sbin/tsmstm
endef

$(eval $(call BuildPackage,tsmstm))
