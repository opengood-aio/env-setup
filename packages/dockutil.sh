function install_dockutil() {
    write_info "Installing Dockutil package..."

    write_info "Installing Dockutil..."
    brew list dockutil &>/dev/null || brew install dockutil
    write_success "Done!"
    write_blank_line
}

function uninstall_dockutil() {
    write_info "Uninstalling Dockutil package..."

    write_info "Uninstalling Dockutil..."
    brew uninstall dockutil || { write_warning "WARNING! Dockutil is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
