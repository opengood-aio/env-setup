function install_python() {
    write_info "Installing Python package..."

    write_info "Installing Python..."
    brew list python3 &>/dev/null || brew install python3
    write_success "Done!"
    write_blank_line

    write_info "Verifying Python version..."
    python3 --version
    write_success "Done!"
    write_blank_line
}

function uninstall_python() {
    write_info "Uninstalling Python package..."

    write_info "Uninstalling Python..."
    brew uninstall python3 || { write_warning "WARNING! Python is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
