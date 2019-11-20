function install_chrome() {
    write_info "Installing Google Chrome package..."

    if [[ ! -d "/Applications/Google Chrome.app" ]]; then
        write_info "Installing Google Chrome..."
        brew cask install google-chrome
        write_success "Done!"
        write_blank_line
    else
        write_progress "Google Chrome is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

function uninstall_chrome() {
    write_info "Uninstalling Google Chrome package..."

    write_info "Uninstalling Google Chrome..."
    brew cask uninstall google-chrome || { write_warning "WARNING! Google Chrome is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
