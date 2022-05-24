install_gnused() {
    write_info "Installing GNU Sed package..."

    write_info "Installing GNU Sed..."
    brew list gnu-sed &>/dev/null || brew install gnu-sed
    write_success "Done!"
    write_blank_line
}

uninstall_gnused() {
    write_info "Uninstalling GNU Sed package..."

    write_info "Uninstalling GNU Sed..."
    brew uninstall gnu-sed || { write_warning "WARNING! GNU Sed is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
