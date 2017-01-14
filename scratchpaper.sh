#!/usr/bin/env bash

# apt-get install vsftpd
# gedit /etc/vsftpd.conf

computerAdminsString=$(getent group sudo | cut -d: -f4)
IFS=',' read -r -a computerAdmins <<< "$computerAdminsString"
echo $computerAdminsString
echo $computerAdmins[*]
echo $computerAdmins[0]
echo $computerAdmins[1]
echo $computerAdmins[2]
echo $computerAdmins[-1]