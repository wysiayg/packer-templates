Inspired by https://github.com/chef/bento/tree/main

Ensure all packer plugins are installed `packer init .`

Add your ssh key to the ssh-agent and set variable `ssh_pub_key` to the pub key.
This configuration uses the ssh-agent as the connection method.

Build:

`packer build -var-file os_pkrvars/ubuntu-24.04.pkrvars.hcl .`
