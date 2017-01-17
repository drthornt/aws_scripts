#!/bin/sh

# aws ec2 --query 'RouteTables[*].[RouteTableId]' describe-route-tables --output text | sort -k 2 | while read subnet cidr
aws ec2 --query 'RouteTables[*].[RouteTableId]' describe-route-tables --output text | sort -k 2 | while read rtb
do

rtbname=`aws ec2 --query 'Tags[*].[Value]' describe-tags --filter "Name=resource-id,Values=${rtb}" "Name=key,Values=Name" --out text`
if [ -z  $rtbname ]
    then
    echo -n "noname "
else
    echo -n ${rtbname} " " 
fi
echo ${rtb}

for i in `aws ec2 --query 'RouteTables[*].Associations[*].[SubnetId]' describe-route-tables --output text --filter "Name=route-table-id,Values=${rtb}"`
 do
    echo -n "     " $i " "
    name=`aws ec2 --query 'Tags[*].[Value]' describe-tags --filter "Name=resource-id,Values=${i}" "Name=key,Values=Name" --out text`
    echo -n ${name} " "
    aws ec2 describe-subnets --query 'Subnets[*].CidrBlock' --filter "Name=subnet-id,Values=${i}" --output text
# aws ec2 --query 'Reservations[*].Instances[*].[State.Name, InstanceId, ImageId, PrivateIpAddress, PublicIpAddress, InstanceType]' describe-instances --output text --filter "Name=subnet-id,Values=${subnet}" "Name=instance-id,Values=${i}"
#    aws ec2 --query 'Volumes[*].[VolumeId,VolumeType,Size,State,Attachments[0].Device]' describe-volumes --filter "Name=attachment.instance-id,Values=${i}" --out text | sort -k 6
 done
done
