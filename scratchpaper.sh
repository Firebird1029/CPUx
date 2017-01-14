#!/usr/bin/env bash

# apt-get install vsftpd
# gedit /etc/vsftpd.conf

computerUsersString=$(awk -F':' '$2 ~ "\$" {print $1}' /etc/shadow | tr '\n' ',') # TODO does this work on ubuntu?
# IFS='' read -r -a computerUsers <<< "$computerUsersString"
echo $computerUsersString
# echo "${computerUsers[*]}"
# echo "${computerUsers[@]}"
# echo "${computerUsers[0]}"
# echo "${computerUsers[1]}"
# echo "${computerUsers[2]}"
# echo "${computerUsers[-1]}"