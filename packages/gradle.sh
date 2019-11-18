function install_gradle() {
    write_info "Installing Gradle package..."
    brew list gradle &>/dev/null || brew install gradle
    write_success "Done!"
    write_blank_line
}

function uninstall_gradle() {
    write_info "Uninstalling Gradle package..."
    brew uninstall gradle || { write_warning "WARNING! Gradle is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
