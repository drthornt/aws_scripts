#!/usr/bin/env python
# reference: https://stackoverflow.com/questions/29339566/how-to-check-whether-mfa-is-enabled-for-root-account-in-aws-using-boto

import boto.iam
import boto3
import pprint

pp = pprint.PrettyPrinter(indent=4)

conn = boto.iam.connect_to_region('us-east-1')

client = boto3.client('iam')

summary = conn.get_account_summary()

acc_alias = client.list_account_aliases()

listofaliases = acc_alias['AccountAliases'] 

for alias in  listofaliases:
 print alias

if summary['AccountMFAEnabled']:
    print "MFA is enabled"
else:
    print "MFA is not enabled"

