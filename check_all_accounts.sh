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
  echo " is aws"
else
  echo " is NOT aws"
  ls -la ~/.password-store/${i}/
fi
done
