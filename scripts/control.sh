#!/bin/bash

sudo apt-get update
curl -sSL "https://bintray.com/user/downloadSubjectPublicKey?username=bintray" | apt-key add - 
echo "deb https://dl.bintray.com/rundeck/rundeck-deb /" | sudo tee -a /etc/apt/sources.list
sudo apt-get -f -y install rundeck
