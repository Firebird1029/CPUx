# quietly add a user without password
adduser --quiet --disabled-password --shell /bin/bash --home /home/newuser --gecos "User" newuser

# set password
echo "newuser:newpassword" | chpasswd