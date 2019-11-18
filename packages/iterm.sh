function install_iterm() {
    write_info "Installing iTerm package..."
    if [[ ! -d "/Applications/iTerm.app" ]]; then brew cask install iterm2; else write_progress "iTerm already installed"; fi
    write_success "Done!"
    write_blank_line

    write_info "Configuring iTerm..."
    cp resources/com.googlecode.iterm2.plist "${prefs_dir}"
    write_success "Done!"
    write_blank_line
}

function uninstall_iterm() {
    write_info "Uninstalling iTerm package..."
    brew cask uninstall iterm2 || { write_warning "WARNING! iTerm is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line

    write_info "Un-configuring iTerm..."
    rm -f "${prefs_dir}"/com.googlecode.iterm2.plist
    write_success "Done!"
    write_blank_line
}
