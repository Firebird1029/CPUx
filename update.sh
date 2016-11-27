#!/usr/bin/env bash
# Update and Install software

# needs to be tested, (linux computer) probably works :)

sudo -i
apt-get update *
apt-get install gnome-session-fallback
apt-get upgrade * 
exit