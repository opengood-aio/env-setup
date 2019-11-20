function install_rabbitmq() {
    write_info "Installing RabbitMQ package..."

    write_info "Installing RabbitMQ..."
    brew list rabbitmq &>/dev/null || brew install rabbitmq
    write_success "Done!"
    write_blank_line

    write_info "Configuring RabbitMQ service to start on system boot..."
    brew services start rabbitmq
    write_success "Done!"
    write_blank_line
}

function uninstall_rabbitmq() {
    write_info "Uninstalling RabbitMQ package..."

    write_info "Uninstalling RabbitMQ..."
    brew uninstall rabbitmq || { write_warning "WARNING! RabbitMQ is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
