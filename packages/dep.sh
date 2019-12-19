function install_dep() {
    write_info "Installing Dep package..."

    write_info "Installing Dep..."
    brew list dep &>/dev/null || brew install dep
    write_success "Done!"
    write_blank_line
}

function uninstall_dep() {
    write_info "Uninstalling Dep package..."

    write_info "Uninstalling Dep..."
    brew uninstall dep || { write_warning "WARNING! Dep is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
