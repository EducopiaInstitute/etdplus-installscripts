#!/bin/sh
#
# Prints out the environmental settings for the platform specified as an argument
# (vagrant or aws).  The settings are taken from the config*.sh files, which
# are assumed to be in the same directory as this script.

PLATFORM=$1
# Read settings and environmental overrides
[ -f "config.sh" ] && . "config.sh"
[ -f "config_${PLATFORM}.sh" ] && . "config_${PLATFORM}.sh"
set
