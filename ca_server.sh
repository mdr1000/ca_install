#!/bin/bash


WORK_FOLDER=/home/damir/easy-rsa/


# 1. Update the machine and install easy-rsa
sudo apt-get update
yes | sudo apt-get install easy-rsa


# 2. Preparing the public key infrastructure
mkdir -p $WORK_FOLDER
chmod 700 $WORK_FOLDER

ln -s /usr/share/easy-rsa/* $WORK_FOLDER

cd $WORK_FOLDER
./easyrsa init-pki


# 3. Creation of a CA
cat <<EOF> $WORK_FOLDER/vars
set_var EASYRSA_REQ_COUNTRY    "RUS"
set_var EASYRSA_REQ_PROVINCE   "Bashkortostan"
set_var EASYRSA_REQ_CITY       "Ufa City"
set_var EASYRSA_REQ_ORG        "Company"
set_var EASYRSA_REQ_EMAIL      "admin@company.ru"
set_var EASYRSA_REQ_OU         "LLC"
set_var EASYRSA_ALGO           "ec"
set_var EASYRSA_DIGEST         "sha512"
EOF

cd $WORK_FOLDER
./easyrsa build-ca nopass


# 4. We provide information for further actions
echo "Notice
------"

echo "Now you have two important files:
1) /home/damir/easy-rsa/pki/ca.crt and
2) /home/damir/easy-rsa/pki/private/ca.key
- an open and closed component of the certificate authority."

echo "
Well done! Your CA will be ready.
"


# 5. Signature of the certificate request
cd /home/damir/easy-rsa
./easyrsa import-req /tmp/server.req server
./easyrsa sign-req server server


# 6. Distribution of an open CA certificate
echo "NOTICE
------"

echo "Import the CA's public certificate to your second system using the command: "
read -p "Write the IP address of the OpenVPN-server machine: " ip1
scp /home/damir/easy-rsa/pki/issued/server.crt $ip1:/tmp
scp /home/damir/easy-rsa/pki/ca.crt $ip1:/tmp

echo "Now go back to your OpenVPN server, copy the files from /tmp to /etc/openvpn/server using the command:
sudo cp /tmp/{server.crt,ca.crt} /etc/openvpn/server
------"