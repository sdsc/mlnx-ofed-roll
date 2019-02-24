## Conflicts with OS Provided Infiniband RPMs

It is common to update a Rocks system using the `mlnx-ofed-roll` to a newer
version of `CentOS` and/or apply system updates using an `Updates-CentOS` roll.

In either of these cases it is possible to create a conflict between distro
provided Infiniband RPMs and those included by the `MLNX_OFED_LINUX` version
provided by a specific build of this roll source.

Any other roll providing Infiniband related RPMs can create a similar conflict.

Such a conflict is illustrated below.

Rolls in test system:

```
[root@manzanita ~]# rocks list roll
NAME                                       VERSION             ARCH   ENABLED
base:                                      7.0                 x86_64 yes
core:                                      7.0                 x86_64 yes
kernel:                                    7.0                 x86_64 yes
CentOS:                                    7.6.1810            x86_64 yes
Updates-CentOS-7.6.1810:                   2019.02.23          x86_64 yes
mlnx-ofed-4.4-2.0.7.0-3.10.0-862.14.4.el7: 7.0                 x86_64 yes
```

An illustration of conflicting symlinks to incompatible distribution `ibacm` RPM and `ibacm-devel` RPM from `MLNX_OFED_LINUX` is below...

```
[root@manzanita ~]# find /export/rocks/install/rocks-dist/x86_64/RedHat/RPMS -name "ibacm*" -ls
539738    4 lrwxrwxrwx   1 root     root           90 Feb 23 19:24 /export/rocks/install/rocks-dist/x86_64/RedHat/RPMS/ibacm-17.2-3.el7.x86_64.rpm -> \
    /export/rocks/install/rolls/CentOS/7.6.1810/x86_64/RedHat/RPMS/ibacm-17.2-3.el7.x86_64.rpm
545197    4 lrwxrwxrwx   1 root     root          144 Feb 23 19:24 /export/rocks/install/rocks-dist/x86_64/RedHat/RPMS/ibacm-devel-41mlnx1-OFED.4.3.3.0.0.44207.x86_64.rpm -> \
    /export/rocks/install/rolls/mlnx-ofed-4.4-2.0.7.0-3.10.0-862.14.4.el7/7.0/x86_64/RedHat/RPMS/ibacm-devel-41mlnx1-OFED.4.3.3.0.0.44207.x86_64.rpm
```

In the above case you can see that the `ibacm` RPM is being provided by the
`CentOS` roll while the `ibacm-devel` RPM is being provided by the `mlnx-ofed-roll`.

In this situation there can be many such conflicts which will prevent install of
nodes due to RPM conflict resolution failures during Anaconda install.

The `/tmp/packaging.log` file of an installing node will typically include errors
such as the following and installation will hang...

```
19:56:24,951 DEBUG yum.verbose.YumBase: Depsolve time: 10.771
19:56:24,951 DEBUG packaging: buildTransaction = (1, [u'libibumad-static-43.1.1.MLNX20180612.87b4d9b-0.1.44207.x86_64 requires libibumad = 43.1.1.MLNX20180612.87b4d9b-0.1.44207', u'librdmacm-devel-41mlnx1-OFED.4.2.0.1.3.44207.x86_64 requires librspreload.so.1()(64bit)', u'ibacm-17.2-3.el7.x86_64 requires rdma-core(x86-64) = 17.2-3.el7', u'ibutils-1.5.7.1-0.12.gdcaeae2.44207.x86_64 requires libosmvendor.so.3(OSMVENDOR_2.0)(64bit)', u'ibutils-1.5.7.1-0.12.gdcaeae2.44207.x86_64 requires libosmvendor.so.3()(64bit)', u'libibumad-17.2-3.el7.x86_64 requires rdma-core(x86-64) = 17.2-3.el7', u'libibverbs-17.2-3.el7.x86_64 requires rdma-core(x86-64) = 17.2-3.el7', u'libibverbs-devel-41mlnx1-OFED.4.4.2.0.1.44207.x86_64 requires libibverbs = 41mlnx1-OFED.4.4.2.0.1.44207', u'libibumad-devel-43.1.1.MLNX20180612.87b4d9b-0.1.44207.x86_64 requires libibumad = 43.1.1.MLNX20180612.87b4d9b-0.1.44207', u'librdmacm-17.2-3.el7.x86_64 requires rdma-core(x86-64) = 17.2-3.el7', u'ibutils-1.5.7.1-0.12.gdcaeae2.44207.x86_64 requires libopensm.so.16()(64bit)', u'librdmacm-devel-41mlnx1-OFED.4.2.0.1.3.44207.x86_64 requires librdmacm = 41mlnx1-OFED.4.2.0.1.3.44207', u'ibutils-1.5.7.1-0.12.gdcaeae2.44207.x86_64 requires libopensm.so.16(OPENSM_1.5)(64bit)'])
19:56:24,951 WARN packaging: libibumad-static-43.1.1.MLNX20180612.87b4d9b-0.1.44207.x86_64 requires libibumad = 43.1.1.MLNX20180612.87b4d9b-0.1.44207
19:56:24,952 WARN packaging: librdmacm-devel-41mlnx1-OFED.4.2.0.1.3.44207.x86_64 requires librspreload.so.1()(64bit)
19:56:24,952 WARN packaging: ibacm-17.2-3.el7.x86_64 requires rdma-core(x86-64) = 17.2-3.el7
19:56:24,952 WARN packaging: ibutils-1.5.7.1-0.12.gdcaeae2.44207.x86_64 requires libosmvendor.so.3(OSMVENDOR_2.0)(64bit)
19:56:24,952 WARN packaging: ibutils-1.5.7.1-0.12.gdcaeae2.44207.x86_64 requires libosmvendor.so.3()(64bit)
19:56:24,952 WARN packaging: libibumad-17.2-3.el7.x86_64 requires rdma-core(x86-64) = 17.2-3.el7
19:56:24,952 WARN packaging: libibverbs-17.2-3.el7.x86_64 requires rdma-core(x86-64) = 17.2-3.el7
19:56:24,952 WARN packaging: libibverbs-devel-41mlnx1-OFED.4.4.2.0.1.44207.x86_64 requires libibverbs = 41mlnx1-OFED.4.4.2.0.1.44207
19:56:24,952 WARN packaging: libibumad-devel-43.1.1.MLNX20180612.87b4d9b-0.1.44207.x86_64 requires libibumad = 43.1.1.MLNX20180612.87b4d9b-0.1.44207
19:56:24,952 WARN packaging: librdmacm-17.2-3.el7.x86_64 requires rdma-core(x86-64) = 17.2-3.el7
19:56:24,952 WARN packaging: ibutils-1.5.7.1-0.12.gdcaeae2.44207.x86_64 requires libopensm.so.16()(64bit)
19:56:24,953 WARN packaging: librdmacm-devel-41mlnx1-OFED.4.2.0.1.3.44207.x86_64 requires librdmacm = 41mlnx1-OFED.4.2.0.1.3.44207
19:56:24,953 WARN packaging: ibutils-1.5.7.1-0.12.gdcaeae2.44207.x86_64 requires libopensm.so.16(OPENSM_1.5)(64bit)
```


There are two possible solutions to this:

- Update to a newer `MLNX_OFED_LINUX` release that is supported by **and newer** than the OS installed in the system.
- Remove the conflicting OS RPMs from the `CentOS` and/or `Updates-CentOS` roll directories and rebuild the distribution.

Either option will only be valid until a newer `CentOS` or `Updates-CentOS` roll
is created and added to the Rocks distribution.

In the following example the problematic distro provided RPMs were moved out of
the roll directory and the distribution was rebuilt and the conflict was resolved.

### Change to CentOS roll directory and create destination for moving RPMs

```
[root@manzanita ~]# cd /export/rocks/install/rolls/CentOS/7.6.1810/x86_64/RedHat/RPMS/
[root@manzanita RPMS]# mkdir -p /root/CentOS-7.6.1810
```

### Find and move RPMs in from CentOS directory

This method will scan all RPMs in the current directory and find any that are known to conflict with those from `MLNX_OFED_LINUX` and move them to the target directory...

```
[root@manzanita RPMS]# for r in *.rpm; do \
    rpm -q --queryformat "%{SOURCERPM}\n" -p $r | \
    egrep -q "rdma\-core\-[el0-9.-]*\.src\.rpm|opensm\-[el0-9.-]*\.src\.rpm|libibmad\-[el0-9.-]*\.src\.rpm|libibcommon\-[el0-9.-]*\.src\.rpm|compat\-opensm\-libs\-[el0-9.-]*\.src\.rpm|srp_daemon\-[el0-9.-]*\.src\.rpm|infiniband\-diags\-[el0-9.-]*\.src\.rpm" && \
    ( echo Found... $r; mv -v $r /root/CentOS-7.6.1810); \
    done
Found... compat-opensm-libs-3.3.15-2.el7.i686.rpm
‘compat-opensm-libs-3.3.15-2.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/compat-opensm-libs-3.3.15-2.el7.i686.rpm’
removed ‘compat-opensm-libs-3.3.15-2.el7.i686.rpm’
Found... compat-opensm-libs-3.3.15-2.el7.x86_64.rpm
‘compat-opensm-libs-3.3.15-2.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/compat-opensm-libs-3.3.15-2.el7.x86_64.rpm’
removed ‘compat-opensm-libs-3.3.15-2.el7.x86_64.rpm’
Found... ibacm-17.2-3.el7.x86_64.rpm
‘ibacm-17.2-3.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/ibacm-17.2-3.el7.x86_64.rpm’
removed ‘ibacm-17.2-3.el7.x86_64.rpm’
Found... infiniband-diags-2.0.0-2.el7.i686.rpm
‘infiniband-diags-2.0.0-2.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/infiniband-diags-2.0.0-2.el7.i686.rpm’
removed ‘infiniband-diags-2.0.0-2.el7.i686.rpm’
Found... infiniband-diags-2.0.0-2.el7.x86_64.rpm
‘infiniband-diags-2.0.0-2.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/infiniband-diags-2.0.0-2.el7.x86_64.rpm’
removed ‘infiniband-diags-2.0.0-2.el7.x86_64.rpm’
Found... infiniband-diags-devel-2.0.0-2.el7.i686.rpm
‘infiniband-diags-devel-2.0.0-2.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/infiniband-diags-devel-2.0.0-2.el7.i686.rpm’
removed ‘infiniband-diags-devel-2.0.0-2.el7.i686.rpm’
Found... infiniband-diags-devel-2.0.0-2.el7.x86_64.rpm
‘infiniband-diags-devel-2.0.0-2.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/infiniband-diags-devel-2.0.0-2.el7.x86_64.rpm’
removed ‘infiniband-diags-devel-2.0.0-2.el7.x86_64.rpm’
Found... infiniband-diags-devel-static-2.0.0-2.el7.i686.rpm
‘infiniband-diags-devel-static-2.0.0-2.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/infiniband-diags-devel-static-2.0.0-2.el7.i686.rpm’
removed ‘infiniband-diags-devel-static-2.0.0-2.el7.i686.rpm’
Found... infiniband-diags-devel-static-2.0.0-2.el7.x86_64.rpm
‘infiniband-diags-devel-static-2.0.0-2.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/infiniband-diags-devel-static-2.0.0-2.el7.x86_64.rpm’
removed ‘infiniband-diags-devel-static-2.0.0-2.el7.x86_64.rpm’
Found... iwpmd-17.2-3.el7.x86_64.rpm
‘iwpmd-17.2-3.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/iwpmd-17.2-3.el7.x86_64.rpm’
removed ‘iwpmd-17.2-3.el7.x86_64.rpm’
Found... libibcommon-1.2.0-8.el7.i686.rpm
‘libibcommon-1.2.0-8.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/libibcommon-1.2.0-8.el7.i686.rpm’
removed ‘libibcommon-1.2.0-8.el7.i686.rpm’
Found... libibcommon-1.2.0-8.el7.x86_64.rpm
‘libibcommon-1.2.0-8.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/libibcommon-1.2.0-8.el7.x86_64.rpm’
removed ‘libibcommon-1.2.0-8.el7.x86_64.rpm’
Found... libibcommon-devel-1.2.0-8.el7.i686.rpm
‘libibcommon-devel-1.2.0-8.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/libibcommon-devel-1.2.0-8.el7.i686.rpm’
removed ‘libibcommon-devel-1.2.0-8.el7.i686.rpm’
Found... libibcommon-devel-1.2.0-8.el7.x86_64.rpm
‘libibcommon-devel-1.2.0-8.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/libibcommon-devel-1.2.0-8.el7.x86_64.rpm’
removed ‘libibcommon-devel-1.2.0-8.el7.x86_64.rpm’
Found... libibcommon-static-1.2.0-8.el7.i686.rpm
‘libibcommon-static-1.2.0-8.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/libibcommon-static-1.2.0-8.el7.i686.rpm’
removed ‘libibcommon-static-1.2.0-8.el7.i686.rpm’
Found... libibcommon-static-1.2.0-8.el7.x86_64.rpm
‘libibcommon-static-1.2.0-8.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/libibcommon-static-1.2.0-8.el7.x86_64.rpm’
removed ‘libibcommon-static-1.2.0-8.el7.x86_64.rpm’
Found... libibmad-1.3.13-1.el7.i686.rpm
‘libibmad-1.3.13-1.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/libibmad-1.3.13-1.el7.i686.rpm’
removed ‘libibmad-1.3.13-1.el7.i686.rpm’
Found... libibmad-1.3.13-1.el7.x86_64.rpm
‘libibmad-1.3.13-1.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/libibmad-1.3.13-1.el7.x86_64.rpm’
removed ‘libibmad-1.3.13-1.el7.x86_64.rpm’
Found... libibmad-devel-1.3.13-1.el7.i686.rpm
‘libibmad-devel-1.3.13-1.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/libibmad-devel-1.3.13-1.el7.i686.rpm’
removed ‘libibmad-devel-1.3.13-1.el7.i686.rpm’
Found... libibmad-devel-1.3.13-1.el7.x86_64.rpm
‘libibmad-devel-1.3.13-1.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/libibmad-devel-1.3.13-1.el7.x86_64.rpm’
removed ‘libibmad-devel-1.3.13-1.el7.x86_64.rpm’
Found... libibmad-static-1.3.13-1.el7.i686.rpm
‘libibmad-static-1.3.13-1.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/libibmad-static-1.3.13-1.el7.i686.rpm’
removed ‘libibmad-static-1.3.13-1.el7.i686.rpm’
Found... libibmad-static-1.3.13-1.el7.x86_64.rpm
‘libibmad-static-1.3.13-1.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/libibmad-static-1.3.13-1.el7.x86_64.rpm’
removed ‘libibmad-static-1.3.13-1.el7.x86_64.rpm’
Found... libibumad-17.2-3.el7.i686.rpm
‘libibumad-17.2-3.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/libibumad-17.2-3.el7.i686.rpm’
removed ‘libibumad-17.2-3.el7.i686.rpm’
Found... libibumad-17.2-3.el7.x86_64.rpm
‘libibumad-17.2-3.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/libibumad-17.2-3.el7.x86_64.rpm’
removed ‘libibumad-17.2-3.el7.x86_64.rpm’
Found... libibverbs-17.2-3.el7.i686.rpm
‘libibverbs-17.2-3.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/libibverbs-17.2-3.el7.i686.rpm’
removed ‘libibverbs-17.2-3.el7.i686.rpm’
Found... libibverbs-17.2-3.el7.x86_64.rpm
‘libibverbs-17.2-3.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/libibverbs-17.2-3.el7.x86_64.rpm’
removed ‘libibverbs-17.2-3.el7.x86_64.rpm’
Found... libibverbs-utils-17.2-3.el7.x86_64.rpm
‘libibverbs-utils-17.2-3.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/libibverbs-utils-17.2-3.el7.x86_64.rpm’
removed ‘libibverbs-utils-17.2-3.el7.x86_64.rpm’
Found... librdmacm-17.2-3.el7.i686.rpm
‘librdmacm-17.2-3.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/librdmacm-17.2-3.el7.i686.rpm’
removed ‘librdmacm-17.2-3.el7.i686.rpm’
Found... librdmacm-17.2-3.el7.x86_64.rpm
‘librdmacm-17.2-3.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/librdmacm-17.2-3.el7.x86_64.rpm’
removed ‘librdmacm-17.2-3.el7.x86_64.rpm’
Found... librdmacm-utils-17.2-3.el7.x86_64.rpm
‘librdmacm-utils-17.2-3.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/librdmacm-utils-17.2-3.el7.x86_64.rpm’
removed ‘librdmacm-utils-17.2-3.el7.x86_64.rpm’
Found... opensm-3.3.20-3.el7.x86_64.rpm
‘opensm-3.3.20-3.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/opensm-3.3.20-3.el7.x86_64.rpm’
removed ‘opensm-3.3.20-3.el7.x86_64.rpm’
Found... opensm-devel-3.3.20-3.el7.i686.rpm
‘opensm-devel-3.3.20-3.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/opensm-devel-3.3.20-3.el7.i686.rpm’
removed ‘opensm-devel-3.3.20-3.el7.i686.rpm’
Found... opensm-devel-3.3.20-3.el7.x86_64.rpm
‘opensm-devel-3.3.20-3.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/opensm-devel-3.3.20-3.el7.x86_64.rpm’
removed ‘opensm-devel-3.3.20-3.el7.x86_64.rpm’
Found... opensm-libs-3.3.20-3.el7.i686.rpm
‘opensm-libs-3.3.20-3.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/opensm-libs-3.3.20-3.el7.i686.rpm’
removed ‘opensm-libs-3.3.20-3.el7.i686.rpm’
Found... opensm-libs-3.3.20-3.el7.x86_64.rpm
‘opensm-libs-3.3.20-3.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/opensm-libs-3.3.20-3.el7.x86_64.rpm’
removed ‘opensm-libs-3.3.20-3.el7.x86_64.rpm’
Found... opensm-static-3.3.20-3.el7.i686.rpm
‘opensm-static-3.3.20-3.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/opensm-static-3.3.20-3.el7.i686.rpm’
removed ‘opensm-static-3.3.20-3.el7.i686.rpm’
Found... opensm-static-3.3.20-3.el7.x86_64.rpm
‘opensm-static-3.3.20-3.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/opensm-static-3.3.20-3.el7.x86_64.rpm’
removed ‘opensm-static-3.3.20-3.el7.x86_64.rpm’
Found... rdma-core-17.2-3.el7.i686.rpm
‘rdma-core-17.2-3.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/rdma-core-17.2-3.el7.i686.rpm’
removed ‘rdma-core-17.2-3.el7.i686.rpm’
Found... rdma-core-17.2-3.el7.x86_64.rpm
‘rdma-core-17.2-3.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/rdma-core-17.2-3.el7.x86_64.rpm’
removed ‘rdma-core-17.2-3.el7.x86_64.rpm’
Found... rdma-core-devel-17.2-3.el7.i686.rpm
‘rdma-core-devel-17.2-3.el7.i686.rpm’ -> ‘/root/CentOS-7.6.1810/rdma-core-devel-17.2-3.el7.i686.rpm’
removed ‘rdma-core-devel-17.2-3.el7.i686.rpm’
Found... rdma-core-devel-17.2-3.el7.x86_64.rpm
‘rdma-core-devel-17.2-3.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/rdma-core-devel-17.2-3.el7.x86_64.rpm’
removed ‘rdma-core-devel-17.2-3.el7.x86_64.rpm’
Found... srp_daemon-17.2-3.el7.x86_64.rpm
‘srp_daemon-17.2-3.el7.x86_64.rpm’ -> ‘/root/CentOS-7.6.1810/srp_daemon-17.2-3.el7.x86_64.rpm’
removed ‘srp_daemon-17.2-3.el7.x86_64.rpm’
```

### Change to CentOS roll directory and create destination for moving RPMs

```
[root@manzanita install]# cd /export/rocks/install/rolls/Updates-CentOS-7.6.1810/2019.02.23/x86_64/RedHat/RPMS/
[root@manzanita RPMS]# mkdir -p /root/Updates-CentOS-7.6.1810
```

### Find and move RPMs in from Updates-CentOS directory

This method will scan all RPMs in the current directory and find any that are known to conflict with those from `MLNX_OFED_LINUX` and move them to the target directory...

```
[root@manzanita RPMS]# for r in *.rpm; do rpm -q --queryformat "%{SOURCERPM}\n" -p $r | egrep -q "rdma\-core\-[el0-9.-]*\.src\.rpm|opensm\-[el0-9.-]*\.src\.rpm|libibmad\-[el0-9.-]*\.src\.rpm|libibcommon\-[el0-9.-]*\.src\.rpm|compat\-opensm\-libs\-[el0-9.-]*\.src\.rpm|srp_daemon\-[el0-9.-]*\.src\.rpm" && ( echo Found... $r; mv -v $r /root/CentOS-7.6.1810) ; done
[root@manzanita RPMS]#
```

### Rebuild the Rocks Distribution

```
[root@manzanita ~]# cd /export/rocks/install/


[root@manzanita install]# rocks create distro
Cleaning distribution
Resolving versions (base files)
    including "kernel" (7.0,x86_64) roll...
    including "mlnx-ofed-4.4-2.0.7.0-3.10.0-862.14.4.el7" (7.0,x86_64) roll...
    including "core" (7.0,x86_64) roll...
    including "CentOS" (7.6.1810,x86_64) roll...
    including "Updates-CentOS-7.6.1810" (2019.02.23,x86_64) roll...
    including "base" (7.0,x86_64) roll...
Including critical RPMS
Resolving versions (RPMs)
    including "kernel" (7.0,x86_64) roll...
    including "mlnx-ofed-4.4-2.0.7.0-3.10.0-862.14.4.el7" (7.0,x86_64) roll...
    including "core" (7.0,x86_64) roll...
    including "CentOS" (7.6.1810,x86_64) roll...
    including "Updates-CentOS-7.6.1810" (2019.02.23,x86_64) roll...
    including "base" (7.0,x86_64) roll...
Resolving versions (SRPMs)
    including "kernel" (7.0,x86_64) roll...
    including "mlnx-ofed-4.4-2.0.7.0-3.10.0-862.14.4.el7" (7.0,x86_64) roll...
    including "core" (7.0,x86_64) roll...
    including "CentOS" (7.6.1810,x86_64) roll...
    including "Updates-CentOS-7.6.1810" (2019.02.23,x86_64) roll...
    including "base" (7.0,x86_64) roll...
Creating files (symbolic links - fast)
Applying netstage (aka stage2)
Applying rocks-anaconda-updates
Installing XML Kickstart profiles
    installing "kernel" profiles...
    installing "base" profiles...
    installing "mlnx-ofed-4.4-2.0.7.0-3.10.0-862.14.4.el7" profiles...
    installing "core" profiles...
    installing "site" profiles...
     Calling Yum genpkgmetadata.py
Creating repository
     Rebuilding Product Image including md5 sums
     Creating Directory Listing
[root@manzanita install]#
```

### Verify RPM source directory

```
[root@manzanita install]# find /export/rocks/install/rocks-dist/x86_64/RedHat/RPMS -name "ibacm*" -ls
550531    4 lrwxrwxrwx   1 root     root          138 Feb 23 20:01 /export/rocks/install/rocks-dist/x86_64/RedHat/RPMS/ibacm-41mlnx1-OFED.4.3.3.0.0.44207.x86_64.rpm -> \
    /export/rocks/install/rolls/mlnx-ofed-4.4-2.0.7.0-3.10.0-862.14.4.el7/7.0/x86_64/RedHat/RPMS/ibacm-41mlnx1-OFED.4.3.3.0.0.44207.x86_64.rpm
555967    4 lrwxrwxrwx   1 root     root          144 Feb 23 20:01 /export/rocks/install/rocks-dist/x86_64/RedHat/RPMS/ibacm-devel-41mlnx1-OFED.4.3.3.0.0.44207.x86_64.rpm -> \
    /export/rocks/install/rolls/mlnx-ofed-4.4-2.0.7.0-3.10.0-862.14.4.el7/7.0/x86_64/RedHat/RPMS/ibacm-devel-41mlnx1-OFED.4.3.3.0.0.44207.x86_64.rpm
```

Ultimately, when all conflicting RPMs are removed and/or conflicts otherwise
resolved the install will continue after all dependencies are resolved.
`/tmp/packaging.log` will look like this...

```
...
21:15:21,814 DEBUG packaging: Adding Package perl-CGI-3.63-4.el7.noarch in mode u
21:15:21,814 DEBUG packaging: Member: texlive-bibtex-bin.x86_64 2:svn26509.0-43.20130427_r30134.el7 - u
21:15:21,817 DEBUG packaging: Adding Package 2:texlive-bibtex-bin-svn26509.0-43.20130427_r30134.el7.x86_64 in mode u
21:15:21,817 DEBUG packaging: Member: texlive-pstricks.noarch 2:svn29678.2.39-43.el7 - u
21:15:21,821 DEBUG packaging: Adding Package 2:texlive-pstricks-svn29678.2.39-43.el7.noarch in mode u
21:15:21,821 INFO packaging:  check transaction set
21:15:21,973 INFO packaging:  order transaction set
21:15:21,999 INFO packaging:  running transaction
21:15:22,457 DEBUG packaging: Preparing transaction from installation source
21:15:23,251 DEBUG packaging: Installing libgcc (1/1973)
21:15:23,317 DEBUG packaging: Installing grub2-common (2/1973)
...
```

In the case where some nodes are to be installed with distro provided Infiniband while others are to use RPMs from the `mlnx-ofed-roll` a process to restore the distro Infiniband RPMs will be required and the `mlnx-ofed-roll` should be disabled before the Rocks distribution is rebuilt.

Obviously, supporting alternate Infiniband stacks with this roll is currently problematic.

As the selection of distribution, updates mechanism and `MLNX_OFED_LINUX` stack
supported on a particular system is unique this note will be the only effort to
describe and resolved this issue within this roll source.
