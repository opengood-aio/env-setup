install_gnused() {
    write_info "Installing gnused package..."

    write_info "Installing gnused..."
    brew list gnu-sed &>/dev/null || brew install gnu-sed
    write_success "Done!"
    write_blank_line
}

uninstall_gnused() {
    write_info "Uninstalling gnused package..."

    write_info "Uninstalling gnused..."
    brew uninstall gnu-sed || { write_warning "WARNING! gnused is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
