#! bin/bash

print() {
  echo -e "\n\e[36m----------------- $1 ----------------------\e[0m\n" >>$LOG
  echo -n -e "$1 \t- "
}

status_check() {
  if [ $1 -eq 0 ]; then 
    echo -e "\t\e[32mSUCCESS\e[0m"
  else 
    echo -e "\t\e[31mFAILURE\e[0m"
    exit 2
  fi 
}

if [ $UID -ne 0 ]; then 
  echo -e "\n\e[1;33mYou should execute this script as root User\e[0m\n"
  exit 1
fi 

LOG=/tmp/roboshop.log 


add_app_user()
{
    id roboshop &>>$LOG
    if [ $? -eq 0 ]; then
    echo "User already exist " &>>$LOG
    else
    useradd roboshop &>>$LOG
    fi
    status_check $? 
}

download_data()
{
    print "Downloading App from Github server"
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
    status_check $?
    # Unzip the Catalogue.zip 
    print "Extracting App Files"
    cd /home/roboshop 
    rm -rf ${COMPONENT}
    unzip -o /tmp/${COMPONENT}.zip &>>$LOG
    status_check $?
    # rename catalogue-main to caralogue directory
    mv ${COMPONENT}-main ${COMPONENT}
}

systemD_setup()
{
    cd /home/roboshop/${COMPONENT}
    # Install the Pacakge
    print "Installing Package "
    npm install --unsafe-perm &>>$LOG
    status_check $?
    # Make changes in systemd.service
    print "change and move service file"
    sed -e "s/${COMPONENT}_ENDPOINT/${COMPONENT}.roboshop.internal/" /home/roboshop/${COMPONENT}/systemd.service &>>$LOG
    status_check $?
    # Move theb file
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service

}

services_reload()
{
    print "Enabling and starting the service" 
    systemctl daemon-reload && systemctl enable ${COMPONENT} && systemctl start ${COMPONENT} &>> $LOG
    status_check $?

}

install_nodejs()
{
    print "Installing Nodejs"
    yum install nodejs make gcc-c++ -y &>>$LOG
    status_check $?
}

install_nginx()
{
    Print "Install Nginx\t\t"
    yum install nginx -y &>>$LOG
    Status_Check $?
}

