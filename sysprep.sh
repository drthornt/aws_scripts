#!/bin/sh
# do this to an aws instance before you down it to become an ami.
# references:
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/building-shared-amis.html

/bin/shred -u /etc/ssh/*_key /etc/ssh/*_key.pub
/bin/shred -u /home/*/.*history
/bin/shred -u /root/.bash_history
for i in messages wtmp btmp secure cron dmesg dmesg.old
do
/bin/shred -u /var/log/${i}
done
yum clean all
rm -rf /var/cache/yum
rm -rf /etc/hostname
history -c
