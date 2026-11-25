#!/bin/bash
# 1. Update system package index and upgrade packages safely
apt-get update -y
export DEBIAN_FRONTEND=noninteractive
apt-get upgrade -y

# 2. Install pre-requisites for Docker container runtime
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# 3. Install Docker
apt-get install -y docker.io

# 4. Start and enable Docker engine service
systemctl start docker
systemctl enable docker
