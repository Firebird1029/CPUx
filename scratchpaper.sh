#!/usr/bin/env bash

# apt-get install vsftpd
# gedit /etc/vsftpd.conf

computerUsersString=$(awk -F':' '$2 ~ "\$" {print $1}' /etc/shadow | tr '\n' ',')
IFS=',' read -r -a computerUsers <<< "$computerUsersString"

computerAdminsString=$(getent group sudo | cut -d: -f4)
IFS=',' read -r -a computerAdmins <<< "$computerAdminsString"

# echo "${computerAdmins[@]}"
# echo "${computerUsers[@]}"

delete=()
for i in "${computerAdmins[@]}"; do
	for j in "${computerUsers[@]}"; do
		if [ "$i" == "$j" ]; then
			echo "equal!"
			delete+=("$j")
		fi
	done
done

# echo "${computerAdmins[@]}"
# echo "${computerUsers[@]}"

computerUsers=("${computerUsers[@]/$delete}")

echo "${computerAdmins[@]}"
echo "${computerUsers[@]}"