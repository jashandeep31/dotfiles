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

sudo apt install -y tmux

sudo apt install -y build-essential
# Add Docker's official GPG key:
sudo apt install -y ca-certificates curl
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
curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh

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


source ~/.bashrc

sudo chown -R ubuntu:ubuntu /home/ubuntu/.config/opencode

mkdir -p /home/ubuntu/code

timeout 60s /home/ubuntu/.opencode/bin/opencode < /dev/null || true

EOF

rm -rf .ssh/known_hosts
rm -rf .ssh/authorized_keys

sudo apt clean
rm -f ~/.bash_history 
history -c
# Prevent this session from writing history on logout
unset HISTFILE

sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

# run as at end 
#
# opencode 
# rm -f ~/.bash_history 
# history -c
# unset HISTFILE
# rm -rf .ssh/known_hosts
# rm -rf .ssh/authorized_keys
# sudo cloud-init clean
# sudo rm -rf /tmp/*
# sudo rm -rf /var/tmp/*
#
# sudo apt clean
#
#
#
#
# 
# APP="vibeongo"
# BINARY_PATH="/usr/local/bin/$APP"
#
# echo "Installing $APP..."
#
# # Download binary
# sudo curl -f# -L https://download.vibeongo.com/vibeongo -o "$BINARY_PATH"
#
# # Make executable
#
# sudo chown ubuntu:ubuntu "$BINARY_PATH"   # ubuntu can overwrite it
# sudo chmod +x "$BINARY_PATH"
#
# sudo tee /etc/systemd/system/vibeongo.service > /dev/null <<'SERVICE_EOF'
# [Unit]
# Description=Vibeongo Service
# After=network.target
#
# [Service]
# Type=simple
# User=ubuntu
# Environment="HOME=/home/ubuntu"
# ExecStart=/usr/local/bin/vibeongo serve
# Restart=always
# RestartSec=3
#
# Environment=TERM=xterm-256color
# Environment=COLORTERM=truecolor
# Environment=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin
#
# [Install]
# WantedBy=multi-user.target
# SERVICE_EOF
#
