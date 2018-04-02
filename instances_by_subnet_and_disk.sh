#!/bin/sh

aws ec2 --query 'Subnets[*].[SubnetId, CidrBlock ,Tags[?Key==`Name`].Value | [0] ]' describe-subnets --output text | sort -k 2 | while read subnet cidr name
do
echo Subnet ${subnet} ${cidr} ${name}
for i in `aws ec2 --query 'Reservations[*].Instances[*].[InstanceId]' describe-instances --output text --filter "Name=subnet-id,Values=${subnet}"`
 do
 name=`aws ec2 --query 'Tags[*].[Value]' describe-tags --filter "Name=resource-id,Values=${i}" "Name=key,Values=Name" --out text`
 echo -n ${name} " "
 aws ec2 --query 'Reservations[*].Instances[*].[State.Name, InstanceId, ImageId, PrivateIpAddress, PublicIpAddress, InstanceType]' describe-instances --output text --filter "Name=subnet-id,Values=${subnet}" "Name=instance-id,Values=${i}"
    aws ec2 --query 'Volumes[*].[VolumeId,VolumeType,Size,State,Attachments[0].Device]' describe-volumes --filter "Name=attachment.instance-id,Values=${i}" --out text | sort -k 6
 done
done
