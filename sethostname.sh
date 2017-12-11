#!/bin/sh
# https://aws.amazon.com/premiumsupport/knowledge-center/linux-static-hostname/
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-hostname.html
# https://www.freedesktop.org/software/systemd/man/hostnamectl.html

if [ -x /etc/sethostname ]; then
  echo found /etc/sethostname exiting
  exit
fi

echo setting hostname in sethostname.sh
SLEEP=10
echo sleep $SLEEP
sleep $SLEEP

# if you are using a proxy then ensure that  you have set NO_PROXY=169.254.169.254 ( link local meta data service ip )
export NO_PROXY=169.254.169.254

# domain is set by dhcp
export DOMAIN=`dnsdomainname`
echo domain is ${DOMAIN}

echo raw curl
/bin/curl -v http://169.254.169.254/latest/meta-data/placement/availability-zone
echo

export EC2_AVAIL_ZONE=`/bin/curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
echo EC2_AVAIL_ZONE ${EC2_AVAIL_ZONE}

if [ ${#EC2_AVAIL_ZONE} -lt 1 ]; then
        echo "unable to get EC2_AVAIL_ZONE exiting"
        exit
fi

export EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
echo EC2_REGION ${EC2_REGION}

SERVER=`/usr/bin/aws ec2 describe-tags --region ${EC2_REGION} --filters "Name=resource-id,Values=$(wget -q -O --no-proxy - http://169.254.169.254/latest/meta-data/instance-id)" "Name=key,Values=Name" --query 'Tags[*].Value' --output text`
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

if ${#SERVER} -lt 1 ]; then
        echo unable to get server name from Tag, exiting
        exit
fi

echo "$PRIVATE_IP $SERVER" >> /etc/hosts

grep -v ${PRIVATE_IP} /etc/hosts > /tmp/tmp.host
echo "$PRIVATE_IP $SERVER" >> /etc/hosts
cp -f /tmp/tmp.host /etc/hosts

sed -i "s/ localhost / $SERVER /" /etc/hosts

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

touch /etc/sethostname


