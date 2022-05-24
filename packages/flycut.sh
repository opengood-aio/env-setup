install_flycut() {
    write_info "Installing Flycut package..."

    if [[ ! -d "${apps_dir}/Flycut.app" ]]; then
        write_info "Installing Flycut..."
        brew list flycut &>/dev/null || brew install --cask flycut
        write_success "Done!"
        write_blank_line
    else
        write_progress "Flycut is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

uninstall_flycut() {
    write_info "Uninstalling Flycut package..."

    write_info "Uninstalling Flycut..."
    brew uninstall --cask flycut || { write_warning "WARNING! Flycut is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
