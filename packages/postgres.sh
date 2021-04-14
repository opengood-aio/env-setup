function install_postgres() {
    write_info "Installing Postgres package..."

    write_info "Installing Postgres..."
    brew list postgres &>/dev/null || brew install postgres
    write_success "Done!"
    write_blank_line

    write_info "Configuring Postgres service to start on system boot..."
    brew services start postgres
    write_success "Done!"
    write_blank_line
}

function uninstall_postgres() {
    write_info "Uninstalling Postgres package..."

    write_info "Uninstalling Postgres..."
    brew uninstall postgres || { write_warning "WARNING! Postgres is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
