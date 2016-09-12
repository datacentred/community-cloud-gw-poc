#!/bin/bash

curl -sSL "https://bintray.com/user/downloadSubjectPublicKey?username=bintray" | apt-key add - 
echo "deb https://dl.bintray.com/rundeck/rundeck-deb /" | sudo tee -a /etc/apt/sources.list
sudo apt-get update
sudo apt-get -f -y install openjdk-8-jre-headless
sudo apt-get -f -y install rundeck
sleep 5
sudo /etc/init.d/rundeckd start
sleep 30
sudo rd-project -a create -p sgw

