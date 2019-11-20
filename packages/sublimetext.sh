function install_sublimetext() {
    write_info "Installing Sublime Text package..."

    if [[ ! -d "/Applications/Sublime Text.app" ]]; then
        write_info "Installing Sublime Text..."
        brew cask install sublime-text
        write_success "Done!"
        write_blank_line
    else
        write_progress "Sublime Text is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

function uninstall_sublimetext() {
    write_info "Uninstalling Sublime Text package..."

    write_info "Uninstalling Sublime Text..."
    brew cask uninstall sublime-text || { write_warning "WARNING! Sublime Text is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
