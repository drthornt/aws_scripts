#!/bin/sh

for i in `cat accountlist | grep -v ^#`
do
echo -n $i " "
# ls -la ~/.password-store/${i}/access-key.gpg ~/.password-store/${i}/secret-key.gpg
if [ -e ~/.password-store/${i}/access-key.gpg -a -e ~/.password-store/${i}/secret-key.gpg ]
then
  echo " is in aws"
  export TF_VAR_aws_access_key="$(pass ${i}/access-key)"
  export i=${i}
  export AWS_ACCESS_KEY_ID="$(pass ${i}/access-key)"
  export AWS_SECRET_ACCESS_KEY="$(pass ${i}/secret-key)"
  $1
  
else
  echo " is NOT in aws"
  # ls -la ~/.password-store/${i}/
fi
done
