#!/bin/bash

#hostnamectl set-hostname "client.jhd.local"

cat >/etc/hosts<<EOF
192.168.56.11	server.jhd.local	server
EOF

ver=$(rpm --eval '%{centos_ver}')

if [[ $ver -eq 6 ]]; then
	yum install -y yum-plugin-tmprepo
	yum install -y spacewalk-client-repo --tmprepo=https://copr-be.cloud.fedoraproject.org/results/%40spacewalkproject/spacewalk-2.10-client/epel-6-x86_64/repodata/repomd.xml --nogpg
	rpm -Uvh http://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
	key="1-centos6-x86_64"
elif [[ $ver -eq 7 ]]; then
	yum install -y yum-plugin-tmprepo
	yum install -y spacewalk-client-repo --tmprepo=https://copr-be.cloud.fedoraproject.org/results/%40spacewalkproject/spacewalk-2.10-client/epel-7-x86_64/repodata/repomd.xml --nogpg
	rpm -Uvh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	key="1-centos7-x86_64"
else
	echo "What have you done?"
fi

yum -y install rhn-client-tools rhn-check rhn-setup rhnsd m2crypto yum-rhn-plugin

rpm -Uvh http://server.jhd.local/pub/rhn-org-trusted-ssl-cert-1.0-1.noarch.rpm

rhnreg_ks --serverUrl=https://server.jhd.local/XMLRPC --sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT --activationkey=$key

yum -y install osad
sed -i 's|osa_ssl_cert =|osa_ssl_cert = /usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT|g' /etc/sysconfig/rhn/osad.conf

service osad start