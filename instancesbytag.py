#!/usr/bin/env python

import boto3
import pprint
import pytz

pp = pprint.PrettyPrinter(indent=4)

ec = boto3.client('ec2')

pagesize = 50

response = ec.describe_instances(Filters=[{'Name': 'tag:powerschedule','Values': ['ninetofive']}])

for reservation in (response["Reservations"]):
  for instance in reservation["Instances"]:
    tags = instance['Tags']
    for tag in tags:
      if tag['Key'] == 'Name':
        print tag['Value']

