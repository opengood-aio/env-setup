function get_bats_dependencies() {
    write_info "Getting BATS package dependencies to install..."

    local dependencies=()
    dependencies+=("gcc")

    local array
    array="$(declare -p dependencies)"
    local IFS=$'\v'
    echo "${array#*=}"
}

function install_bats() {
    write_info "Installing BATS package..."

    if ! hash bats-core 2>/dev/null; then
        write_info "Installing BATS Core..."
        brew list bats-core &>/dev/null || brew install bats-core

        write_info "Installing BATS Assert..."
        brew list bats-assert &>/dev/null || brew install bats-assert

        write_info "Installing BATS File..."
        brew list bats-file &>/dev/null || brew install bats-file

        write_info "Installing BATS Support..."
        brew list bats-support &>/dev/null || brew install bats-support
        write_success "Done!"
        write_blank_line
    else
        write_progress "BATS is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

function uninstall_bats() {
    write_info "Uninstalling BATS package..."

    write_info "Uninstalling BATS Core..."
    brew uninstall bats-core || { write_warning "WARNING! BATS Core is not installed and cannot be uninstalled. Continuing on."; }

    write_info "Uninstalling BATS Assert..."
    brew uninstall bats-assert || { write_warning "WARNING! BATS Assert is not installed and cannot be uninstalled. Continuing on."; }

    write_info "Uninstalling BATS File..."
    brew uninstall bats-file || { write_warning "WARNING! BATS File is not installed and cannot be uninstalled. Continuing on."; }

    write_info "Uninstalling BATS Support..."
    brew uninstall bats-support || { write_warning "WARNING! BATS Support is not installed and cannot be uninstalled. Continuing on."; }

    write_success "Done!"
    write_blank_line
}
