#!/usr/bin/env python

import boto3
import pprint
import pytz

pp = pprint.PrettyPrinter(indent=4)

ec = boto3.client('ec2')

pagesize = 50

response = ec.describe_instances()

# loop over all vpcs nad listinstance by vpc.

for reservation in (response["Reservations"]):
  for instance in reservation["Instances"]:

    try:
      instance['InstanceId']
    except KeyError:
      InstanceId = "None"
    else:
      InstanceId = instance['InstanceId']

    try:
      instance['PrivateIpAddress']
    except KeyError:
      PrivateIpAddress = "None"
    else:
      PrivateIpAddress = instance['PrivateIpAddress']

    try:
      instance['PublicIpAddress']
    except KeyError:
      PublicIpAddress = "None"
    else:
      PublicIpAddress = instance['PublicIpAddress']

    tags = instance['Tags']
    for tag in tags:
      if tag['Key'] == 'Name':
        name = tag['Value']

    print ('{} {} {} {}'.format(name, InstanceId,PrivateIpAddress,PublicIpAddress))

