function install_chrome() {
    write_info "Installing Google Chrome package..."
    if [[ ! -d "/Applications/Google Chrome.app" ]]; then brew cask install google-chrome; else write_progress "Google Chrome is already installed"; fi
    write_success "Done!"
    write_blank_line
}

function uninstall_chrome() {
    write_info "Uninstalling Google Chrome package..."
    brew cask uninstall google-chrome || { write_warning "WARNING! Google Chrome is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
