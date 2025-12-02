#!/usr/bin/env bash
set -e

bin_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
setup_dir=$(dirname "${bin_dir}")
workspace_dir=$(dirname "${setup_dir}")

source "${setup_dir}"/config/global.sh
source "${setup_dir}"/config/io.sh
source "${setup_dir}"/modules/colors.sh
source "${setup_dir}"/modules/commons.sh
source "${setup_dir}"/modules/io.sh

temp_dir=$(mktemp -d)

function usage() {
    write_info "Usage: ./$(basename "$0") [relative-path]"
    write_blank_line
    write_info "Arguments:"
    write_info "  relative-path  Optional. Relative directory path from workspace directory"
    write_info "                 Defaults to current project (env-setup)"
    write_blank_line
    write_info "Examples:"
    write_info "  ./$(basename "$0")              # Install to current project"
    write_info "  ./$(basename "$0") my-project   # Install to ~/workspace/my-project"
    write_blank_line
    exit 1
}

function cleanup() {
    write_info "Cleaning up temporary directory..."
    rm -rf "${temp_dir}"
    write_success "Done!"
    write_blank_line
}

trap cleanup EXIT

write_info "*************************************************************************"
write_info "BMad-Core Sync"
write_info "*************************************************************************"
write_blank_line

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    usage
fi

time {
    if [[ -n "$1" ]]; then
        bmad_install_dir="${workspace_dir}/$1"
    else
        bmad_install_dir="${setup_dir}"
    fi

    if [[ ! -d "${bmad_install_dir}" ]]; then
        write_error "ERROR! Installation directory '${bmad_install_dir}' does not exist"
        write_blank_line
        exit 1
    fi

    write_info "Installation directory: ${bmad_install_dir}"
    write_blank_line

    if ! hash npx 2>/dev/null; then
        write_error "ERROR! npx is not installed. Please install Node first."
        write_blank_line
        exit 1
    fi

    write_info "Syncing .bmad-core from bmad-method npm package..."
    write_blank_line

    write_info "Changing directory to temporary directory..."
    cd_push "${temp_dir}"
    write_success "Done!"
    write_blank_line

    write_info "Installing bmad-method in temporary directory..."
    npx bmad-method install
    write_success "Done!"
    write_blank_line

    if [ ! -d "${temp_dir}/${bmad_core_dir}" ]; then
        write_error "ERROR! '${bmad_core_dir}' directory not found after installation"
        write_blank_line
        exit 1
    fi

    if [ -d "${bmad_install_dir}/${bmad_core_dir}" ]; then
        backup_dir="${bmad_install_dir}/${bmad_core_dir}.backup.$(date +%Y%m%d_%H%M%S)"
        write_warning "NOTE: Backing up existing '${bmad_core_dir}' to '${backup_dir}'"
        mv "${bmad_install_dir}/${bmad_core_dir}" "${backup_dir}"
        write_success "Done!"
        write_blank_line
    fi

    write_info "Copying '${bmad_core_dir}' to '${bmad_install_dir}'..."
    cp -R "${temp_dir}/${bmad_core_dir}" "${bmad_install_dir}/"
    write_success "Done!"
    write_blank_line

    if [ -d "${temp_dir}/${bmad_commands_dir}" ]; then
        write_info "Copying BMad commands to '${bmad_install_dir}/${claude_commands_dir}/'..."
        mkdir -p "${bmad_install_dir}/${claude_commands_dir}"

        if [ -d "${bmad_install_dir}/${bmad_commands_dir}" ]; then
            backup_cmd_dir="${bmad_install_dir}/${bmad_commands_dir}.backup.$(date +%Y%m%d_%H%M%S)"
            write_warning "NOTE: Backing up existing BMad commands to '${backup_cmd_dir}'"
            mv "${bmad_install_dir}/${bmad_commands_dir}" "${backup_cmd_dir}"
        fi

        cp -R "${temp_dir}/${bmad_commands_dir}" "${bmad_install_dir}/${claude_commands_dir}/"
        write_success "Done!"
        write_blank_line
    fi

    write_info "Changing directory back to original..."
    cd_pop
    write_success "Done!"
    write_blank_line

    write_success "-----------------------------------------"
    write_success "BMad-core sync complete!"
    write_success "-----------------------------------------"
    write_blank_line

    write_info "Updated files in:"
    write_info "  - '${bmad_install_dir}/${bmad_core_dir}'"
    if [ -d "${bmad_install_dir}/${bmad_commands_dir}" ]; then
        write_info "  - '${bmad_install_dir}/${bmad_commands_dir}'"
    fi
    write_blank_line

    write_info "You can now review and commit the changes."
    write_blank_line
} 2>&1