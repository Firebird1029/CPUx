if grep -Fxq "$FILENAME" my_list.txt
then
    echo "found"
else
    echo "not found"
fi