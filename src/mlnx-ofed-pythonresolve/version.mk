PKGROOT         = /bin
NAME            = sdsc-mlnx-ofa_pythonresolve
VERSION         = 1
RELEASE         = 0
RPM.FILESLIST   = filelist
RPM.REQUIRES    = python
RPM.EXTRAS      = Provides: /bin/python
RPM.DESCRIPTION = \
This resolves /bin/python for various packages that explicitly demand it.\nIt is a vacuous package in that it requires python package and provides /bin/python but does not actually install any files.
