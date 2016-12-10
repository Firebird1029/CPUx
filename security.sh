#!/usr/bin/env bash
# Security

function setupFirewall () {
	ufw enable
}

function secureHomes () {
	# move this to user
	chmod 0750 /home/*
}

function disableGuest () {
	if grep -q "allow-guest" "/etc/lightdm/lightdm.conf"; then
		echo "Guest account already disabled."
	else
		echo "allow-guest=false" >> /etc/lightdm/lightdm.conf;
	fi
}

function changePasswordAge () {
	sed -i "s/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS\t90/g" bib
	sed -i "s/PASS_MIN_DAYS\t0/PASS_MIN_DAYS\t10/g" bib
	sed -i "s/PASS_WARN_AGE\t7/PASS_WARN_AGE\t90/g" bib
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
	changePasswordAge
fi