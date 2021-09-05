#! bin/bash
# input with message
read -p "Enter your Name " nm
if [ -z $nm ]; then

echo " You Did not entered your name"
exit 1
else
echo "Welcome    $nm "

fi 

