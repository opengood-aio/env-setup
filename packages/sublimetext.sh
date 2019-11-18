function install_sublimetext() {
    write_info "Installing Sublime Text package..."
    if [[ ! -d "/Applications/Sublime Text.app" ]]; then brew cask install sublime-text; else write_progress "Sublime Text is already installed"; fi
    write_success "Done!"
    write_blank_line
}

function uninstall_sublimetext() {
    write_info "Uninstalling Sublime Text package..."
    brew cask uninstall sublime-text || { write_warning "WARNING! Sublime Text is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
