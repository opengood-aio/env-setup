function install_wget() {
    write_info "Installing WGet package..."
    brew list wget &>/dev/null || brew install wget
    write_success "Done!"
    write_blank_line
}

function uninstall_wget() {
    write_info "Uninstalling WGet package..."
    brew uninstall wget || { write_warning "WARNING! WGet is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
