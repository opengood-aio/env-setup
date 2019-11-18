function install_kotlin() {
    write_info "Installing Kotlin package..."
    brew list kotlin &>/dev/null || brew install kotlin
    write_success "Done!"
    write_blank_line
}

function uninstall_kotlin() {
    write_info "Uninstalling Kotlin package..."
    brew uninstall kotlin || { write_warning "WARNING! Kotlin is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
