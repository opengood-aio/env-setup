#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
work_dir=$(dirname "${script_dir}")
workspace_dir=$(dirname "${work_dir}")

source "${work_dir}"/config/properties.sh
source "${work_dir}"/modules/colors.sh
source "${work_dir}"/modules/commons.sh

write_info "*************************************************************************"
write_info "Workstation Git Repos Updater"
write_info "*************************************************************************"
write_blank_line

write_info "Pulling latest changes for all local Git repos from remote origin in GitHub..."
write_blank_line

cd "${workspace_dir}" || exit

for repo_path in $(find . -name ".git" | cut -c 3-); do
    repo=$(replace_string "${repo_path}" "\/.git" "")
    write_info "Pulling latest changes for local Git repo '${repo}'..."
    cd "${repo}" || exit
    git checkout master
    git pull origin master -r
    cd ..
    write_success "Done!"
    write_blank_line
done

write_success "All local Git repos latest changes pulled successfully!"
write_blank_line
