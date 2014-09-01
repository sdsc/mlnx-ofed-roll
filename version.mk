ROLLNAME	= mlnx-ofed
VERSION         :=$(shell bash version.sh -v)
RELEASE         :=$(shell bash version.sh -h)
COPYRIGHT       = Copyright (c) 2014, The Regents of the University of California.
COLOR		= lavenderblush

REDHAT.ROOT	= $(CURDIR)
