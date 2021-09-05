#! bin/bash
# input with message
read -p "Enter your Name " nm
if [ -z $nm ]; then
exit 1
fi 
echo "welcome   $nm"
