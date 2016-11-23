#!/usr/bin/env bash
# Table


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
read -a readmeUsers -d "%"
echo ""; echo "README Users: "${readmeUsers[*]}
qsort ${readmeUsers[*]}
readmeUsersSorted=(${qsort_ret[@]})
echo "README Users Sorted: "${readmeUsersSorted[*]}
# echo "Last README User: "${readmeUsersSorted[${#readmeUsersSorted[@]}-1]}