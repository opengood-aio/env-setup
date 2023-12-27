install_iterm() {
    write_info "Installing iTerm package..."

    if [[ ! -d "${apps_dir}/iTerm.app" ]]; then
        write_info "Installing iTerm..."
        brew install --cask iterm2
        write_success "Done!"
        write_blank_line
    else
        write_progress "iTerm already installed"
        write_success "Done!"
        write_blank_line
    fi

    write_info "Configuring iTerm..."
    cp "${resources_dir}/com.googlecode.iterm2.plist" "${preferences_dir}"
    write_success "Done!"
    write_blank_line
}

uninstall_iterm() {
    write_info "Uninstalling iTerm package..."

    write_info "Uninstalling iTerm..."
    brew uninstall --cask iterm2 || { write_warning "WARNING! iTerm is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line

    write_info "Removing iTerm configuration..."
    rm -f "${preferences_dir}"/com.googlecode.iterm2.plist
    write_success "Done!"
    write_blank_line
}
