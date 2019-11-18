#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
work_dir=$(dirname "${script_dir}")
workspace_dir=$(dirname "${work_dir}")

source "${work_dir}"/config/properties.sh
source "${work_dir}"/modules/colors.sh
source "${work_dir}"/modules/commons.sh
source "${work_dir}"/modules/java.sh

write_info "*************************************************************************"
write_info "Workstation Java Keystore Certificate Installer"
write_info "*************************************************************************"
write_blank_line

write_warning "NOTE: Setup script will interactively prompt for input"
write_blank_line

write_info "Enter account password for elevated installation permissions..."
sudo -K
sudo true
write_success "Done!"
write_blank_line

write_warning "NOTE: Account password will be cached to prevent additional password re-prompts"
write_blank_line

install_certs
