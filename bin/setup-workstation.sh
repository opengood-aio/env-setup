#!/usr/bin/env bash
set -e

bin_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
setup_dir=$(dirname "${bin_dir}")
workspace_dir=$(dirname "${setup_dir}")

source "${setup_dir}"/config/global.sh
source "${setup_dir}"/config/io.sh
source "${setup_dir}"/config/packages.sh
source "${setup_dir}"/modules/colors.sh
source "${setup_dir}"/modules/commons.sh
source "${setup_dir}"/modules/io.sh
source "${setup_dir}"/modules/package.sh
source "${setup_dir}"/modules/parse.sh

packages_dir=${setup_dir}/packages

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

    write_info "Setup Action: ${action}"
    write_blank_line

    case "${action}" in
    "install")
        if [[ $(get_array_length "${args[@]}") -eq 0 ]]; then
            write_error "ERROR! Install package(s) not specified. Please try again."
            write_blank_line
            exit 1
        fi

        case "${args[0]}" in
        "all")
            write_info "Loading base packages..."
            load_all "${packages_dir}" "${base_packages[@]}"
            write_success "Done!"
            write_blank_line

            write_info "Verifying base packages..."
            verify "${packages_dir}" "${base_packages[@]}"
            write_success "Done!"
            write_blank_line

            write_info "Installing base packages..."
            print_items_in_array "${base_packages[@]}"
            write_blank_line
            install "${base_packages[@]}"
            write_success "Done!"
            write_blank_line

            write_info "Loading required packages..."
            load_all "${packages_dir}" "${required_packages[@]}"
            write_success "Done!"
            write_blank_line

            write_info "Verifying required packages..."
            verify "${packages_dir}" "${required_packages[@]}"
            write_success "Done!"
            write_blank_line

            write_info "Installing required packages..."
            print_items_in_array "${required_packages[@]}"
            write_blank_line
            install "${required_packages[@]}"
            write_success "Done!"
            write_blank_line

            write_info "Loading requested packages..."
            load_all "${packages_dir}" "${args[@]}"
            write_success "Done!"
            write_blank_line

            write_info "Verifying requested packages..."
            verify "${packages_dir}" "${args[@]}"
            write_success "Done!"
            write_blank_line

            write_info "Installing requested packages..."
            install "${args[@]}"
            write_success "Done!"
            write_blank_line

            install_dockutil
            install_os_prefs

            write_success "-----------------------------------------"
            write_success "Setup complete!"
            write_success "-----------------------------------------"
            write_blank_line

            write_info "After checking the initial setup install output for any problems, start a new iTerm session to make use of all the installed software/tools"
            write_blank_line
            ;;

        *)
            write_info "Loading requested packages..."
            load_all "${packages_dir}" "${args[@]}"
            write_success "Done!"
            write_blank_line

            write_info "Verifying requested packages..."
            verify "${packages_dir}" "${args[@]}"
            write_success "Done!"
            write_blank_line

            write_info "Installing requested packages..."
            install "${args[@]}"
            write_success "Done!"
            write_blank_line
            ;;

        esac
        ;;

    "uninstall")
        write_info "Loading requested packages..."
        load_all "${packages_dir}" "${args[@]}"
        write_success "Done!"
        write_blank_line

        write_info "Verifying requested packages..."
        verify "${packages_dir}" "${args[@]}"
        write_success "Done!"
        write_blank_line

        write_info "Uninstalling requested packages..."
        uninstall "${args[@]}"
        write_success "Done!"
        write_blank_line

        if [[ "$(contains_item_in_array "all" "${args[@]}")" == "true" ]]; then
            write_info "Loading base packages..."
            load_all "${packages_dir}" "${base_packages[@]}"
            write_success "Done!"
            write_blank_line

            write_info "Verifying base packages..."
            verify "${packages_dir}" "${base_packages[@]}"
            write_success "Done!"
            write_blank_line

            write_info "Loading required packages..."
            load_all "${packages_dir}" "${required_packages[@]}"
            write_success "Done!"
            write_blank_line

            write_info "Verifying required packages..."
            verify "${packages_dir}" "${required_packages[@]}"
            write_success "Done!"
            write_blank_line

            uninstall_os_prefs
            uninstall_dockutil

            write_info "Uninstalling required packages..."
            print_items_in_array "${required_packages[@]}"
            write_blank_line
            uninstall "${required_packages[@]}"
            write_success "Done!"
            write_blank_line

            write_info "Uninstalling base packages..."
            print_items_in_array "${base_packages[@]}"
            write_blank_line
            uninstall $(reverse_items_in_array "${base_packages[@]}")
            write_success "Done!"
            write_blank_line
        fi

        write_success "-----------------------------------------"
        write_success "Uninstall complete"
        write_success "-----------------------------------------"
        write_blank_line
        ;;
    esac

    write_info "Changing directory back to original..."
    cd_pop
    write_success "Done!"
    write_blank_line
} 2>&1
