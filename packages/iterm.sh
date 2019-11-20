function install_iterm() {
    write_info "Installing iTerm package..."

    if [[ ! -d "/Applications/iTerm.app" ]]; then
        write_info "Installing iTerm..."
        brew cask install iterm2
        write_success "Done!"
        write_blank_line
    else
        write_progress "iTerm already installed"
        write_success "Done!"
        write_blank_line
    fi

    write_info "Configuring iTerm..."
    cp resources/com.googlecode.iterm2.plist "${prefs_dir}"
    write_success "Done!"
    write_blank_line
}

function uninstall_iterm() {
    write_info "Uninstalling iTerm package..."

    write_info "Uninstalling iTerm..."
    brew cask uninstall iterm2 || { write_warning "WARNING! iTerm is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line

    write_info "Removing iTerm configuration..."
    rm -f "${prefs_dir}"/com.googlecode.iterm2.plist
    write_success "Done!"
    write_blank_line
}
