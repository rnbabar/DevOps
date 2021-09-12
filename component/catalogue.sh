#! bin/bash

# function to check the status of the command 
function status_check()
{
    if [ $1 -eq 0 ]; then
    echo -e "\n \t \e[35m SUCCESS \e[m0"
    else
    echo -e "\n \t \e[35m FAILURE \e[m0"
    exit 2
    fi
} 

# function to check the status of the command 
function print()
{
    echo -e "\n \t \e[36m -------------------$1------------- \e[m0"
    echo -e -n "$1 \t-"
    
} 

# declare a temporary log file
LOG=/tmp/roboshop.log


# Installation of nodejs and its compiler 
print "Installing Nodejs"
yum install nodejs make gcc-c++ -y &>>$LOG
status_check $?


# Create a roboshop user
id roboshop &>>$LOG
if [ $? -eq 0 ]; then
echo "User already exist " &>>$LOG
else
useradd roboshop &>>$LOG
status_check $?
fi 



# Download the zip files of catalogue application from github repository to /tmp/catalogue.zip
print "Downloading App from Github server"
curl -o -s -L  /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>> $LOG
status_check $?
# Unzip the Catalogue.zip 
print "Extracting App Files"
cd /home/roboshop 
unzip -o /tmp/catalogue.zip &>>$LOG
status_check $?
# rename catalogue-main to caralogue directory
mv catalogue-main catalogue
cd /home/roboshop/catalogue

# Install the Pacakge
print "Installing Package "
nmp install --unsafe-perm &>> &LOG
status_check $?

# Make changes in systemd.service
print "change and move service file"
sed -e "s/127.0.0.1/0.0.0.0/" /home/roboshop/catalogue/systemd.service &>>$LOG
status_check $?
# Move theb file
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service

# restarting and enabling the service
print "Enabling and starting the service" 
systemctl daemon-reload 
systemctl enable catalogue
systemctl start catalogue &>> $LOG
