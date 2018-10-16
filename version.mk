VERSION         :=$(shell bash version.sh -v)
RELEASE         :=$(shell bash version.sh -h)
COPYRIGHT       = Copyright (c) 2014, The Regents of the University of California.
COLOR		= lavenderblush
MLNX           :=$(shell bash mlnx.sh)
KERN           :=$(shell bash kern.sh)
ROLLNAME        = mlnx-ofed-$(MLNX)-$(KERN)
COPYRIGHT       = Copyright (c) 2018, The Regents of the University of California.

REDHAT.ROOT	= $(CURDIR)
