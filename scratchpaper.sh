#!/usr/bin/env bash

egrep '^[^#]*NOPASSWD' /etc/sudoers /etc/sudoers.d/*
egrep '^[^#]*!authenticate' /etc/sudoers /etc/sudoers.d/*