install_postgres() {
    write_info "Installing Postgres package..."

    write_info "Installing Postgres..."
    brew list postgresql@16 &>/dev/null || brew install postgresql@16
    write_success "Done!"
    write_blank_line

    write_info "Configuring Postgres service to start on system boot..."
    brew services start postgresql@16
    write_success "Done!"
    write_blank_line
}

uninstall_postgres() {
    write_info "Uninstalling Postgres package..."

    write_info "Uninstalling Postgres..."
    brew uninstall postgresql@16 || { write_warning "WARNING! Postgres is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
