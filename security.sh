#!/usr/bin/env bash
# Firewall setup 

# needs to be tested, (linux computer) probably works :)

function setupFirewall () {
	ufw enable
	exit
	sudo chmod 0750 *
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
	:
	# Running from parent
else
	# Running independently
	echo "Running independently";
	setupFirewall
fi