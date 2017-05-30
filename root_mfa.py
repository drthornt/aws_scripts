#!/usr/bin/rnv python
#refrence: https://stackoverflow.com/questions/29339566/how-to-check-whether-mfa-is-enabled-for-root-account-in-aws-using-boto

import boto.iam
import pprint

pp = pprint.PrettyPrinter(indent=4)

conn = boto.iam.connect_to_region('us-east-1')
summary = conn.get_account_summary()

print "SUMMARY"
pp.pprint(summary)

# This returns a Python dictionary containing a lot of information about your account. Specifically, to find out if MFA is enabled;

if summary['AccountMFAEnabled']:
    print "MFA is enabled"
else:
    print "MFA is not enabled"
