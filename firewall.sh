#!/usr/bin/env bash
# Firewall setup 

# needs to be tested, (linux computer) probably works :)

sudo -i
ufw enable
status=$(ufw status)
echo ${status}
exit