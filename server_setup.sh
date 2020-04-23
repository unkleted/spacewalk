#!/bin/bash
# https://www.itzgeek.com/how-tos/linux/centos-how-tos/step-step-openldap-server-configuration-centos-7-rhel-7.html

#https://www.tecmint.com/install-openldap-server-for-centralized-authentication/

hostnamectl set-hostname "server.jhd.local"

cat >/etc/hosts<<EOF
192.168.56.11	server.jhd.local	server
EOF

# Install Spacewalk Repository
yum update -y
yum install -y yum-plugin-tmprepo
yum install -y spacewalk-repo --tmprepo=https://copr-be.cloud.fedoraproject.org/results/%40spacewalkproject/spacewalk-2.10/epel-7-x86_64/repodata/repomd.xml --nogpg

rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

yum -y install spacewalk-setup-postgresql

yum -y install spacewalk-postgresql 

yum -y install spacewalk-utils spacecmd

yum clean all

spacewalk-setup --answer-file=/tmp/answer.file

chmod u+x /tmp/first_walk.sh
echo "I'm gonna make me a user!!!"
/tmp/first_walk.sh

#administrator&desiredpassword=Passw0rd

/usr/bin/spacewalk-common-channels -u administrator -p Passw0rd -k unlimited -a x86_64 'centos7'
/usr/bin/spacewalk-common-channels -u administrator -p Passw0rd -k unlimited -a x86_64 'centos7-extras'
/usr/bin/spacewalk-common-channels -u administrator -p Passw0rd -k unlimited -a x86_64 'centos7-updates'
/usr/bin/spacewalk-common-channels -u administrator -p Passw0rd -k unlimited -a x86_64 'epel7'

/usr/bin/spacewalk-common-channels -u administrator -p Passw0rd -k unlimited -a x86_64 'centos6'
/usr/bin/spacewalk-common-channels -u administrator -p Passw0rd -k unlimited -a x86_64 'centos6-extras'
/usr/bin/spacewalk-common-channels -u administrator -p Passw0rd -k unlimited -a x86_64 'centos6-updates'
/usr/bin/spacewalk-common-channels -u administrator -p Passw0rd -k unlimited -a x86_64 'epel6'