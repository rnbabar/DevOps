#! bin/bash
source common.sh
COMPONENT="frontend"
#install nginx
install_nginx
# Download applocation package 
print "Downloading Package"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>> $LOG
status_check $?
# Copy the application to default in nginx
Print "Extract Frontend Archive"
rm -rf /usr/share/nginx/* && cd /usr/share/nginx && unzip -o /tmp/frontend.zip  &>>$LOG  && mv frontend-main/* .  &>>$LOG  &&   mv static html  &>>$LOG
status_check $?
# copy the localhost.conf to roboshop.conf
Print "Copy Nginx RoboShop Config"
mv localhost.conf /etc/nginx/default.d/roboshop.conf  &>>$LOG
Status_Check $?
# Setup the roboshop.cof
sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/user/ s/localhost/user.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/' -e '/shipping/ s/localhost/shipping.roboshop.internal/' -e '/payment/ s/localhost/payment.roboshop.internal/' /etc/nginx/default.d/roboshop.conf  &>>$LOG
status_check $?
# Restart the NGINX service
Print "Restart Nginx\t\t"
systemctl restart nginx  &>>$LOG  && systemctl enable nginx   &>>$LOG
Status_Check $?