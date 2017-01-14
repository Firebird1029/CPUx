#!/usr/bin/env bash

# apt-get install vsftpd
# gedit /etc/vsftpd.conf

array_contains () { 
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array}"; do
        if [[ $element == $seeking ]]; then
            in=0
            break
        fi
    done
    return $in
}

computerUsersString=$(awk -F':' '$2 ~ "\$" {print $1}' /etc/shadow | tr '\n' ',')
IFS=',' read -r -a computerUsers <<< "$computerUsersString"
unset computerUsers[0] # Remove root

computerAdminsString=$(getent group sudo | cut -d: -f4)
IFS=',' read -r -a computerAdmins <<< "$computerAdminsString"

tempUsersArray=("${computerUsers[@]}")
computerUsers=()

# Remove Admins From Users List
echo "Removing admins from user list."

for i in "${tempUsersArray[@]}"; do
	skipThisEntry=0

	for j in "${computerAdmins[@]}"; do
		if [ "$i" == "$j" ]; then
			skipThisEntry=1
		fi
	done

	if [ $skipThisEntry -eq 0 ]; then
		computerUsers+=("$i")
	fi
done

echo "${tempUsersArray[@]}"
echo "${computerAdmins[@]}"
echo "${computerUsers[@]}"

usersToDelete=()
adminsToDelete=()
usersToAdd=()
adminsToAdd=()
adminsToDemote=()
usersToPromote=()

for i in "${computerUsers[@]}"; do
	if [[ ! $(array_contains readmeUsers "$i") ]]; then
		if [[ $(array_contains readmeAdmins "$i") ]]; then
			# This user needs to be promoted from user to admin.
			usersToPromote+=("$i")
		else
			# This user needs to be deleted from the users list.
			usersToDelete+=("$i")
		fi
	fi
done

echo "These users will be deleted:"
echo "${usersToDelete[@]}"
echo; echo "These admins will be deleted:"
echo "${adminsToDelete[@]}"
echo; echo "These users will be added:"
echo "${usersToAdd[@]}"
echo; echo "These admins will be added:"
echo "${adminsToAdd[@]}"
echo; echo "These admins will be demoted:"
echo "${adminsToDemote[@]}"
echo; echo "These users will be promoted:"
echo "${usersToPromote[@]}"