#!/bin/sh
# https://aws.amazon.com/premiumsupport/knowledge-center/linux-static-hostname/
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-hostname.html
# https://www.freedesktop.org/software/systemd/man/hostnamectl.html

# required:
#  curl
#  aws cli
#  hostnamectl

# put me in /etc/rc.local

if [ -e /etc/profile.d/proxy.sh ]; then
        source /etc/profile.d/proxy.sh
fi

# if you are using a proxy then ensure that  you have set NO_PROXY=169.254.169.254 ( link local meta data service ip )
export NO_PROXY=169.254.169.254

export DOMAIN=`dnsdomainname`
echo domain is ${DOMAIN}
if [ ${#DOMAIN} -lt 1 ] ; then
        echo domain is not set, use resolv.conf, ugly
        DOMAIN=`grep search /etc/resolv.conf | cut -d ' ' -f 2`
        echo got domain ${DOMAIN}
fi

export EC2_AVAIL_ZONE=`/bin/curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
if [ ${#EC2_AVAIL_ZONE} -lt 1 ]; then
        echo "unable to get EC2_AVAIL_ZONE, exiting"
        exit
fi
echo EC2_AVAIL_ZONE ${EC2_AVAIL_ZONE}

# if EC2_AVAIL_ZONE worked these will probably work.
export EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
echo EC2_REGION ${EC2_REGION}
export INSTANCEID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
echo INSTANCEID is ${INSTANCEID}
export PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo PRIVATE_IP $PRIVATE_IP

# aws cli might not work the first time round, wait asecond and try again, if fact, try forever!

SERVER=""
while [ \( ${#SERVER} -lt 1 \) ]; do
        echo getting server name $i
        TMP=`/usr/bin/aws ec2 describe-tags --region ${EC2_REGION} --filters "Name=resource-id,Values=${INSTANCEID}" "Name=key,Values=Name" --query 'Tags[*].Value' --output text`
        export SERVER=${TMP// /-}
        sleep 1
done

if [ -x /bin/hostnamectl ]; then
        echo /bin/hostnamectl set-hostname ${SERVER}.${DOMAIN}
        /bin/hostnamectl --static --transient set-hostname ${SERVER}.${DOMAIN}
else
        echo no executable /bin/hostnamectl nothing changed.
fi

