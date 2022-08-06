install_jumpcut() {
    write_info "Installing Jumpcut package..."

    if [[ ! -d "${apps_dir}/Jumpcut.app" ]]; then
        write_info "Installing Jumpcut..."
        brew list jumpcut &>/dev/null || brew install --cask jumpcut
        write_success "Done!"
        write_blank_line
    else
        write_progress "Jumpcut is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

uninstall_jumpcut() {
    write_info "Uninstalling Jumpcut package..."

    write_info "Uninstalling Jumpcut..."
    brew uninstall --cask jumpcut || { write_warning "WARNING! Jumpcut is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
