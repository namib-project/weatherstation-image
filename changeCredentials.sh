#!/bin/bash

read -p "New username: " name
while true; do
    read -s -p "New password: " passwd
    echo
    read -s -p "Repeat password: " passwd2
    echo
    [ "$passwd" = "$passwd2" ] && break
    echo "The passwords are not identical. Please try again."
done

read -p "This action changes the administrative access to the Node-RED editor. Are you sure you want to continue? [y/n]" -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
    passwd=$(echo "$passwd" | node-red admin hash-pw | tr ' ' '\n' | tail -n 1 )
    passwd=$(perl -ne 'print quotemeta($_)' <<< $passwd)
    sed -zEi "s/adminAuth: \{\n\s*type: \"credentials\",\n\s*users: \[\{\n\s*username: \".*\",\n\s*password: \".*\",\n\s*permissions: \"\*\"\n\s*}]\n\s*\},/adminAuth: \{\n       type: \"credentials\",\n       users: \[\{\n           username: \"$name\",\n          password: \"$passwd\",\n            permissions: \"\*\"\n       }]\n    \},/" /home/pi/.node-red/settings.js
    read -p "To apply these changes you need to restart Node-RED. Do you want to restart now? [y/n]" -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        node-red-restart
    fi 
fi


