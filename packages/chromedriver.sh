function install_chromedriver() {
    write_info "Installing Google Chromedriver package..."
    brew cask list chromedriver &>/dev/null || brew cask install chromedriver
    write_success "Done!"
    write_blank_line
}

function uninstall_chromedriver() {
    write_info "Uninstalling Google Chrome Driver package..."
    brew cask uninstall chromedriver || { write_warning "WARNING! Google Chrome Driver is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
