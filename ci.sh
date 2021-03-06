#! bin/bash
Inst_Name=$1
TMPLID="lt-049de486aa5979b15"
TMPLVER=3

if [ -z "${Inst_Name}" ]; then

    echo -e "You did not provided the Instance Name "
    exit 1

fi
#Check weather instance exist or not 
aws ec2 describe-instances --filters "Tags=Name,Name,value:$Inst_Name" | jq .Reservations[].Instances[].State.Name | grep running &>/dev/null 
if [$? -eq 0 ]; then
    echo -e "Instance $Inst_Nmae is already running "
    exit 0
fi

 # 
#aws ec2 run-instances --Launch-Template launchTemplateId=$TMPLID, version=$TMPLVER 
# To check the existing running instances
#aws ec2 describe-instances --filters "Name=tag:Name,values=$Inst_Name" | jq .Reservation[].Instances[].state.Name | grep running &>/dev/null
#if [ $? -eq 0 ]; then
#echo "Instance $Inst_Name is already running "
#exit 0
#fi
