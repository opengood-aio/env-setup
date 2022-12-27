install_kafka() {
    write_info "Installing Kafka package..."

    write_info "Installing Kafka..."
    brew list kafka &>/dev/null || brew install kafka
    write_success "Done!"
    write_blank_line

    write_info "Configuring Postgres service to start on system boot..."
    brew services start kafka
    write_success "Done!"
    write_blank_line
}

uninstall_kafka() {
    write_info "Uninstalling Kafka package..."

    write_info "Uninstalling Kafka..."
    brew uninstall kafka || { write_warning "WARNING! Kafka is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
