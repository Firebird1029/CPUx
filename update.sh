#!/usr/bin/env bash
# Update Functions

# Notes
# Never let any command below be prefixed with sudo.

# Resources
# https://help.ubuntu.com/community/AptGet/Howto

function update () {
	apt-get update
}

function installBase () {
	apt-get install gnome-session-fallback # Generic software.
	apt-get install openssh-server # An essential service. TODO: Add safe option to not install this.
	apt-get install unattended-upgrades # Automatically look for updates. Will be used in Update Phase.

	apt-get install libpam-cracklib # PAM software. Will be used in Security Phase.
	apt-get install clamav  # Anti-virus. Will be used in AV Phase.
	
	# TODO: If package failed to download/does not exist, capture it, run apt-cache search <package> and show that output
}

function enableAutomaticUpgrades () {
	dpkg-reconfigure -plow unattended-upgrades
}

function upgrade () {
	apt-get upgrade
}

function distUpgrade () {
	apt-get dist-upgrade
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
	:
	# Running from parent
else
	# Running independently
	echo "Running independently";
	update
	installBase
	enableAutomaticUpgrades
fi