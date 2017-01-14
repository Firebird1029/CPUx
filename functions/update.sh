#!/usr/bin/env bash
# Update Functions

# Notes
# Never let any command below be prefixed with sudo.

# Resources
# https://help.ubuntu.com/community/AptGet/Howto

function update () {
	echo "UPDATE.SH -- UPDATING"
	apt-get update
}

function installBase () {
	echo "UPDATE.SH -- INSTALLING GNOME-SESSION-FALLBACK"
	apt-get install gnome-session-fallback # Generic software.
	echo "UPDATE.SH -- INSTALLING OPENSSH-SERVER"
	apt-get install openssh-server # An essential service. TODO: Add safe option to not install this.
	echo "UPDATE.SH -- INSTALLING UNATTENDED-UPGRADES"
	apt-get install unattended-upgrades # Automatically look for updates. Will be used in Update Phase.

	echo "UPDATE.SH -- INSTALLING LIBPAM-CRACKLIB"
	apt-get install libpam-cracklib # PAM software. Will be used in Security Phase.
	echo "UPDATE.SH -- INSTALLING CLAMAV"
	apt-get install clamav  # Anti-virus. Will be used in AV Phase.
	
	# TODO: If package failed to download/does not exist, capture it, run apt-cache search <package> and show that output
}

function upgradeEssentials () {
	echo "UPDATE.SH -- UPGRADING FIREFOX"; apt-get upgrade firefox
	echo "UPDATE.SH -- UPGRADING BASH"; apt-get upgrade bash
	echo "UPDATE.SH -- UPGRADING CLAMAV"; apt-get upgrade clamav

	# apt-get upgrade vsftp # TODO do not do this if safe option
}

function enableAutomaticUpgrades () {
	echo "UPDATE.SH -- ENABLING AUTOMATIC UPDATES"
	dpkg-reconfigure -plow unattended-upgrades
}

function upgrade () {
	echo "UPDATE.SH -- UPGRADING"
	apt-get upgrade
}

function distUpgrade () {
	echo "UPDATE.SH -- DIST UPGRADING"
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
	upgradeEssentials
	enableAutomaticUpgrades
fi