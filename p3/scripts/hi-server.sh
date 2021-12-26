#!/bin/bash

# ip address of server
server_ip=XX.XX.XXX.XXX # change it to the machine ip you will use for deployments
username="allali"       # change it to the machine user's name you will use for deployments

# copy public ssh key to the server so we dont need to enter password each time
ssh-copy-id -i ~/.ssh/id_rsa.pub $username@${server_ip}
ssh-keyscan -t rsa ${server_ip} > ~/.ssh/known_hosts

# move the needed project files for this task
scp -r scripts $username@${server_ip}:/home/$username/
scp -r confs $username@${server_ip}:/home/$username