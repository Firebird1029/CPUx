#!/usr/bin/env bash

# apt-get install vsftpd
# gedit /etc/vsftpd.conf

# computerUsersString=$(awk -F':' '$2 ~ "\$" {print $1}' /etc/shadow | tr '\n' ',')
# IFS=',' read -r -a computerUsers <<< "$computerUsersString"

# computerAdminsString=$(getent group sudo | cut -d: -f4)
# IFS=',' read -r -a computerAdmins <<< "$computerAdminsString"

# echo "${computerAdmins[@]}"
# echo "${computerUsers[@]}"

computerUsers=( a b c d )
computerAdmins=( b c )

tempUsersArray="${computerUsers[@]}"
computerUsers=()
for i in "${tempUsersArray[@]}"; do
	echo "$i"
	skipThisEntry="dontskip"

	for j in "${computerAdmins[@]}"; do
		if [ "$i" == "$j" ]; then
			skipThisEntry="skip"
		fi
	done

	echo "$skipThisEntry"
	if [ "$skipThisEntry" == "dontskip" ]; then
		computerUsers+=("$i")
	fi
done

echo "${tempUsersArray[@]}"
echo "${computerAdmins[@]}"
echo "${computerUsers[@]}"