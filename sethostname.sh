#!/bin/sh
# https://aws.amazon.com/premiumsupport/knowledge-center/linux-static-hostname/
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-hostname.html
# https://www.freedesktop.org/software/systemd/man/hostnamectl.html

# tested on rhel7
# for aws ec2 instances that don't get their hostname set from user-data

if [ -x /etc/sethostname ]; then
  echo found /etc/sethostname exiting
  exit
fi

if [ -e /etc/profile.d/proxy.sh ]; then
        source /etc/profile.d/proxy.sh
fi

# if you are using a proxy then ensure that  you have set NO_PROXY=169.254.169.254 ( link local meta data service ip )
export NO_PROXY=169.254.169.254

export DOMAIN=`dnsdomainname`
echo domain is ${DOMAIN}
if [ ${#SERVER} -lt 1 ] ; then
        echo domain is not set, use resolv.conf, ugly
        DOMAIN=`grep search /etc/resolv.conf | cut -d ' ' -f 2`
        echo got domain ${DOMAIN}
fi

export EC2_AVAIL_ZONE=`/bin/curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
echo EC2_AVAIL_ZONE ${EC2_AVAIL_ZONE}

if [ ${#EC2_AVAIL_ZONE} -lt 1 ]; then
        echo "unable to get EC2_AVAIL_ZONE exiting"
        exit
fi

export EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
echo EC2_REGION ${EC2_REGION}

INSTANCEID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
echo INSTANCEID is ${INSTANCEID}

PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo PRIVATE_IP $PRIVATE_IP

SERVER=""
i=0

while [ \( ${#SERVER} -lt 1 \) ]; do
        i=$[$i+1]
        echo getting server name $i
        /usr/bin/aws ec2 describe-tags --region ${EC2_REGION} --filters "Name=resource-id,Values=${INSTANCEID}" "Name=key,Values=Name" --query 'Tags[*].Value' --output text 2>&1 > /var/log/sethostname.aws
        sleep 1
        TMP=`/usr/bin/aws ec2 describe-tags --region ${EC2_REGION} --filters "Name=resource-id,Values=${INSTANCEID}" "Name=key,Values=Name" --query 'Tags[*].Value' --output text`
        echo TMP is $TMP
        SERVER=${TMP// /-}
        echo SERVER is ${SERVER}
        sleep 1
done

sed -i "s/ localhost / $SERVER /" /etc/hosts

echo ${SERVER}.${DOMAIN} > /etc/hostname

if [ -x /bin/hostnamectl ]; then
        echo hostnamectl before
        time /bin/hostnamectl 2>&1 > /var/log/sethostname.hostnamectl.before
        echo /bin/hostnamectl set-hostname ${SERVER}.${DOMAIN}
        time /bin/hostnamectl set-hostname ${SERVER}.${DOMAIN}
        echo hostnamectl after
        time /bin/hostnamectl 2>&1 > /var/log/sethostname.hostnamectl.after
fi

if [ -e /etc/sysconfig/network ] ; then
        # grep HOSTNAME /etc/sysconfig/network 1>&2 2>/dev/null
        grep HOSTNAME /etc/sysconfig/network
        ERR=$?
        if [ ${ERR} == "0" ] ; then
                echo HOSTNAME is in /etc/sysconfig/network then use sed to edit
                sed -i "s/^\(HOSTNAME\s*=\s*\).*$/\1$SERVER/" /etc/sysconfig/network
        else
                echo HOSTNAME is not in /etc/sysconfig/network, add.
                echo "HOSTNAME=$SERVER" >> /etc/sysconfig/network
        fi
fi

touch /etc/sethostname

