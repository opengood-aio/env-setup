install_mysql() {
    write_info "Installing MySQL package..."

    write_info "Installing MySQL..."
    brew list mysql &>/dev/null || brew install mysql
    write_success "Done!"
    write_blank_line

    write_info "Configuring MySQL service to start on system boot..."
    brew services start mysql
    write_success "Done!"
    write_blank_line
}

uninstall_mysql() {
    write_info "Uninstalling MySQL package..."

    write_info "Uninstalling MySQL..."
    brew uninstall mysql || { write_warning "WARNING! MySQL is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
