#!/bin/sh -eux

OS_NAME=$(uname -s)
if [ -f /etc/os-release ]; then
  OS_ID=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
fi

if [ -d /etc/sudoers.d ]; then
  echo 'Defaults:%sudo env_keep += "PACKER_*"' >> /etc/sudoers.d/_packer_env
fi

echo "installing updates"
if [ -f "/usr/bin/apt-get" ]; then
  echo "disable systemd apt timers/services"
  systemctl stop apt-daily.timer
  systemctl stop apt-daily-upgrade.timer
  systemctl disable apt-daily.timer
  systemctl disable apt-daily-upgrade.timer
  systemctl mask apt-daily.service
  systemctl mask apt-daily-upgrade.service
  systemctl daemon-reload
  # Disable periodic activities of apt to be safe
  cat <<EOF >/etc/apt/apt.conf.d/10periodic
APT::Periodic::Enable "0";
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "0";
EOF
  if [ "$OS_ID" = "ubuntu" ]; then
    echo "Detected Ubuntu"
    export DEBIAN_FRONTEND=noninteractive

    echo "disable release-upgrades"
    sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades

    echo "remove the unattended-upgrades and ubuntu-release-upgrader-core packages"
    rm -rf /var/log/unattended-upgrades;
    apt-get -y purge unattended-upgrades ubuntu-release-upgrader-core;

    echo "update the package list"
    apt-get -y update;

    echo "upgrade all installed packages incl. kernel and kernel headers"
    apt-get -y dist-upgrade -o Dpkg::Options::="--force-confnew";
  else
    echo "Unsupported OS: $OS_ID"
    exit 1
  fi
else
  echo "Unsupported OS: $OS_NAME"
  exit 1
fi

echo "updates installed rebooting"
shutdown -r now
sleep 60