#!/bin/bash

/bin/rpm -q --queryformat "%{VERSION}-%{RELEASE}\n" kernel-`uname -r`
