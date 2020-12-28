function install_gcc() {
    write_info "Installing GCC package..."

    write_info "Installing GCC..."
    brew list gcc &>/dev/null || brew install gcc
    write_success "Done!"
    write_blank_line
}

function uninstall_gcc() {
    write_info "Uninstalling GCC package..."

    write_info "Uninstalling GCC..."
    brew uninstall gcc || { write_warning "WARNING! GCC is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
