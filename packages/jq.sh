install_jq() {
    write_info "Installing jq package..."

    write_info "Installing jq..."
    brew list jq &>/dev/null || brew install jq
    write_success "Done!"
    write_blank_line
}

uninstall_jq() {
    write_info "Uninstalling jq package..."

    write_info "Uninstalling jq..."
    brew uninstall jq || { write_warning "WARNING! jq is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
