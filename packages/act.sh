install_act() {
    write_info "Installing Act package..."

    write_info "Installing Act..."
    brew list act &>/dev/null || brew install act
    write_success "Done!"
    write_blank_line
}

uninstall_act() {
    write_info "Uninstalling Act package..."

    write_info "Uninstalling Act..."
    brew uninstall act || { write_warning "WARNING! Act is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
