#!/usr/bin/env bash
# Users

# quicksorts positional arguments
# return is in array qsort_ret
# http://stackoverflow.com/questions/7442417/how-to-sort-an-array-in-bash
qsort () {
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

# http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_08_02.html
echo "Enter users listed in README. Enter one user per line, then use the \"%\" character to exit out of the read command. List users here:"
read -a readmeUsers -d "%" # Get user input.
echo ""; echo "README Users: "${readmeUsers[*]} # TODO change to debug
qsort ${readmeUsers[*]} # Sort users.
readmeUsersSorted=(${qsort_ret[@]}) # Store sorted list in a variable.
echo "README Users Sorted: "${readmeUsersSorted[*]} # TODO Change to debug
# echo "Last README User: "${readmeUsersSorted[${#readmeUsersSorted[@]}-1]}

# quietly add a user without password
# http://stackoverflow.com/questions/2150882/how-to-automatically-add-user-account-and-password-with-a-bash-script
for useri in "${readmeUsersSorted[@]}"; do
   echo $useri
   adduser --quiet --disabled-password --shell /bin/bash --home /home/newuser --gecos "User" $useri
   echo "$useri:JasonTay1234!@" | chpasswd
done