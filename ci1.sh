#! bin/bash
Inst_Name=$1
TMPLID="lt-049de486aa5979b15"
TMPLVER=3

if [ -z "${Inst_Name}" ]; then

    echo -e "You did not provided the Instance Name "
    exit 1

fi
#Check weather instance exist or not
aws ec2 describe-instances --filters "Name=tag:Name,Values=$Inst_Name" | jq .Reservations[].Instances[].State.Name | grep running &>/dev/null 
if [ $? -eq 0 ]; then
    echo -e "Instance $Inst_Nmae is already running "
    exit 0
fi
#Check weather instance Stopped or not 
aws ec2 describe-instances --filters "Name=tag:Name,Values=$Inst_Name" | jq .Reservations[].Instances[].State.Name | grep stopped &>/dev/null 
if [ $? -eq 0 ]; then
    echo -e "Instance $Inst_Nmae is already running "
    exit 0
fi
#  Create a instance from Template ID 
aws ec2 run-instances --launch-template LaunchTemplateId=$TMPLID,version=$TMPLVER   


