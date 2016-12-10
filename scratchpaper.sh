if grep -Fxq "$FILENAME" /etc/lightdm/lightdm.conf
then
    echo "found"
else
    echo "not found"
fi