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

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
	:
	# Running from parent
else
	# Running independently
	echo "Running independently";
	setupFirewall
	secureHomes
fi