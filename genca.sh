#!/bin/bash


# 1.Sign the request OpenVPN-client certificates
# Import
cd ~/easy-rsa
#
read -p "Enter the name of the OpenVPN-client: " name 
#
./easyrsa import-req /tmp/$name.req $name
# Sign
./easyrsa sign-req client $name
# 
read -p "Enter the name of the OpenVPN-client and the IP address of the OpenVPN-server: " name ip
scp pki/issued/$name.crt $ip:/tmp
#
echo "NOTICE
------
Connect back to the OpenVPN-server and copy the client's certificate 
to the ~/client-configs/keys/ directory using the command:
cp /tmp/client1.crt ~/client-configs/keys/"