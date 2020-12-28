function install_ktlint() {
    write_info "Installing ktlint package..."

    write_info "Installing ktlint..."
    brew list ktlint &>/dev/null || brew install ktlint
    write_success "Done!"
    write_blank_line
}

function uninstall_ktlint() {
    write_info "Uninstalling ktlint package..."

    write_info "Uninstalling ktlint..."
    brew uninstall ktlint || { write_warning "WARNING! ktlint is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
