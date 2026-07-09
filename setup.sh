#!/bin/bash
set -euo pipefail

echo "Welcome to Vibeongo Server"

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
export CI=1

sudo apt  update -y
sudo apt upgrade -y \
  -o Dpkg::Options::=--force-confdef \
  -o Dpkg::Options::=--force-confold

sudo apt -y update
sudo apt install -y tmux build-essential curl ca-certificates mosh

sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:jgmath2000/et
sudo apt-get -y update
sudo apt-get -y install et

# Add Docker's official GPG key:
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update -y

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker ubuntu

sudo -u ubuntu -H bash <<'EOF'
# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash

# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"

# Download and install Node.js:
nvm install 24

# Verify the Node.js version:
node -v # Should print "v24.16.0".

# Verify npm version:
npm -v # Should print "11.13.0".


# opencode install
curl -fsSL https://opencode.ai/install | bash

# claude code install 
# curl -fsSL https://claude.ai/install.sh | bash
timeout 120 bash -c "$(curl -fsSL https://claude.ai/install.sh)"

# codex
# curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh
npm install -g @openai/codex

# neovim install
sudo apt install -y neovim

# fzf install
sudo apt install -y fzf

# git install
sudo apt install git -y

# gh auth install
sudo apt install gh -y

mkdir -p /home/ubuntu/.config
if [ ! -d /home/ubuntu/.config/opencode/.git ]; then
  sudo rm -rf /home/ubuntu/.config/opencode
  sudo git clone https://github.com/jashandeep31/vibeongo-opencode-config.git /home/ubuntu/.config/opencode
fi

npm i -g t3@nightly

source ~/.bashrc

sudo chown -R ubuntu:ubuntu /home/ubuntu/.config/opencode

mkdir -p /home/ubuntu/code

timeout 60s /home/ubuntu/.opencode/bin/opencode < /dev/null || true

curl -fsSL https://getmoshi.app/install.sh | sh

EOF



rm -rf .ssh/known_hosts
rm -rf .ssh/authorized_keys

sudo apt clean
rm -f ~/.bash_history 
history -c

sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

