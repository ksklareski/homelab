# Homelab

This repo contains the anisble files necessary to bootstrap my homelab environment.

## Topography
- One Hyper-V host
- One machine hosting iSCSI targets
- Hyper-V host mounts iSCSI drives to store guest machines
- Guest VM runs Nomad to schedule different dockerized jobs

## Disclaimers
The ansible tasks in this repo are probably not portable to your environment. There is still significant work needed to make them more generic and appliciable to your environment. Everything in this repo is "good enough" to work for me. Don't expect this to work easily for you!

## Usage
```
ansible-playbook -i ./environments/prod/hosts.yaml ./main.yaml --vault-password-file ~/vault-password

ansible-playbook -i ./environments/prod/hosts.yaml ./bootstrap-nomad.yaml --vault-password-file ~/vault-password
```