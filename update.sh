#!/usr/bin/env bash
# Update

# https://help.ubuntu.com/community/AptGet/Howto

function update () {
	apt-get update
}

function installBase () {
	apt-get install gnome-session-fallback # Package description here
	apt-get install clamav  # Package desc here
	apt-get install libpam-cracklib # here
	apt-get install unattended-upgrades
	# If package failed to download/does not exist, capture it, run apt-cache search <package> and show that output
}

function enableAutomaticUpgrades () {
	# Not finished yet! Does not work
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
fi