install_gcc() {
    write_info "Installing gcc package..."

    write_info "Installing gcc..."
    brew list gcc &>/dev/null || brew install gcc
    write_success "Done!"
    write_blank_line
}

uninstall_gcc() {
    write_info "Uninstalling gcc package..."

    write_info "Uninstalling gcc..."
    brew uninstall gcc || { write_warning "WARNING! GCC is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
