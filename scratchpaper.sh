#!/usr/bin/env bash

# apt-get install vsftpd
# gedit /etc/vsftpd.conf

computerUsersString=$(awk -F':' '$2 ~ "\$" {print $1}' /etc/shadow | tr '\n' ',')
IFS=',' read -r -a computerUsers <<< "$computerUsersString"

computerAdminsString=$(getent group sudo | cut -d: -f4)
IFS=',' read -r -a computerAdmins <<< "$computerAdminsString"

# echo "${computerAdmins[@]}"
# echo "${computerUsers[@]}"

tempUsersArray=("${computerUsers[@]}")
computerUsers=()

for i in "${tempUsersArray[@]}"; do
	skipThisEntry=0

	for j in "${computerAdmins[@]}"; do
		if [ "$i" == "$j" ]; then
			skipThisEntry=1
		fi
	done

	echo "$skipThisEntry"
	if [ $skipThisEntry -eq 0 ]; then
		computerUsers+=("$i")
	fi
done

echo "${tempUsersArray[@]}"
echo "${computerAdmins[@]}"
echo "${computerUsers[@]}"