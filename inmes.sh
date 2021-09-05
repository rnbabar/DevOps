#! bin/bash
# input with message
read -p "Enter your Name " nm
if [ -z $nm ]; then
exit 1
else
echo " You Did not entered your name"
fi 
echo "welcome   $nm"
