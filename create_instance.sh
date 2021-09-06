#! bin/bash
# To check the existing running instances
Inst_Name=$1
aws ec2 describe-instances --filters "Name=tag,value=$Inst_Name" | jq .Reservation[].state.Name | grep running &>/dev/null
if [ $? -eq 0 ]; then
echo "Instance $Inst_Name is already running "
exit 0
fi
