#!/usr/bin/env bash
set -euo pipefail

UID_CHECK=$(id -u)
if [ "$UID_CHECK" -eq 0 ]; then
    echo "Run as regular user."
    exit 1
fi

GITHUB_REPO_URL="${1:-https://github.com/Kipjr/cloud-init_linux.git}"
PLAYBOOK_NAME="${2:-site.yml}"
WORKING_DIR="${3:-/tmp}"
ANSIBLE_ARG="${4:-}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo apt-get update
sudo apt-get install -y git python3-venv python3-pip

# Detect if running inside repo
if [ ! -d "${SCRIPT_DIR}/.git" ]; then
    mkdir -p "${WORKING_DIR}"
    TMPDIR="$(mktemp -d -p "${WORKING_DIR}" cloud-init.XXXX)"
    git clone "${GITHUB_REPO_URL}" "${TMPDIR}/repo"

    chmod +x "${TMPDIR}/repo/standalone_ansible_playbook.sh"

    exec "${TMPDIR}/repo/standalone_ansible_playbook.sh" \
        "${GITHUB_REPO_URL}" \
        "${PLAYBOOK_NAME}" \
        "${WORKING_DIR}" \
        "${ANSIBLE_ARG}"
fi

cd "${SCRIPT_DIR}"

python3 -m venv venv
# shellcheck disable=SC1091
source venv/bin/activate
pip install ansible

if [ -f "${SCRIPT_DIR}/defaults/main.yml" ]; then
    mkdir -p defaults
fi

if [ -f "${SCRIPT_DIR}/${PLAYBOOK_NAME}" ]; then
    ansible-galaxy install -r collections/requirements.yml
    ansible-playbook -v -i inventory ${ANSIBLE_ARG} "${PLAYBOOK_NAME}"
else
    echo "Playbook ${PLAYBOOK_NAME} does not exist."
    exit 1
fi
