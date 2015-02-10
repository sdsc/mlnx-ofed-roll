PKGROOT         = /etc/infiniband
NAME            = mlnx-ofed-infiniband-conf
VERSION         :=$(shell bash ../../version.sh -v)
RELEASE         :=$(shell bash ../../version.sh -h)
COPYRIGHT       = Copyright (c) 2014, The Regents of the University of California.

FILES           = connectx.conf openibd.conf
