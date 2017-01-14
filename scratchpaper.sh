#!/usr/bin/env bash

# apt-get install vsftpd
# gedit /etc/vsftpd.conf

IFS='' read -r line || [[ -n "$line" ]]; do
	echo "Text read from file: $line"
done < ~/Desktop/users.txt

# IFS=$'\n' readmeUsers=($(sort <<<"${readmeUsers[*]}"))
# unset IFS