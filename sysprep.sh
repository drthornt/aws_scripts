#!/bin/sh

shred -u /etc/ssh/*_key /etc/ssh/*_key.pub

rm -rf /home/*/.*history
rm -rf /root/.bash_history

#rm -rf /var/log/messages
#rm -rf /var/log/lastlog
yum clean all
rm -rf /var/cache/yum
rm -rf /etc/sethostname
rm -rf /etc/machine-id
