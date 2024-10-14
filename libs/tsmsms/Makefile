#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tsmsms
PKG_RELEASE:=3.0.1

PKG_SOURCE_URL=https://github.com/antoncom/tsmsms.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE=2024-10-14
#PKG_SOURCE_VERSION:=c4167e859db1b868c96b747b7106dbc03a2f0ac4
PKG_SOURCE_VERSION:=tsmsms-3.0.1

include $(INCLUDE_DIR)/package.mk

define Package/tsmsms
	SUBMENU:=Lua
	SECTION:=lang
	CATEGORY:=Languages
	TITLE:=SMS service for Tsmodem
	URL:=https://github.com/antoncom/tsmsms.git
	DEPENDS:=+luci +luci-i18n-base-ru +luci-i18n-base-en +openssh-sftp-server +luci-compat +luaposix +luabitop +lpeg +coreutils +libubox-lua +luasocket +comgt +kmod-usb-serial +kmod-usb-serial-option +kmod-usb-serial-wwan +usb-modeswitch +kmod-usb-core +luci-app-uhttpd +luci-proto-3g +coreutils-stty
endef

define Package/tsmsms/description
endef

define Build/Compile
endef

define Package/tsmsms/install
	# Source code
	$(INSTALL_DIR) $(1)/usr/lib/lua/tsmsms
	$(CP) $(PKG_BUILD_DIR)/src/* $(1)/usr/lib/lua/tsmsms

	# Default config
	$(INSTALL_DIR) $(1)/etc/config
	$(CP) $(PKG_BUILD_DIR)/etc/config/tsmsms $(1)/etc/config/tsmsms

	# Daemon
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/rc.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/tsmsms.init $(1)/etc/init.d/tsmsms
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/tsmsms.sh $(1)/usr/sbin/tsmsms
endef

$(eval $(call BuildPackage,tsmsms))
