# Create the user
adduser --disabled-password --gecos "" ubuntu

# Add to sudo group
usermod -aG sudo ubuntu

# Passwordless sudo (to match AWS's default ubuntu behavior)
echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-ubuntu-user
chmod 440 /etc/sudoers.d/90-ubuntu-user

# Copy root's authorized_keys over so ubuntu can SSH in the same way
mkdir -p /home/ubuntu/.ssh
cp /root/.ssh/authorized_keys /home/ubuntu/.ssh/authorized_keys
chown -R ubuntu:ubuntu /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh
chmod 600 /home/ubuntu/.ssh/authorized_keys
