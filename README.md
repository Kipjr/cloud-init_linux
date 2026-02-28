# cloud-init_ubuntu
[![Ansible](https://github.com/Kipjr/cloud-init_ubuntu/actions/workflows/ansible.yml/badge.svg)](https://github.com/Kipjr/cloud-init_ubuntu/actions/workflows/ansible.yml)

Cloud-Init for Ubuntu Server

# Usage

### Use with Semaphore
- Fill in every property within Semaphore UI
- Fill Envirionment Variables / Extra Vars with:
```json
{
  "ansible_become_user": "root",
  "ansible_become_method": "sudo",
  "ubtu22_vm": true,
  "ubtu22_run_task_disk": true,
  "ubtu22_run_task_packages": true,
  "ubtu22_pkg_webmin": true,
  "ubtu22_pkg_snmp": true,
  "ubtu22_run_task_docker": true
  "ubtu22_docker_type": "rootless",
  "ubtu22_portainer_agent": true,
  "ubtu22_portainer_host": true,
  "ubtu22_run_task_configuration": true,
  "ubtu22_run_task_security": true,
  "ubtu22_runcis": false
}
```
### Use standalone (Installs Ansible and executes playbook)
- Bash `standalone_ansible_playbook.sh` 
- Powershell Core: `standalone_ansible_playbook.ps1`

### Use with Proxmox Cloud-Init: 
- Build template
  - Do stuff..
  - Use `https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img` as base image.
    - Resize image`qemu-img resize jammy-server-cloudimg-amd64.img 8G`
- Execute somewhere `./proxmox/new_ci-config.sh`
- Store 'ci-config-userdata.yaml' in Proxmox Snippets
- Store 'ci-config-vendor.yaml' in Proxmox Snippets
- Update your template VM:
  - `qm set <vmid> --cicustom "user=local:snippets/ci-config-userdata.yaml"`
  - `qm set <vmid> --cicustom "vendor=local:snippets/ci-config-vendor.yaml"`

### Use Raw:
- `https://raw.githubusercontent.com/Kipjr/cloud-init_ubuntu/master/site.yml`

# Recommended partition layout 
| Mount Point      | Size               | Filesystem (Recommended) | Remarks                                                                                                  |
| ---------------- | ------------------ | ------------------------ | -------------------------------------------------------------------------------------------------------- |
| `/`              | 32 GB              | ext4                     | Root filesystem. Sufficient for base OS, packages, updates.                                              |
| `/home`          | 8 GB               | ext4                     | User data isolation.                                                                                     |
| `/var`           | 8 GB               | ext4                     | Variable state data. Logs excluded. Monitor space usage.                                                 |
| `/var/log`       | 8 GB               | ext4                     | Log isolation to prevent root exhaustion.                                                                |
| `/var/log/audit` | 4 GB               | ext4                     | Dedicated audit trail partition (auditd). Prevents log flooding impact.                                  |
| `/var/tmp`       | 1 GB               | ext4                     | Persistent temp storage across reboots.                                                                  |
| `/tmp`           | 1 GB               | ext4 or tmpfs            | Ephemeral temp storage. Prefer `tmpfs` if RAM allows.                                                    |
| `/opt/data`      | x GB + remainder   | ext4 or XFS              | Primary persistent data storage.                                                                         |

