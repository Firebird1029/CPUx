#!/usr/bin/env bash
# Update

# https://help.ubuntu.com/community/AptGet/Howto

function update () {
	apt-get update
	exit
}

function installBase () {
	apt-get install gnome-session-fallback # Package description here
	sudo apt-get install clamav  # Package desc here
	# If package failed to download/does not exist, capture it, run apt-cache search <package> and show that output
	exit
}

function upgrade () {
	apt-get upgrade
	exit
}

function distUpgrade () {
	apt-get dist-upgrade
	exit
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