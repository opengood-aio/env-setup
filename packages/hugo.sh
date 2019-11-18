function install_hugo() {
    write_info "Installing Hugo package..."
    brew list hugo &>/dev/null || brew install hugo
    write_success "Done!"
    write_blank_line
}

function uninstall_hugo() {
    write_info "Uninstalling Hugo package..."
    brew uninstall hugo || { write_warning "WARNING! Hugo is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
