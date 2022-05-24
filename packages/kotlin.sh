install_kotlin() {
    write_info "Installing Kotlin package..."

    write_info "Installing Kotlin..."
    brew list kotlin &>/dev/null || brew install kotlin
    write_success "Done!"
    write_blank_line
}

uninstall_kotlin() {
    write_info "Uninstalling Kotlin package..."

    write_info "Uninstalling Kotlin..."
    brew uninstall kotlin || { write_warning "WARNING! Kotlin is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
