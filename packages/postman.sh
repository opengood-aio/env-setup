function install_postman() {
    write_info "Installing Postman package..."

    write_info "Installing Postman..."
    if [[ ! -d "${apps_dir}/Postman.app" ]]; then brew cask install postman; else write_progress "Postman already installed"; fi
    write_success "Done!"
    write_blank_line
}

function uninstall_postman() {
    write_info "Uninstalling Postman package..."

    write_info "Uninstalling Postman..."
    brew cask uninstall postman || { write_warning "WARNING! Postman is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
