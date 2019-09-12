ROLLNAME        = mlnx-ofed-4.6-1.0.1.1-3.10.0-957.27.2.el7
VERSION        :=$(shell bash version.sh -v)
RELEASE        :=$(shell bash version.sh -h)
COPYRIGHT       = Copyright (c) 2018, The Regents of the University of California.
COLOR           = lavenderblush

REDHAT.ROOT     = $(CURDIR)
