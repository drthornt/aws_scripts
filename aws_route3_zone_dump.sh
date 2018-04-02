#!/bin/sh

for i in `aws route53 list-hosted-zones --query "HostedZones[*].[Id]" --output text`;
    do
    echo $i;
    name=`aws route53 get-hosted-zone --id $i --query "HostedZone[].[Name]" --output text`
    aws route53 list-resource-record-sets --hosted-zone-id $i --output text >> $name.txt
done
