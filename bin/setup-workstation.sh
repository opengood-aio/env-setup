#!/usr/bin/env bash
set -e

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
work_dir=$(dirname "${script_dir}")
workspace_dir=$(dirname "${work_dir}")

source "${work_dir}"/config/properties.sh
source "${work_dir}"/modules/colors.sh
source "${work_dir}"/modules/commons.sh
source "${work_dir}"/modules/io.sh
source "${work_dir}"/modules/package.sh
source "${work_dir}"/modules/parse.sh

function usage() {
    write_info "Usage: ./$(basename "$0") <setup-action>"
    write_blank_line
    write_info "Supported setup actions:"
    print_items_in_array "${supported_setup_actions[@]}"
    write_blank_line
    exit 1
}

write_info "*************************************************************************"
write_info "Workstation Setup"
write_info "*************************************************************************"
write_blank_line

if [[ $(get_array_length "$@") -lt 1 ]] ||
    [[ "$(contains_item_in_array "-h" "$@")" == "true" ]]; then
    usage
fi

time {
    args=("$@")
    action="${args[0]}"
    shift 1
    args=("$@")

    if [[ "$(contains_item_in_array "${action}" "${supported_setup_actions[@]}")" == "false" ]]; then
        write_error "ERROR! Unknown setup action '${action}' specified. Please try again."
        write_blank_line
        write_info "Supported setup actions:"
        print_items_in_array "${supported_setup_actions[@]}"
        write_blank_line
        exit 1
    fi

    write_warning "NOTE: Setup script will interactively prompt for input"
    write_blank_line

    write_info "Enter account password for elevated installation permissions..."
    sudo -K
    sudo true
    write_success "Done!"
    write_blank_line

    write_warning "NOTE: Account password will be cached to prevent additional password re-prompts"
    write_blank_line

    write_info "Changing directory to '${setup_dir}'..."
    cd_push "${setup_dir}"
    write_success "Done!"
    write_blank_line

    write_info "Loading installation packages..."
    load "${packages_dir}"
    write_success "Done!"
    write_blank_line

    case "${action}" in
    "install")
        install_homebrew
        install_bash
        install_bashit
        install_git
        install_ideprefs

        write_info "Installing required packages..."
        print_items_in_array "${required_packages[@]}"
        write_blank_line
        install "${required_packages[@]}"
        write_success "Done!"
        write_blank_line

        install_osprefs

        write_info "Verifying requested packages..."
        verify "${packages_dir}" "${args[@]}"
        write_success "Done!"
        write_blank_line

        write_info "Installing requested packages..."
        install "${args[@]}"
        write_success "Done!"
        write_blank_line

        write_success "-----------------------------------------"
        write_success "Setup complete!"
        write_success "-----------------------------------------"
        write_blank_line

        write_info "After checking the initial setup install output for any problems, start a new iTerm session to make use of all the installed software/tools"
        write_info "Rebooting is only necessary for keyboard repeat settings to work"
        write_blank_line
        ;;

    "update")
        brew update && brew upgrade
        ;;

    "uninstall")
        write_info "Verifying requested packages..."
        verify "${packages_dir}" "${args[@]}"
        write_success "Done!"
        write_blank_line

        write_info "Uninstalling requested packages..."
        uninstall "${args[@]}"
        write_success "Done!"
        write_blank_line

        if [[ "$(contains_item_in_array "all" "${args[@]}")" == "true" ]]; then
            uninstall_osprefs

            write_info "Uninstalling required packages..."
            print_items_in_array "${required_packages[@]}"
            write_blank_line
            uninstall "${required_packages[@]}"
            write_success "Done!"
            write_blank_line

            uninstall_ideprefs
            uninstall_git
            uninstall_bashit
            uninstall_bash
            uninstall_homebrew
        fi
        ;;
    esac

    write_info "Changing directory back to original..."
    cd_pop
    write_success "Done!"
    write_blank_line
} 2>&1
write_info "Setup Action: ${action}"
