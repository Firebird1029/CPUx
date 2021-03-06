#!/usr/bin/env bash
# Users Functions

# Notes
# Never let any command below be prefixed with sudo.

# http://serverfault.com/questions/477503/check-if-array-is-empty-in-bash
errors=()
if [ ${#errors[@]} -eq 0 ]; then
	# Array is empty
	:
else
	# Array contains something
	:
fi

# http://stackoverflow.com/questions/3685970/check-if-an-array-contains-a-value
function contains () {
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

function processUsers () {
	### Create Users Lists
	##############################################################################

	### Get README Users
	##############################################################################
	# http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_08_02.html
	echo "Put a list of users (NOT admins) in a file, saved as: /tmp/users.txt"
	readmeUsers=()
	while IFS='' read -r line || [[ -n "$line" ]]; do
		readmeUsers+=("$line") # TODO find a better way to do this
	done < /tmp/users.txt

	IFS=$'\n' readmeUsers=($(sort <<<"${readmeUsers[*]}"))
	unset IFS
	
	### Get README Admins
	##############################################################################
	echo "Put a list of admins (NOT users) in a file, saved as: /tmp/admins.txt"
	readmeAdmins=()
	while IFS='' read -r line || [[ -n "$line" ]]; do
		readmeAdmins+=("$line") # TODO find a better way to do this
	done < /tmp/admins.txt

	IFS=$'\n' readmeAdmins=($(sort <<<"${readmeAdmins[*]}"))
	unset IFS

	### Get Computer Users & Admins
	##############################################################################
	echo "Getting computer users and admins."

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
	
	### Analyze User Lists
	##############################################################################
	# See userAlgorithm.js for original algorithm.
	echo "Analyzing user lists."

	usersToDelete=()
	adminsToDelete=()
	usersToAdd=()
	adminsToAdd=()
	adminsToDemote=()
	usersToPromote=()

	for i in "${computerUsers[@]}"; do
		if [ ! $(contains "${readmeUsers[@]}" "$i") == "y" ]; then
			if [ $(contains "${readmeAdmins[@]}" "$i") == "y" ]; then
				# This user needs to be promoted from user to admin.
				usersToPromote+=("$i")
			else
				# This user needs to be deleted from the users list.
				usersToDelete+=("$i")
			fi
		fi
	done

	for i in "${computerAdmins[@]}"; do
		if [ ! $(contains "${readmeAdmins[@]}" "$i") == "y" ]; then
			if [ $(contains "${readmeUsers[@]}" "$i") == "y" ]; then
				# This admin needs to be demoted from admin to user.
				adminsToDemote+=("$i")
			else
				# This admin needs to be deleted from the admin list.
				adminsToDelete+=("$i")
			fi
		fi
	done

	for i in "${readmeUsers[@]}"; do
		if [ ! $(contains "${computerUsers[@]}" "$i") == "y" ]; then
			# This user needs to be added to the users list.
			usersToAdd+=("$i")
		fi
	done

	for i in "${readmeAdmins[@]}"; do
		if [ ! $(contains "${computerAdmins[@]}" "$i") == "y" ]; then
			# This user needs to be added to the admins list.
			adminsToAdd+=("$i")
		fi
	done

	### Confirmation Screen
	##############################################################################
	if [ ${#usersToDelete[@]} -eq 0 ]; then
		# Array is empty
		echo "No users will be deleted."
	else
		# Array contains something
		echo "These users will be deleted:"
		echo "${usersToDelete[@]}"
	fi
	echo
	
	if [ ${#adminsToDelete[@]} -eq 0 ]; then
		# Array is empty
		echo "No admins will be deleted."
	else
		# Array contains something
		echo "These admins will be deleted:"
		echo "${adminsToDelete[@]}"
	fi
	echo

	if [ ${#usersToAdd[@]} -eq 0 ]; then
		# Array is empty
		echo "No users will be added."
	else
		# Array contains something
		echo "These users will be added:"
		echo "${usersToAdd[@]}"
	fi
	echo

	if [ ${#adminsToAdd[@]} -eq 0 ]; then
		# Array is empty
		echo "No admins will be added."
	else
		# Array contains something
		echo "These admins will be added:"
		echo "${adminsToAdd[@]}"
	fi
	echo

	if [ ${#adminsToDemote[@]} -eq 0 ]; then
		# Array is empty
		echo "No admins will be demoted."
	else
		# Array contains something
		echo "These admins will be demoted:"
		echo "${adminsToDemote[@]}"
	fi
	echo

	if [ ${#usersToPromote[@]} -eq 0 ]; then
		# Array is empty
		echo "No users will be promoted."
	else
		# Array contains something
		echo "These users will be promoted:"
		echo "${usersToPromote[@]}"
	fi
	echo

	confirmation=0
	echo; echo; echo "Confirm that these lists are correct and complete before proceeding."
	read -p "Are you sure you want to continue? " -n 1 -r; echo
	read -p "Are you very, very sure you want to continue? " -n 1 -r; echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		confirmation=1
	fi

	if [[ $confirmation -eq 0 ]]; then
		exit
	fi

	### Delete Users & Admins
	##############################################################################
	echo "Deleting users and admins."
	
	# Do not delete admin users or yourself!

	if [ ! ${#usersToDelete[@]} -eq 0 ]; then
		# Array contains something
		for useri in "${usersToDelete[@]}"; do
			userdel $useri
			# rm -r /home/username # TODO enable on unsafe option
		done
	fi

	if [ ! ${#adminsToDelete[@]} -eq 0 ]; then
		# Array contains something
		for useri in "${adminsToDelete[@]}"; do
			userdel $useri
			# rm -r /home/username # TODO enable on unsafe option
		done
	fi

	### Add Users & Admins
	##############################################################################
	echo "Adding users and admins."
	
	# http://stackoverflow.com/questions/2150882/how-to-automatically-add-user-account-and-password-with-a-bash-script
	
	if [ ! ${#usersToAdd[@]} -eq 0 ]; then
		# Array contains something
		for useri in "${usersToAdd[@]}"; do
			adduser --quiet --disabled-password --shell /bin/bash --home /home/$useri --gecos "User" $useri # TODO decode this line
		done
	fi

	if [ ! ${#adminsToAdd[@]} -eq 0 ]; then
		# Array contains something
		for useri in "${adminsToAdd[@]}"; do
			adduser --quiet --disabled-password --shell /bin/bash --home /home/$useri --gecos "User" $useri
			adduser $useri sudo
		done
	fi

	### Demote Admins
	##############################################################################
	echo "Demoting admins."
	
	if [ ! ${#adminsToDemote[@]} -eq 0 ]; then
		# Array contains something
		for useri in "${adminsToDemote[@]}"; do
			deluser $useri sudo
		done
	fi

	### Promote Users
	##############################################################################
	echo "Promoting users."

	if [ ! ${#usersToPromote[@]} -eq 0 ]; then
		# Array contains something
		# TODO: repeated lines of code in Add Users & Admins section
		for useri in "${usersToPromote[@]}"; do
			adduser $useri sudo
		done
	fi

	### Set All Users' Passwords
	##############################################################################
	echo "Setting all users' passwords."
	
	# Get Computer Users Again
	computerUsersString=$(awk -F':' '$2 ~ "\$" {print $1}' /etc/shadow | tr '\n' ',')
	IFS=',' read -r -a computerUsers <<< "$computerUsersString"
	unset computerUsers[0] # Remove root
	
	for useri in "${computerUsers[@]}"; do
		echo -e "$useri:JasonTay1234--" | chpasswd
		chmod 0750 /home/$useri # Secure home folder of user
	done
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
	:
	# Running from parent
else
	# Running independently
	echo "Running independently";
	processUsers
fi