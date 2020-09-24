function install_kscript() {
    write_info "Installing KScript package..."

    write_info "Installing KScript..."
    brew list holgerbrandl/tap/kscript &>/dev/null || brew install holgerbrandl/tap/kscript
    write_success "Done!"
    write_blank_line
}

function uninstall_kscript() {
    write_info "Uninstalling KScript package..."

    write_info "Uninstalling KScript..."
    brew uninstall holgerbrandl/tap/kscript || { write_warning "WARNING! KScript is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
