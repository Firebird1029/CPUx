#!/usr/bin/env bash
# Users Functions

# Notes
# Never let any command below be prefixed with sudo.

# http://stackoverflow.com/questions/7442417/how-to-sort-an-array-in-bash
function qsort () {
	local pivot i smaller=() larger=()
	qsort_ret=()
	(($#==0)) && return 0
	pivot=$1
	shift
	for i; do
		if [[ $i < $pivot ]]; then
			smaller+=( "$i" )
		else
			larger+=( "$i" )
		fi
	done
	qsort "${smaller[@]}"
	smaller=( "${qsort_ret[@]}" )
	qsort "${larger[@]}"
	larger=( "${qsort_ret[@]}" )
	qsort_ret=( "${smaller[@]}" "$pivot" "${larger[@]}" )
}

# http://stackoverflow.com/questions/14366390/bash-if-condition-check-if-element-is-present-in-array
# arr=(a b c "d e" f g)
# array_contains arr "a b"  && echo yes || echo no	# no
# array_contains arr "d e"  && echo yes || echo no	# yes
function array_contains () { 
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

function processUsers () {
	### Create Users Lists
	##############################################################################

	### Get README Users
	##############################################################################
	# http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_08_02.html
	echo "Enter users (NOT admins) listed in README. Enter one user per line, then use the \"%\" character to exit out of the read command. List users here:"
	read -a readmeUsers -d "%" # Get user input.
	# echo ""; echo "README Users: "${readmeUsers[*]}

	IFS=$'\n' readmeUsers=($(sort <<<"${readmeUsers[*]}"))
	unset IFS
	# qsort ${readmeUsers[*]} # Sort users.
	# readmeUsers=(${qsort_ret[@]}) # Store sorted list in a variable.
	
	# echo "README Users Sorted: "${readmeUsers[*]} # TODO Change to debug
	# echo "Last README User: "${readmeUsers[${#readmeUsers[@]}-1]}
	
	### Get README Admins
	##############################################################################
	echo "Enter admins (NOT standard users) listed in README. Enter one user per line, then use the \"%\" character to exit out of the read command. List admins here:"
	read -a readmeAdmins -d "%"

	IFS=$'\n' readmeAdmins=($(sort <<<"${readmeAdmins[*]}"))
	unset IFS
	# qsort ${readmeAdmins[*]} # Sort users.
	# readmeAdmins=(${qsort_ret[@]}) # Store sorted list in a variable.

	### Get Computer Users & Admins
	##############################################################################
	computerUsersString=$(awk -F':' '$2 ~ "\$" {print $1}' /etc/shadow | tr '\n' ',')
	IFS=',' read -r -a computerUsers <<< "$computerUsersString"
	unset computerUsers[0] # Remove root

	computerAdminsString=$(getent group sudo | cut -d: -f4)
	IFS=',' read -r -a computerAdmins <<< "$computerAdminsString"

	tempUsersArray=("${computerUsers[@]}")
	computerUsers=()

	# Remove Admins From Users List
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
	
	### Analyze User Lists
	##############################################################################
	# See userAlgorithm.js for original algorithm.

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

	for i in "${computerAdmins[@]}"; do
		if [ ! $(array_contains readmeAdmins "$i") ]; then
			if [ $(array_contains readmeUsers "$i") ]; then
				# This admin needs to be demoted from admin to user.
				adminsToDemote+=("$i")
			else
				# This admin needs to be deleted from the admin list.
				adminsToDelete+=("$i")
			fi
		fi
	done

	for i in "${readmeUsers[@]}"; do
		if [ ! $(array_contains computerUsers "$i") ]; then
			# This user needs to be added to the users list.
			usersToAdd+=("$i")
		fi
	done

	for i in "${readmeAdmins[@]}"; do
		if [ ! $(array_contains computerAdmins "$i") ]; then
			# This user needs to be added to the admins list.
			adminsToAdd+=("$i")
		fi
	done

	### Delete Users & Admins
	##############################################################################
	
	# Do not delete admin users or yourself!

	for useri in "${usersToDelete[@]}"; do
		userdel $useri
		# rm -r /home/username # TODO enable on unsafe option
	done

	for useri in "${adminsToDelete[@]}"; do
		userdel $useri
		# rm -r /home/username # TODO enable on unsafe option
	done

	### Add Users & Admins
	##############################################################################
	
	# http://stackoverflow.com/questions/2150882/how-to-automatically-add-user-account-and-password-with-a-bash-script
	for useri in "${usersToAdd[@]}"; do
		adduser --quiet --disabled-password --shell /bin/bash --home /home/$useri --gecos "User" $useri # TODO decode this line
	done

	for useri in "${adminsToAdd[@]}"; do
		adduser --quiet --disabled-password --shell /bin/bash --home /home/$useri --gecos "User" $useri
		adduser $useri sudo
	done

	### Demote Admins
	##############################################################################
	
	for useri in "${adminsToDemote[@]}"; do
		deluser $useri sudo
	done

	### Promote Users
	##############################################################################

	# TODO: repeated lines of code in Add Users & Admins section
	for useri in "${usersToPromote[@]}"; do
		adduser $useri sudo
	done
	
	### Set All Users' Passwords
	##############################################################################
	
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