install_uv() {
    write_info "Installing UV package..."

    write_info "Installing UV..."
    brew list uv &>/dev/null || brew install uv
    write_success "Done!"
    write_blank_line
}

uninstall_uv() {
    write_info "Uninstalling UV package..."

    write_info "Uninstalling UV..."
    brew uninstall uv || { write_warning "WARNING! UV is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}