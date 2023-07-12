#!/bin/bash

# clean the inventory file
echo "" > inventory
# Extract values from JSON output
bastion_ip=$(terraform output -json | jq -r '.bastion_ip.value')
vm1_ip=$(terraform output -json | jq -r '.vm1_ip.value')

# inventory for bastion host
bastion="bastion_host ansible_host={bastion_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/ansible"

# Replace placeholders in the script
bastion=$(echo "$bastion" | sed "s/{bastion_ip}/$bastion_ip/g")

echo "[bastion]" >> inventory
echo $bastion >> inventory

# inventory for private 1
vm1="private_host ansible_host={vm1_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/ansible ansible_ssh_common_args='-o ProxyJump=ec2-user@{bastion_ip}'"

# replace bastion_ip and vm1 ip
vm1=$(echo "$vm1" | sed "s/{bastion_ip}/$bastion_ip/g")
vm1=$(echo "$vm1" | sed "s/{vm1_ip}/$vm1_ip/g")
echo "[private]" >> inventory
echo $vm1 >> inventory









