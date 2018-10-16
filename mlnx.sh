#!/bin/bash

find ./src -name .mlnx | xargs cat | sort -u | head -n 1
