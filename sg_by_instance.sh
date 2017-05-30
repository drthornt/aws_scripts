#!/bin/sh

aws ec2 --query 'Subnets[*].[SubnetId, CidrBlock]' describe-subnets --output text | sort -k 2 | while read subnet cidr
do
echo Subnet ${subnet} ${cidr}
for i in `aws ec2 --query 'Reservations[*].Instances[*].[InstanceId]' describe-instances --output text --filter "Name=subnet-id,Values=${subnet}"`
 do
 name=`aws ec2 --query 'Tags[*].[Value]' describe-tags --filter "Name=resource-id,Values=${i}" "Name=key,Values=Name" --out text`
 echo -n ${name} " "
 aws ec2 describe-instances --filter "Name=instance-id,Values=${i}" --query 'Reservations[*].Instances[*].SecurityGroups[*].[GroupName,GroupId]' --out text


 done
done
