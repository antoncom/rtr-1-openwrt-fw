
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tkrzw
PKG_VERSION:=0.1
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/antoncom/tkrzw.git
PKG_MIRROR_HASH:=f00db96e81a001d6a619c681e91181abfbc3dc83ccb9593cf4e5104a7ca4fe47
PKG_SOURCE_VERSION:=7be1eaba15788c755de0378126eacdd8a17f20bd
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/tkrzw
    SUBMENU:=Lua
    SECTION:=lang
    CATEGORY:=Languages
    TITLE:=Tkrzw
    DEPENDS:=
endef

define Package/tkrzw/description
  Tkrzw
endef

PKG_FIXUP:=autoreconf

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(TAR) -xzf $(DL_DIR)/$(PKG_SOURCE) --strip=1 -C $(PKG_BUILD_DIR)
	/usr/bin/autoreconf -fiv $(PKG_BUILD_DIR)
endef

define Build/Configure
  $(call Build/Configure/Default,--with-linux-headers=$(LINUX_DIR))
endef

define Build/Compile
    $(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -fPIC" \
		LDFLAGS="$(TARGET_LDFLAGS)"
endef

define Package/tkrzw/install
	#$(INSTALL_DIR) $(1)/etc/init.d
	#$(INSTALL_BIN) ./files/gwsocket.init $(1)/etc/init.d/gwsocket
	#$(INSTALL_DIR) $(1)/usr/sbin
	#$(INSTALL_BIN) ./files/gwsocket.sh $(1)/usr/sbin/gwsocket
	#$(INSTALL_DIR) $(1)/usr/bin
	#$(INSTALL_BIN) $(PKG_BUILD_DIR)/gwsocket $(1)/usr/bin/gwsocket
endef

$(eval $(call BuildPackage,tkrzw))
