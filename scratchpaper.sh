if grep -Fxq "Seat" /etc/lightdm/lightdm.conf
then
    echo "found"
else
    echo "not found"
fi