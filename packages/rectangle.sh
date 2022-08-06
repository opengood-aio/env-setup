install_rectangle() {
    write_info "Installing Rectangle package..."

    if [[ ! -d "${apps_dir}/Rectangle.app" ]]; then
        write_info "Installing Rectangle..."
        brew list rectangle &>/dev/null || brew install --cask rectangle
        write_success "Done!"
        write_blank_line

        write_info "Configuring Rectangle..."
        open "${apps_dir}"/Rectangle.app
        write_success "Done!"
        write_blank_line
    else
        write_info "Rectangle is already installed..."
        write_success "Done!"
        write_blank_line
    fi
}

uninstall_rectangle() {
    write_info "Uninstalling Rectangle package..."

    write_info "Uninstalling Rectangle..."
    brew uninstall --cask rectangle || { write_warning "WARNING! Rectangle is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
