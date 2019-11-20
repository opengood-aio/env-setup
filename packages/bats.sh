function install_bats() {
    write_info "Installing BATS package..."

    if ! hash bats 2>/dev/null; then
        write_info "Installing BATS..."
        brew list bats &>/dev/null || brew install bats
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

    write_info "Uninstalling BATS..."
    brew uninstall bats || { write_warning "WARNING! BATS is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
