# cloud-init_linux
[![Ansible](https://github.com/Kipjr/cloud-init_linux/actions/workflows/ansible.yml/badge.svg)](https://github.com/Kipjr/cloud-init_linux/actions/workflows/ansible.yml)

Cloud-Init for

`Ubuntu 24.04 LTS 	Noble Numbat (trixie 13)`

`Ubuntu 22.04 LTS 	Jammy Jellyfish (bookworm 12)`

`Debian 12 (bookworm)`

_~Debian 13 (trixie)~ - When available on ansible-lockdown.._

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
  "ubtu22_runcis": false,

  "ubtu24_vm": true,
  "ubtu24_run_task_disk": true,
  "ubtu24_run_task_packages": true,
  "ubtu24_pkg_webmin": true,
  "ubtu24_pkg_snmp": true,
  "ubtu24_run_task_docker": true
  "ubtu24_docker_type": "rootless",
  "ubtu24_portainer_agent": true,
  "ubtu24_portainer_host": true,
  "ubtu24_run_task_configuration": true,
  "ubtu24_run_task_security": true,
  "ubtu24_runcis": false,

  "deb12_vm": true,
  "deb12_run_task_disk": true,
  "deb12_run_task_packages": true,
  "deb12_pkg_webmin": true,
  "deb12_pkg_snmp": true,
  "deb12_run_task_docker": true
  "deb12_docker_type": "rootless",
  "deb12_portainer_agent": true,
  "deb12_portainer_host": true,
  "deb12_run_task_configuration": true,
  "deb12_run_task_security": true,
  "deb12_runcis": false

}
```
### Use standalone (Installs Ansible and executes playbook)
- Bash `standalone_ansible_playbook.sh` 
- Powershell Core: `standalone_ansible_playbook.ps1`

### Use with Proxmox Cloud-Init: 
- Build template
  - Do stuff..
  - Use as base image:
    - `https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img`
    - `https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img`
    - Resize image:
      - `qemu-img resize jammy-server-cloudimg-amd64.img 8G`
      - `qemu-img resize noble-server-cloudimg-amd64.img 8G`
- Execute somewhere `./proxmox/new_ci-config.sh`
- Store 'ci-config-userdata.yaml' in Proxmox Snippets
- Store 'ci-config-vendor.yaml' in Proxmox Snippets
- Update your template VM:
  - `qm set <vmid> --cicustom "user=local:snippets/ci-config-userdata.yaml"`
  - `qm set <vmid> --cicustom "vendor=local:snippets/ci-config-vendor.yaml"`

### Use Raw:
- `https://raw.githubusercontent.com/Kipjr/cloud-init_linux/master/site.yml`

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

