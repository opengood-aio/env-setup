install_jq() {
    write_info "Installing JQ package..."

    write_info "Installing JQ..."
    brew list jq &>/dev/null || brew install jq
    write_success "Done!"
    write_blank_line
}

uninstall_jq() {
    write_info "Uninstalling JQ package..."

    write_info "Uninstalling JQ..."
    brew uninstall jq || { write_warning "WARNING! JQ is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
