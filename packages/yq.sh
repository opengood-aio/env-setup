function install_yq() {
    write_info "Installing YQ package..."
    brew list yq &>/dev/null || brew install yq
    write_success "Done!"
    write_blank_line
}

function uninstall_yq() {
    write_info "Uninstalling YQ package..."
    brew uninstall yq || { write_warning "WARNING! YQ is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
