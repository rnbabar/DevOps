#! bin/bash
source common.sh

# declare a temporary log file
LOG=/tmp/roboshop.log

# Installation of nodejs and its compiler 
print "Installing Nodejs"
yum install nodejs make gcc-c++ -y &>>$LOG
status_check $?

add_app_user
 



# Download the zip files of catalogue application from github repository to /tmp/catalogue.zip
download_data
systemD_setup


# restarting and enabling the service
services_reload
