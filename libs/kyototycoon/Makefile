# 
# Copyright (C) 2007-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=kyototycoon
PKG_VERSION:=1.1.41
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/antoncom/kyoto
PKG_MIRROR_HASH:=f00db96e81a001d6a619c681e91181abfbc3dc83ccb9593cf4e5104a7ca4fe47
PKG_SOURCE_VERSION:=f9ac910851913cb55a1851b97bc9dba27e0dc9c4
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/kyototycoon
  SUBMENU:=database
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=A library of routines to manage databases
  URL:=http://fallabs.com/tokyocabinet/
  DEPENDS:=+zlib +bzip2 +libpthread +librt
  MAINTAINER:=Obinou <obconseil@gmail.com>
endef

define Package/kyototycoon/description
 Tokyo Cabinet is a library of routines for managing a database.
 The database is a simple data file containing records, each
 is a pair of a key and a value. Every key and value is serial bytes
 with variable length. Both binary data and character string can be
 used as a key and a value. There is neither concept of data tables
 nor data types. Records are organized in hash table, B+ tree,
 or fixed-length array.

 Tokyo Cabinet is developed as the successor of GDBM and QDBM on the
 following purposes. They are achieved and Tokyo Cabinet replaces
 conventional DBM products.
endef

CONFIGURE_ARGS += --prefix=/usr
    
define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)
	$(MAKE) -C $(PKG_BUILD_DIR) DESTDIR="$(PKG_INSTALL_DIR)" install
endef

define Build/InstallDev
	$(MAKE) -C $(PKG_BUILD_DIR) DESTDIR="$(1)" install
endef

define Package/kyototycoon/install
	$(INSTALL_DIR)  $(1)/usr/lib/
	$(CP)  $(PKG_INSTALL_DIR)/usr/lib/*.so*  $(1)/usr/lib/
	$(INSTALL_DIR)  $(1)/usr/bin/
	$(CP)  $(PKG_INSTALL_DIR)/usr/bin/*  $(1)/usr/bin/
	$(INSTALL_DIR)  $(1)/usr/sbin/
	$(CP)  $(PKG_INSTALL_DIR)/usr/sbin/*  $(1)/usr/sbin/
	$(INSTALL_DIR)   $(1)/usr/share/kyototycoon/ext
	$(CP)  $(PKG_INSTALL_DIR)/usr/share/kyototycoon/ext/* $(1)/usr/share/kyototycoon/ext
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/share/kyototycoon/kyototycoon.idl $(1)/usr/share/kyototycoon
endef

$(eval $(call BuildPackage,kyototycoon))
