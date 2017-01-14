#!/usr/bin/env bash

# apt-get install vsftpd
# gedit /etc/vsftpd.conf

readmeUsers=()
while IFS='' read -r line || [[ -n "$line" ]]; do
	readmeUsers+=("$line") # TODO find a better way to do this
done < /tmp/users.txt

IFS=$'\n' readmeUsers=($(sort <<<"${readmeUsers[*]}"))
unset IFS

echo "${readmeUsers[*]}"