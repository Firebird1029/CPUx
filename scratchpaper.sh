#!/usr/bin/env bash

# apt-get install vsftpd
# gedit /etc/vsftpd.conf

computerUsersString=$(awk -F':' '$2 ~ "\$" {print $1}' /etc/shadow | tr '\n' ',')
IFS=',' read -r -a computerUsers <<< "$computerUsersString"

computerAdminsString=$(getent group sudo | cut -d: -f4)
IFS=',' read -r -a computerAdmins <<< "$computerAdminsString"

# echo "${computerAdmins[@]}"
# echo "${computerUsers[@]}"

tempUsersArray="${computerUsers[@]}"
computerUsers=()
for i in "${tempUsersArray[@]}"; do
	for j in "${computerAdmins[@]}"; do
		if [ "$i" != "$j" ]; then
			echo "Add this entry"
			computerUsers+=("$j")
		fi
	done
done


echo "${computerAdmins[@]}"
echo "${computerUsers[@]}"