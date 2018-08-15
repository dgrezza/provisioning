#!/bin/bash

echo "Setting up the engineering blog..."

echo "Provision EC2"
# PROVISON EC2
ansible-playbook -i localhost -e "aws_access_key=${AWS_ACCESS_KEY_ID} aws_secret_key=${AWS_SECRET_ACCESS_KEY} type=wordpress" provision-ec2.yml > /tmp/ipaddress

echo "Setup Host"
# SETUP HOST
IP_ADDRESS=`grep "WORDPRESS_IP" /tmp/ipaddress | awk -F"=" '{print $2}'| tr -d '"'`

echo "[ec2]" > hosts/production
echo "${IP_ADDRESS}" >> hosts/production

echo "Configure with docker"
# CONFIGURE EC2
ansible-playbook -i hosts/production --private-key ~/.ssh/wordpress.pem configure-ec2.yml > /dev/null

echo "Configure Wordpress"
# CONFIGURE WORDPRESS
ansible-playbook -i hosts/production --private-key ~/.ssh/wordpress.pem wordpress-deploy.yml > /dev/null


echo "Done! The blog can be accessed at http://${IP_ADDRESS}/"
