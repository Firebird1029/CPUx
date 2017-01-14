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

readmeUsers=("a" "c" "h")
readmeAdmins=("b" "d" "g")
computerUsers=("a" "e" "g")
computerAdmins=("b" "f" "h")

# /*
#  * a is a proper, existing user
#  * b is a proper, existing admin
#  * c needs to be added to users list
#  * d needs to be added to admins list
#  * e needs to be deleted from users list
#  * f needs to be deleted from admins list
#  * g needs to be promoted from user to admin
#  * h needs to be demoted from admin to user
# */

echo "${computerAdmins[@]}"
echo "${computerUsers[@]}"

usersToDelete=()
adminsToDelete=()
usersToAdd=()
adminsToAdd=()
adminsToDemote=()
usersToPromote=()

for i in "${computerUsers[@]}"; do
	if [ ! $(array_contains readmeUsers "$i") ]; then
		if [ $(array_contains readmeAdmins "$i") ]; then
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