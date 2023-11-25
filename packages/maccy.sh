install_maccy() {
    write_info "Installing Maccy package..."

    if [[ ! -d "${apps_dir}/Maccy.app" ]]; then
        write_info "Installing Maccy..."
        brew list maccy &>/dev/null || brew install --cask maccy
        write_success "Done!"
        write_blank_line
    else
        write_progress "Maccy is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

uninstall_maccy() {
    write_info "Uninstalling Maccy package..."

    write_info "Uninstalling Maccy..."
    brew uninstall --cask maccy || { write_warning "WARNING! Maccy is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
