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
IP=$(aws ec2 run-instances --launch-template LaunchTemplateId=$TMPLID,Version=$TMPLVER --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=$Inst_Name}]" "ResourceType=instance,Tags=[{Key=Name,Value=$Inst_Name}]" | jq .Instances[].PrivateIpAddress | sed -e 's/"//g')

sed -e "s/INSTANCE_NAME/$Inst_Name/" -e "s/INSTANCE_IP/$IP/" record.json > /tmp/record.json
aws route53 change-resource-record-sets --hosted-zone-id Z07609641Q3E9LE2WV2TF --change-batch file:///tmp/record.json | jq


