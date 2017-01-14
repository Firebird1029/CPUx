#!/usr/bin/env bash

# apt-get install vsftpd
# gedit /etc/vsftpd.conf

IFS='' read -r -a readmeUsers < /tmp/users.txt

IFS=$'\n' readmeUsers=($(sort <<<"${readmeUsers[*]}"))
unset IFS

echo "${readmeUsers[@]}"