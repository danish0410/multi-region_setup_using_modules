#!/bin/bash
set -e

LOG=/var/log/dev-classic-userdata.log
exec > >(tee -a $LOG) 2>&1

REGION="${region}"

echo "===== USERDATA START | REGION: $REGION ====="

# Base packages
apt-get update -y
apt-get install -y \
  software-properties-common \
  apt-transport-https \
  ca-certificates \
  curl \
  git \
  gnupg \
  lsb-release

# Install Ansible
add-apt-repository --yes --update ppa:ansible/ansible
apt-get install -y ansible
ansible --version

# Clone CREATE-USER repo (external)
git clone git@github.com:danish0410/create-user.git /opt/create-user || \
git clone https://github.com/danish0410/create-user.git /opt/create-user

# Export region for Ansible
export AWS_REGION="$REGION"

# Run Ansible
cd /opt/create-user/ansible
ansible-playbook create-user.yml

echo "===== USERDATA COMPLETED SUCCESSFULLY ====="
