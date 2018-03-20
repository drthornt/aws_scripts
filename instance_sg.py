#!/usr/bin/env python

import boto3
import pprint
import pytz

pp = pprint.PrettyPrinter(indent=4)

ec = boto3.client('ec2')

pagesize = 50

response = ec.describe_instances()

# loop over all vpcs nad listinstance by vpc.

sglist = dict()

for reservation in (response["Reservations"]):
  for instance in reservation["Instances"]:

    # pp.pprint( instance )

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

    try:
      instance['SecurityGroups']
    except KeyError:
      SecurityGroups = "None"
    else:
      SecurityGroups = instance['SecurityGroups']

    tags = instance['Tags']
    for tag in tags:
      if tag['Key'] == 'Name':
        name = tag['Value']

    # print ('{} {} {} {}'.format(name, InstanceId,PrivateIpAddress,PublicIpAddress))
    for sg in SecurityGroups:
      # pp.pprint( sg )
      try:
        hostlist  = sglist[sg['GroupName']]
        hostlist.append(name)
      except KeyError:
        sglist[sg['GroupName']] = [name]

print "SG list is "

pp.pprint( sglist )
        



