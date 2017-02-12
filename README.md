# SDSC "mlnx-ofed" roll

## Overview

This roll bundles the Mellanox OFED Linux distribution for installation on a Rocks(r) cluster.


## Requirements

To build/install this roll you must have root access to a Rocks development
machine (e.g., a frontend or development appliance).

If your Rocks development machine does *not* have Internet access you must
download the appropriate mpi source file(s) using a machine that does
have Internet access and copy them into the `src/<package>` directories on your
Rocks development machine.


## Dependencies

This roll wraps up the basic Mellanox OFED Linux installation process into a
Rocks&reg; roll which can be used to install all nodes in a cluster. Part of this
process includes building kernel modules for the running kernel and adding the
produced RPMs to the roll. Otherwise, binary RPMs provided by Mellanox are
added unchanged to the roll.

To build updated kernel modules the following packages are required on the
host building the roll...

- perl
- pciutils
- python
- gcc-gfortran
- libxml2-python
- tcsh
- libnl.i686
- libnl
- expat
- glib2
- tcl
- libstdc++
- bc
- tk
- gtk2
- atk
- cairo
- numactl
- pkgconfig
- ethtool

These RPMs are generally included on Rocks&reg; frontend and development servers.

*NOTE: The roll build process will **UNINSTALL** all Mellanox OFED Linux RPMs
from the build server during the roll build. DO NOT build this roll on a
frontend which is acting as your subnet manager.*




## Building

To build the mlnx-ofed-roll, execute these instructions on a Rocks development
machine (e.g., a frontend or development appliance):

```shell
% make default 2>&1 | tee build.log
% grep "RPM build error" build.log
```

If nothing is returned from the grep command then the roll should have been
created as... `mlnx-ofed-*.iso`. If you built the roll on a Rocks frontend then
proceed to the installation step. If you built the roll on a Rocks development
appliance you need to copy the roll to your Rocks frontend before continuing
with installation.


## Installation

To install, execute these instructions on a Rocks frontend:

```shell
% rocks add roll mlnx-ofed-*.iso
% rocks enable roll mlnx-ofed
% cd /export/rocks/install
% rocks create distro
% rocks run roll mlnx-ofed | bash
```


## Configuration

The mlnx-ofed roll will likely need configuration for your system in order
to work properly. Specifically, the modification of the files...

    /etc/infiniband/openibd.conf
    /etc/infiniband/connectx.conf
    /etc/modprobe.d/mlx4_core.conf

...will be unique for each system.


