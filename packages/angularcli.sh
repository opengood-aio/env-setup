function install_angularcli() {
    write_info "Installing Angular CLI package..."

    write_info "Installing Angular CLI..."
    brew list angular-cli &>/dev/null || brew install angular-cli
    write_success "Done!"
    write_blank_line
}

function uninstall_angularcli() {
    write_info "Uninstalling Angular CLI package..."

    write_info "Uninstalling Angular CLI..."
    brew uninstall angular-cli || { write_warning "WARNING! Angular CLI is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
