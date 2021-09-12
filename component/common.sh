#! bin/bash

print() {
  echo -e "\n\t\t\e[36m----------------- $1 ----------------------\e[0m\n" >>$LOG
  echo -n -e "$1 \t- "
}

status_check() {
  if [ $1 -eq 0 ]; then 
    echo -e "\t\t\e[32mSUCCESS\e[0m"
  else 
    echo -e "\t\t\e[31mFAILURE\e[0m"
    exit 2
  fi 
}

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
    curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG
    status_check $?
    # Unzip the Catalogue.zip 
    print "Extracting App Files"
    cd /home/roboshop 
    rm -rf catalogue
    unzip -o /tmp/catalogue.zip &>>$LOG
    status_check $?
    # rename catalogue-main to caralogue directory
    mv catalogue-main catalogue
}

systemD_setup()
{
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

}