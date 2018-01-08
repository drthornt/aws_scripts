#!/usr/bin/env python

import boto3
import pprint
import pytz

pp = pprint.PrettyPrinter(indent=4)

ec = boto3.client('ec2')

pagesize = 50

response = ec.describe_instances()

for reservation in (response["Reservations"]):
  print('{} {} {}'.format(reservation['OwnerId'],reservation['ReservationId'],len(reservation['Instances'])))
  # pp.pprint(reservation)

#  for instance in reservation["Instances"]:
#    print ('{} {}'.format(instance['InstanceId'],instance['PrivateIpAddress'])

