#!/bin/sh

# use this script to set a host's hostname in AWS.

# software deps:
# sed
# aws cli
# curl
# hostname
# hostnamectl ( optional )

# files touched
# /etc/hosts
# /etc/sysconfig/network
# /etc/hostname

# network dependancies
# must be able to reach aws api to "describe-tags"
# must have access to local meta data service

# if you are using a proxy then ensure that  you have set NO_PROXY=169.254.169.254 ( link local meta data service ip )
export NO_PROXY=169.254.169.254

# domain is set by dhcp
export DOMAIN=`dnsdomainname`
echo domain is ${DOMAIN}

export EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
export EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"

# SERVER=`/usr/bin/aws ec2 describe-tags --region ${EC2_REGION} --filters "Name=resource-id,Values=$(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id)" "Name=key,Values=Name" --query 'Tags[*].Value' --output text`
SERVER=`/usr/bin/aws ec2 describe-tags --region ${EC2_REGION} --filters "Name=resource-id,Values=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)" "Name=key,Values=Name" --query 'Tags[*].Value' --output text`
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo "$PRIVATE_IP $SERVER" >> /etc/hosts

grep ${SERVER} /etc/hosts
ERR=$?
if [ ${ERR} == "0" ] ; then
        echo the server is in /etc/hosts already , update with sed
        echo sed
        sed -i "s/^\($PRIVATE_IP\).*$/$PRIVATE_IP $SERVER/" /etc/hosts
else
        echo the server is no in /etc/hosts, add.
        echo "$PRIVATE_IP $SERVER" >> /etc/hosts
fi

hostname ${SERVER}.${DOMAIN}

if [ -x /bin/hostnamectl ]; then
        echo /bin/hostnamectl before
        /bin/hostnamectl
        /bin/hostnamectl set-hostname ${SERVER}.${DOMAIN}
        echo /bin/hostnamectl after
        /bin/hostnamectl
fi

if [ -e /etc/sysconfig/network ] ; then
        grep HOSTNAME /etc/sysconfig/network 1>&2 2>/dev/null
        ERR=$?
        if [ ${ERR} == "0" ] ; then
                echo HOSTNAME is in /etc/sysconfig/network then use sed to edit
                sed -i "s/^\(HOSTNAME\s*=\s*\).*$/\1$SERVER/" /etc/sysconfig/network
        else
                echo HOSTNAME is not in /etc/sysconfig/network, add.
                echo "HOSTNAME=$SERVER" # >> /etc/sysconfig/network
        fi
fi

