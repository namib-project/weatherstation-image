#!/bin/bash

read -p "new username: " name
while true; do
    read -s -p "new password: " passwd
    echo
    read -s -p "repeat passwd: " passwd2
    echo
    [ "$passwd" = "$passwd2" ] && break
    echo "The passwords are not equal. Please try again."
done

read -p "This action changes the administrational acces to the Node-Red editor. Are you sure you want to continue? [y/n]" -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
    passwd=$(echo "$passwd" | node-red admin hash-pw | tr ' ' '\n' | tail -n 1 )
    passwd=$(perl -ne 'print quotemeta($_)' <<< $passwd)
    sed -zEi "s/adminAuth: \{\n\s*type: \"credentials\",\n\s*users: \[\{\n\s*username: \".*\",\n\s*password: \".*\",\n\s*permissions: \"\*\"\n\s*}]\n\s*\},/adminAuth: \{\n       type: \"credentials\",\n       users: \[\{\n           username: \"$name\",\n          password: \"$passwd\",\n            permissions: \"\*\"\n       }]\n    \},/" /home/pi/.node-red/settings.js
    read -p "To execute this changes you need to restart node-red. Do you want to restart know? [y/n]" -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        node-red-restart
    fi 
fi


