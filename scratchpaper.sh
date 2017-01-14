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

function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
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

echo "${readmeUsers[@]}"
echo "${readmeAdmins[@]}"
echo "${computerAdmins[@]}"
echo "${computerUsers[@]}"

usersToDelete=()
adminsToDelete=()
usersToAdd=()
adminsToAdd=()
adminsToDemote=()
usersToPromote=()

if echo ${arr[@]} | grep -q -w "d"; then 
    echo "is in array"
else 
    echo "is not in array"
fi

for i in "${computerUsers[@]}"; do
	echo "$i"
	if [ ! $(contains "${readmeUsers[@]}" "$i") == "y" ]; then
		echo "readmeUsers does not contain " "$i"
		if [ $(echo ${readmeAdmins[@]} | grep -q -w "$i") ]; then
			# This user needs to be promoted from user to admin.
			echo "readmeAdmins contains " "$i"
			usersToPromote+=("$i")
		else
			# This user needs to be deleted from the users list.
			echo "readmeAdmins does not contain " "$i"
			usersToDelete+=("$i")
		fi
	else
		echo "readmeUsers contains " "$i"
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