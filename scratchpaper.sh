if grep -q "allow-guest" "/etc/lightdm/lightdm.conf"; then
	 echo "Allow guest settings already exists."
 else
 	echo "allow-guest=false" >> /etc/lightdm/lightdm.conf;
 fi