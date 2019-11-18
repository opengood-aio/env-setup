function install_springboot() {
    write_info "Installing Spring Boot package..."
    brew install springboot || { brew upgrade springboot; }
    write_success "Done!"
    write_blank_line
}

function uninstall_springboot() {
    write_info "Uninstalling Spring Boot package..."
    brew uninstall springboot || { write_warning "WARNING! Spring Boot is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
