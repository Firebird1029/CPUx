#!/usr/bin/env bash

# apt-get install vsftpd
# gedit /etc/vsftpd.conf

while IFS='' read -r line || [[ -n "$line" ]]; do
	echo "Text read from file: $line"
done < /tmp/users.txt

# IFS=$'\n' readmeUsers=($(sort <<<"${readmeUsers[*]}"))
# unset IFS