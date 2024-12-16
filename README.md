# cloud-init_ubuntu
Cloud-Init for Ubuntu Server

# Usage

### Use with Semaphore
- Fill in every property within Semaphore UI
- Fill Envirionment Variables / Extra Vars with:
```json
{
  "ansible_become": true,
  "ansible_become_user": "root",
  "ansible_become_method": "sudo",
  "ubtu22_vm": true,
  "ubtu22_pkg_webmin": true,
  "ubtu22_pkg_snmp": true,
  "ubtu22_portainer_agent": true,
  "ubtu22_runcis": false,
  "ubtu22_portainer_host": true
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


