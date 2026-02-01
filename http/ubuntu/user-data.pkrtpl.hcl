#cloud-config
autoinstall:
  identity:
    username: ${default_user_name}
    password: '${default_user_password}'
    hostname: 'ubuntu-server-template'
  storage:
    layout:
      name: direct
  version: 1
  locale: de_DE
  keyboard:
    layout: de
  packages:
    - openssh-server
    - qemu-guest-agent
  early-commands:
    # otherwise packer tries to connect and exceed max attempts:
    - systemctl stop ssh
  ssh:
    install-server: yes
    allow-pw: false
    authorized-keys:
      - ${default_user_sshkey}
  late-commands:
    - |
      if [ -f /target/etc/netplan/00-installer-config.yaml ]; then
        'sed -i "s/dhcp4: true/&\n      dhcp-identifier: mac/" /target/etc/netplan/00-installer-config.yaml'
      fi
  user-data:
     users:
       - name: ansible
         gecos: 'Ansible User'
         groups: users,admin,wheel,lxd
         shell: /bin/bash
         lock_passwd: True
         sudo: "ALL=(ALL) NOPASSWD:ALL"
         ssh_authorized_keys:
          - ${default_user_sshkey}
