install_vim() {
    write_info "Installing vim package..."

    write_info "Installing vim..."
    brew list vim &>/dev/null || brew install vim
    write_success "Done!"
    write_blank_line
}

uninstall_vim() {
    write_info "Uninstalling vim package..."

    write_info "Uninstalling vim configuration..."
    rm -Rf "${vim_dir}"
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling vim..."
    brew uninstall vim || { write_warning "WARNING! vim is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
