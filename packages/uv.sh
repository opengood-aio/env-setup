install_uv() {
    write_info "Installing uv package..."

    write_info "Installing uv..."
    brew list uv &>/dev/null || brew install uv
    write_success "Done!"
    write_blank_line
}

uninstall_uv() {
    write_info "Uninstalling uv package..."

    write_info "Uninstalling uv..."
    brew uninstall uv || { write_warning "WARNING! uv is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}