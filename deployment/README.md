# Automated Deployment Samples
This repo contains sample ansible playbooks and scripts for the deployment of Prisma Cloud Compute.
These playbooks are intended to help with your understanding in the Infrastructure as Code deployment of Prisma Cloud Compute.
Use of these deployment examples does not imply any rights to Palo Alto Networks products and/or services.

## Ansible
### Deploy Console and Defenders within a Kubernetes cluster
The [ansible/console-defender-cluster.yaml](ansible/console-defender-cluster.yaml) Ansible playbook demonstrates the deployment of both the Console and Defenders within a Kubernetes cluster.

### Deploy Defenders from an existing Console
The [ansible/linux-host-defender.yaml](ansible/linux-host-defender.yaml) Ansible playbook demonstrates the deployment of host Defenders from an existing Console using a shell script.

## Shell
### Deploy Defenders on instance creation
The [shell/linux-host-defender.sh](shell/linux-host-defender.sh) script demonstrates how to deploy a host Defender. When used as an instance startup script, you can ensure that a host Defender is installed on each newly-created instance automatically via the user data field.

### Deploy Windows Defenders
The [shell/windows-host-defender.ps1](shell/windows-host-defender.ps1) script demonstrates how to deploy a Windows Host Defender using PowerShell code from the Console.

## Important links
- [Running Ansible playbooks using EC2 Systems Manager](https://aws.amazon.com/blogs/mt/running-ansible-playbooks-using-ec2-systems-manager-run-command-and-state-manager/)
- [Ansible for managing AWS](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aws.html)
