#!/bin/bash
set -euxo pipefail

LOG=/var/log/dev-classic-userdata.log
exec > >(tee -a $LOG) 2>&1

REGION="${region}"

echo "===== USERDATA START | REGION: $REGION ====="

sleep 20

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

# -------------------------
# DOCKER INSTALL (UPDATED)
# -------------------------
install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg

chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

docker --version
docker compose version
# -------------------------
# DOCKER INSTALL END
# -------------------------

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

sudo apt install awscli -y

echo "===== USERDATA COMPLETED SUCCESSFULLY ====="
