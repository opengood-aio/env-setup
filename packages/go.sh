function install_go() {
    write_info "Installing Go package..."
    brew list go &>/dev/null || brew install go
    write_success "Done!"
    write_blank_line
}

function uninstall_go() {
    write_info "Uninstalling Go package..."
    brew uninstall go || { write_warning "WARNING! Go is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
