# echo "${BASH_SOURCE[0]}"
# echo "${0}"

bob="i am bob"

# if [ 1 -eq 2 ]; then
# 	echo "yes"
# else
# 	echo "no"
# fi

function grass () {
	echo "i am grass"
}

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
	echo "running from parent"
else
	echo "running from child"
	# grass
fi

# if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
#   # if [ ! -z ${bob} ]; then
#   # 	echo "inside first fi"
#   # fi
# else
#   echo "inside second if"
# fi