#!/usr/bin/env bash

# apt-get install vsftpd
# gedit /etc/vsftpd.conf

awk -F':' '$2 ~ "\$" {print $1}' /etc/shadow | tr '\n' ','