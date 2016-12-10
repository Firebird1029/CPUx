#!/usr/bin/env bash

echo "Current home user (non-root user): "
read curUser
ls -al /home/${curUser}/.ssh
