#!/bin/sh


#access-key.gpg
#secret-key.gpg


for i in `ls -1 ~/.password-store`
do
echo -n $i 
#echo ~/.password-store/${i}/access-key.gpg
#ls -la ~/.password-store/${i}/access-key.gpg
if [ -e ~/.password-store/${i}/access-key.gpg -a -e ~/.password-store/${i}/secret-key.gpg ]
then
  # echo " is aws"
  export TF_VAR_aws_access_key="$(pass ${i}/access-key)"
  export i=${i}
  export AWS_ACCESS_KEY_ID="$(pass ${i}/access-key)"
  export AWS_SECRET_ACCESS_KEY="$(pass ${i}/secret-key)"
  echo -n " "
  ./root_mfa.py
  
#else
  # echo " is NOT aws"
  # ls -la ~/.password-store/${i}/
fi
done
