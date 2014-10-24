NAME              = mlnx-ofed-linux
VERSION           = 2.3
RELEASE           = 1.0.1
EXTRA             = rhel6.5-x86_64
PKGROOT           = /opt/mlnx-ofed-linux

SRC_SUBDIR        = mlnx-ofed-linux

SOURCE_NAME       = MLNX_OFED_LINUX
SOURCE_SUFFIX     = tgz
SOURCE_VERSION    = $(VERSION)-$(RELEASE)-$(EXTRA)-ext
SOURCE_PKG        = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR        = $(SOURCE_NAME)-$(SOURCE_VERSION)

ISO_NAME          = $(SOURCE_NAME)-$(VERSION)-$(RELEASE)-$(EXTRA).iso
ISO_PKGS          = $(ISO_NAME)

RPM.EXTRAS        = AutoReq:No
