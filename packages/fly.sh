function install_fly() {
    write_info "Installing Fly CLI package..."

    if ! hash fly 2>/dev/null; then
        brew list fly &>/dev/null || brew cask install fly
        write_success "Done!"
        write_blank_line
    else
        write_progress "Fly CLI is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

function uninstall_fly() {
    write_info "Uninstalling Fly CLI package..."
    brew cask uninstall fly || { write_warning "WARNING! Fly CLI is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
