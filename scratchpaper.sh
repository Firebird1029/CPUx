#!/usr/bin/env bash

# apt-get install vsftpd
# gedit /etc/vsftpd.conf

computerUsersString=$(awk -F':' '$2 ~ "\$" {print $1}' /etc/shadow)
IFS='\n' read -r -a computerUsers <<< "$computerUsersString"

computerAdminsString=$(getent group sudo | cut -d: -f4)
IFS=',' read -r -a computerAdmins <<< "$computerAdminsString"

delete=()
for i in "${computerAdmins[@]}"; do
	for j in "${computerUsers[@]}"; do
		if [ "$i" == "$j" ]; then
			delete+=("$j")
		fi
	done
done

computerUsers=("${computerUsers[@]/$delete}")
echo "${computerUsers[*]}"