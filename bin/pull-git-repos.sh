#!/usr/bin/env bash
set -e

bin_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
setup_dir=$(dirname "${bin_dir}")
workspace_dir=$(dirname "${setup_dir}")

source "${setup_dir}"/config/global.sh
source "${setup_dir}"/modules/colors.sh
source "${setup_dir}"/modules/commons.sh
source "${setup_dir}"/modules/io.sh

function usage() {
    write_info "Usage: ./$(basename "$0") <base-dir>"
    write_blank_line
    exit 1
}

write_info "*************************************************************************"
write_info "Bulk Git Repos Pull"
write_info "*************************************************************************"
write_blank_line

if [[ $(get_array_length "$@") -lt 1 ]] ||
    [[ "$(contains_item_in_array "-h" "$@")" == "true" ]]; then
    usage
fi

time {
    args=("$@")
    base_dir="${args[0]}"

    if [[ "${base_dir}" == "" ]] || [[ ! -d "${base_dir}" ]]; then
        write_error "ERROR! Base directory '${base_dir}' specified does not exist. Please try again."
        write_blank_line
        exit 1
    fi

    write_info "Changing directory to '${base_dir}'..."
    cd_push "${base_dir}"
    write_success "Done!"
    write_blank_line

    write_info "Pulling latest changes for all local Git repos from remote origin..."
    write_blank_line

    for repo_path in $(find . -name ".git" | cut -c 3-); do
        repo=$(replace_string "${repo_path}" "\/.git" "")
        write_info "Pulling latest changes for local Git repo '${repo}'..."
        cd_push "${repo}"
        git checkout main || { git checkout master || { write_warning "Unable to checkout main or master branch"; } }
        git pull origin main -r || { git pull origin master -r || { write_warning "Unable to pull changes"; } }
        cd_pop
        write_success "Done!"
        write_blank_line
    done

    write_info "Changing directory back to original..."
    cd_pop
    write_success "Done!"
    write_blank_line
} 2>&1
