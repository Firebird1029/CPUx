#!/usr/bin/env bash
# Users

# quicksorts positional arguments
# return is in array qsort_ret
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
      # adduser --quiet --disabled-password --shell /bin/bash --home /home/$useri --gecos "User" $useri
      echo -e "$useri:JasonTay1234--" | chpasswd
   done
}

# Require Sudo Auth TODO
function requireSudoAuth () {
   egrep '^[^#]*NOPASSWD' /etc/sudoers /etc/sudoers.d/*
   egrep '^[^#]*!authenticate' /etc/sudoers /etc/sudoers.d/*
   visudo #DO automatically?
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
   :
   # Running from parent
else
   # Running independently
   echo "Running independently";
   
fi