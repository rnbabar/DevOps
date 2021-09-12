#! bin/bash
source common.sh

# declare a temporary log file
LOG=/tmp/roboshop.log
# Installation of nodejs and its compiler 
install_nodejs
# Roboshop user  
add_app_user
 # Download the zip files of catalogue application from github repository to /tmp/catalogue.zip
download_data
# Systemd service configuration 
systemD_setup
# restarting and enabling the service
services_reload
