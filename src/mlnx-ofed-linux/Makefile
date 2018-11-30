# $Id$
#
# @Copyright@
#
#
#                                 Rocks(r)
#                          www.rocksclusters.org
#                          version 6.2 (SideWinder)
#                          version 7.0 (Manzanita)
#
# Copyright (c) 2000 - 2017 The Regents of the University of California.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice unmodified and in its entirety, this list of conditions and the
# following disclaimer in the documentation and/or other materials provided
# with the distribution.
#
# 3. All advertising and press materials, printed or electronic, mentioning
# features or use of this software must display the following acknowledgement:
#
#         "This product includes software developed by the Rocks(r)
#         Cluster Group at the San Diego Supercomputer Center at the
#         University of California, San Diego and its contributors."
#
# 4. Except as permitted for the purposes of acknowledgment in paragraph 3,
# neither the name or logo of this software nor the names of its
# authors may be used to endorse or promote products derived from this
# software without specific prior written permission.  The name of the
# software includes the following terms, and any derivatives thereof:
# "Rocks", "Rocks Clusters", and "Avalanche Installer".  For licensing of
# the associated name, interested parties should contact Technology
# Transfer & Intellectual Property Services, University of California,
# San Diego, 9500 Gilman Drive, Mail Code 0910, La Jolla, CA 92093-0910,
# Ph: (858) 534-5815, FAX: (858) 534-7345, E-MAIL:invent@ucsd.edu
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# @Copyright@
#
# $Log$

REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

include pull.mk

build: $(SRC_DIRS)
	$(SOURCE_DIR)/mlnx_add_kernel_support.sh -y -m $(PWD)/$(SOURCE_DIR) --make-tgz --distro $(DISTRO)
	tar -xzf /tmp/$(SOURCE_PKG_EXT)
	grep `uname -r` $(SOURCE_DIR_EXT)/.supported_kernels

install::
	mkdir -p $(ROOT)/$(PKGROOT)
	mkdir -p $(REDHAT.ROOT)/RPMS/{noarch,x86_64}
	find $(SOURCE_DIR_EXT)/RPMS -mindepth 1 -maxdepth 1 -name "*.x86_64.rpm" -type f \
	  -exec cp -av '{}' ../../RPMS/x86_64/ \;
	find $(SOURCE_DIR_EXT)/RPMS -mindepth 1 -maxdepth 1 -name "*.noarch.rpm" -type f \
	  -exec cp -av '{}' ../../RPMS/noarch/ \;
	(	\
		cd $(ROOT)/$(PKGROOT); \
		tar -xz --strip-components 1 -f /tmp/$(SOURCE_PKG_EXT) ; \
	)
	echo "Removing provided META RPMs..."
	find $(REDHAT.ROOT)/RPMS/noarch -name "mlnx-ofed-*.rpm" ! -mtime 0 \
	  -exec /bin/rm -v '{}' \;

clean::
	rm -rf $(SOURCE_DIR) $(SOURCE_DIR_EXT)
