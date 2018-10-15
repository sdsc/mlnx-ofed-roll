# SDSC "mlnx-ofed" roll

## Overview

This roll bundles the Mellanox&reg; OFED Linux distribution for installation on a
Rocks&reg; cluster.

> #### IMPORTANT NOTE
>
> **The Mellanox OFED Linux software must be obtained from Mellanox&reg;
> directly as this roll only wraps the software into a Rocks&reg; roll for
> installation into a Rocks&reg; cluster.**

For more information about the various packages included in the Mellanox OFED
Linux software stack and to download the MLNX_OFED_LINUX software archive
for your system please visit their official web pages:

- [Mellanox OFED Linux (MLNX_OFED)][mlnx_ofed_linux]

[mlnx_ofed_linux]: http://www.mellanox.com/page/products_dyn?product_family=26&mtag=linux_sw_drivers


## Requirements

To build/install this roll you must have root access to a Rocks&reg; development
machine (e.g., a frontend or development appliance).

If your Rocks development machine does **not** have Internet access you must
download the appropriate MLNX_OFED_LINUX source file(s) using a machine that does
have Internet access and copy them into the `src/mlnx-ofed-linux` directory on your
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


## Alternate Versions of MLNX_OFED_LINUX

This roll is used to build the Mellanox OFED Linux stack that is **in production**
on SDSC HPC systems. As such, specific versions of [MLNX_OFED_LINUX][mlnx_ofed_linux]
sources that support our installed hardware and target OS are used in the build
process.

If your hardware or OS require a different version of [MLNX_OFED_LINUX][mlnx_ofed_linux]
it is straightforward to change the roll to build that version.

Follow these steps...

- Identify the version of [MLNX_OFED_LINUX][mlnx_ofed_linux] you would like to
build/install on your system
- Download the `tgz` version of the [MLNX_OFED_LINUX][mlnx_ofed_linux] software
stack and place in the `src/mlnx-ofed-linux` directory
- Generate an updated entry for the binary_hashes file in the `src/mlnx-ofed-linux`
directory using [this script][gen_hash]. For example...
[gen_hash]: https://raw.githubusercontent.com/sdsc/skeleton-roll/master/gen_hash.sh

```shell
    cd src/mlnx-ofed-linux
    cp ~/Downloads/MLNX_OFED_LINUX-3.4-1.0.0.0-rhel6.8-x86_64.tgz ./
    curl -LO https://raw.githubusercontent.com/sdsc/skeleton-roll/master/gen_hash.sh
    sh ./gen_hash.sh MLNX_OFED_LINUX-3.4-1.0.0.0-rhel6.8-x86_64.tgz | tee -a binary_hashes
    223210577  bc779f4b3a5c07fb801271bb68d6d07efa24fd03  MLNX_OFED_LINUX-3.4-1.0.0.0-rhel6.8-x86_64.tgz
```

- Modify the `version.mk` file in the `src/mlnx-ofed-linux` directory as/if
necessary


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
to work properly. Specifically, the creation and/or modification of the files...

    /etc/infiniband/openibd.conf
    /etc/infiniband/connectx.conf
    /etc/modprobe.d/mlx4_core.conf

...will be unique for each system.
