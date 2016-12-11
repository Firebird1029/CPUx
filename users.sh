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

function processUsers () {
	### Analyze Users
	##############################################################################

	# http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_08_02.html
	echo "Enter users listed in README. Enter one user per line, then use the \"%\" character to exit out of the read command. List users here:"
	read -a readmeUsers -d "%" # Get user input.
	# echo ""; echo "README Users: "${readmeUsers[*]}

	qsort ${readmeUsers[*]} # Sort users.
	readmeUsersSorted=(${qsort_ret[@]}) # Store sorted list in a variable.
	# echo "README Users Sorted: "${readmeUsersSorted[*]} # TODO Change to debug
	# echo "Last README User: "${readmeUsersSorted[${#readmeUsersSorted[@]}-1]}
	
	# Get Admin Users from README
	
	# Get Computer Users
	
	# Get Computer Admins
	# sudo cat /etc/group
	# awk -F':' '$2 ~ "\$" {print $1}' /etc/shadow

	usersToDelete=()
	usersToAdd=()
	adminsToDemote=()
	usersToPromote=()

	### Delete Users
	##############################################################################
	
	# Do not delete admin users or yourself!

	for useri in "${usersToDelete[@]}"; do
		userdel $useri
		# rm -r /home/username # TODO enable on unsafe option
	done

	### Add Users
	##############################################################################
	
	# http://stackoverflow.com/questions/2150882/how-to-automatically-add-user-account-and-password-with-a-bash-script
	for useri in "${usersToAdd[@]}"; do
		# adduser --quiet --disabled-password --shell /bin/bash --home /home/$useri --gecos "User" $useri # TODO decode this line
	done

	### Demote Admins
	##############################################################################
	
	for useri in "${adminsToDemote[@]}"; do
		deluser $useri sudo
	done

	### Promote Users
	##############################################################################

	# TODO: easy to do, just research it
	
	### Set All Users' Passwords
	##############################################################################
	
	# Get Computer Users Again
	
	for useri in "${bobobobobobobobobobobobobobobobobobobobobobobobobobobobobobob[@]}"; do
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