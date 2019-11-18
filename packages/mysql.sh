function install_mysql() {
    write_info "Installing MySQL package..."
    brew list mysql &>/dev/null || brew install mysql
    write_success "Done!"
    write_blank_line

    write_info "Configuring MySQL service to start on system boot..."
    brew services start mysql
    write_success "Done!"
    write_blank_line
}

function uninstall_mysql() {
    write_info "Uninstalling MySQL package..."
    brew uninstall mysql || { write_warning "WARNING! NySQL is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
