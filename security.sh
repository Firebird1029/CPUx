#!/usr/bin/env bash
# Security

function setupFirewall () {
	ufw enable
	exit
}

function secureHomes () {
	# move this to user
	chmod 0750 /home/*
	exit
}

function disableGuest () {
	if grep -q "allow-guest" "/etc/lightdm/lightdm.conf"; then
		echo "Guest account already disabled."
	else
		echo "allow-guest=false" >> /etc/lightdm/lightdm.conf;
	fi
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
	:
	# Running from parent
else
	# Running independently
	echo "Running independently";
	setupFirewall
	secureHomes
	disableGuest
fi