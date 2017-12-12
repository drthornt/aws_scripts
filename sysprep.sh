#!/bin/sh

# do this to an aws instance before you down it to become an ami.

shred -u /etc/ssh/*_key /etc/ssh/*_key.pub

rm -rf /home/*/.*history
rm -rf /root/.bash_history

rm -rf /var/log/messages
rm -rf /var/log/lastlog
yum clean all
rm -rf /var/cache/yum
rm -rf /etc/sethostname
rm -rf /etc/hostname

# It can be temping to remove /etc/machine-id but this can be problematic as 
# the AWS provided RHEL instance doesn't have "--setup-machine-id --root=/" 
# in it's firstboot service, which means that /etc/machine-id _never_ gets 
# created. This is bad and among other things, journald will fail.

