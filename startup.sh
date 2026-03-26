#!/bin/bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y ufw fail2ban unattended-upgrades lynis

# SSH hardening
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#\?X11Forwarding.*/X11Forwarding no/' /etc/ssh/sshd_config
systemctl restart ssh || systemctl restart sshd

# Kernel/network hardening
cat >/etc/sysctl.d/99-lab1-hardening.conf <<'EOF'
net.ipv4.ip_forward = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.tcp_syncookies = 1
EOF
sysctl --system

# File permission hardening
chmod 640 /etc/shadow /etc/gshadow

# Basic host firewall
ufw default deny incoming
ufw default allow outgoing
ufw allow OpenSSH
ufw --force enable

# Automatic security updates
dpkg-reconfigure -f noninteractive unattended-upgrades

echo "Startup script completed at $(date -Iseconds)" > /var/log/startup-complete.log
