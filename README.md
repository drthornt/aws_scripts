Various scripts to do stuff in aws.


check_all_accounts.sh
  looks in your gpg password store, each dir is a client account alias, loops over those setting env as needed, skipping Aazure accounts
  runs root_mfa.py as an example of script you might want to run on all all accounts.
instances_by_subnet_and_disk.sh
README.md
root_mfa.py
  check to see if an account has rootmfa enabled. this is a brest practice and we _should_ be doin this for all scalar root managed accounts.
  We can't do anyhting about clent's who manage their own root account.
routetables_subnets.sh
sethostname.sh
  a script you can run on an AWS instance as it comes up to set it's name to it's AWS "Name" tag. Read script for prereqs.
sg_by_instance.sh

sysprep.sh
  a linux version of windows "sysprep.exe" to "clean" an instance, making it ready to be turned into an ami.
