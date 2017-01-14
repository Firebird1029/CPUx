# DO NOT RUN THIS FILE

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

### Get README Users
##############################################################################
# http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_08_02.html
echo "Enter users (NOT admins) listed in README. Enter one user per line, then use the \"%\" character to exit out of the read command. List users here:"
read -a readmeUsers -d "%" # Get user input.
echo; echo;
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
echo; echo;

IFS=$'\n' readmeAdmins=($(sort <<<"${readmeAdmins[*]}"))
unset IFS
# qsort ${readmeAdmins[*]} # Sort users.
# readmeAdmins=(${qsort_ret[@]}) # Store sorted list in a variable.