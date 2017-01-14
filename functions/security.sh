#!/usr/bin/env bash
# Security Functions

# Notes
# Never let any command below be prefixed with sudo.

function setupFirewall () {
	ufw enable
}

function disableGuest () {
	if grep -q "allow-guest" "/etc/lightdm/lightdm.conf"; then
		echo "Guest account already disabled."
		# TODO check if guest account is disabled or enabled
	else
		echo "allow-guest=false" >> /etc/lightdm/lightdm.conf
	fi
}

function changePasswordAge () {
	sed -i "s/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS\t90/g" /etc/login.defs
	sed -i "s/PASS_MIN_DAYS\t0/PASS_MIN_DAYS\t10/g" /etc/login.defs
	sed -i "s/PASS_WARN_AGE\t7/PASS_WARN_AGE\t7/g" /etc/login.defs
}

# Require Sudo Auth
function requireSudoAuth () {
	egrep '^[^#]*NOPASSWD' /etc/sudoers /etc/sudoers.d/*
	egrep '^[^#]*!authenticate' /etc/sudoers /etc/sudoers.d/*
	visudo #DO automatically?
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
	:
	# Running from parent
else
	# Running independently
	echo "Running independently";
	setupFirewall
	disableGuest
	changePasswordAge
fi