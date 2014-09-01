PKGROOT         = /etc/modprobe.d
NAME            = mlnx-ofed-modprobe-d-conf
VERSION         :=$(shell bash ../../version.sh -v)
RELEASE         :=$(shell bash ../../version.sh -h)
COPYRIGHT       = Copyright (c) 2014, The Regents of the University of California.

FILES           = mlx4_core.conf
