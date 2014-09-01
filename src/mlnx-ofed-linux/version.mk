PKGROOT         = /tmp/mlnx-ofed-linux
NAME            = mlnx-ofed-linux
VERSION         :=$(shell bash ../../version.sh -v)
RELEASE         :=$(shell bash ../../version.sh -h)
COPYRIGHT       = Copyright (c) 2014, The Regents of the University of California.

FILES           = ofed-vma.conf
