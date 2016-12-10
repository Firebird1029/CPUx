#!/usr/bin/env bash
# Setup an SSH key on a Linux computer.
# https://help.github.com/articles/generating-an-ssh-key/

echo -n "Please exit out of sudo. Press Ctrl+C to exit this script to exit sudo, or press Enter to continue with this script."
read

# https://help.github.com/articles/checking-for-existing-ssh-keys/#platform-linux
echo; echo "Listing contents of SSH folder."
ls -al ~/.ssh

echo; echo -n "Github email address?"
read githubEmailAddress

# https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#platform-linux
echo; echo "Generating a new SSH key."
ssh-keygen -t rsa -b 4096 -C ${githubEmailAddress}
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/#platform-linux
echo; echo "Copying SSH key to clipboard."
sudo apt-get install xclip
xclip -sel clip < ~/.ssh/id_rsa.pub

# https://help.github.com/articles/testing-your-ssh-connection/#platform-linux
echo; echo -n "Please add the SSH key to github.com. When finished, press Enter to continue with this script."
read

echo "Testing SSH key."
ssh -T git@github.com

exit