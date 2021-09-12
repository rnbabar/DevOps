#! bin/bash
source common.sh

# declare a temporary log file
LOG=/tmp/roboshop.log


# Installation of nodejs and its compiler 
print "Installing Nodejs"
yum install nodejs make gcc-c++ -y &>>$LOG
status_check $?

add_app_user
# Create a roboshop user
#id roboshop &>>$LOG
#if [ $? -eq 0 ]; then
#echo "User already exist " &>>$LOG
#else
#useradd roboshop &>>$LOG
#status_check $?
#fi 



# Download the zip files of catalogue application from github repository to /tmp/catalogue.zip
download_data

cd /home/roboshop/catalogue

# Install the Pacakge
print "Installing Package "
npm install --unsafe-perm &>>$LOG
status_check $?

# Make changes in systemd.service
print "change and move service file"
sed -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>$LOG
status_check $?
# Move theb file
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service

# restarting and enabling the service
print "Enabling and starting the service" 
systemctl daemon-reload && systemctl enable catalogue && systemctl start catalogue &>> $LOG
status_check $?
