install_docker_compose() {
    write_info "Installing docker-compose package..."

    write_info "Installing docker-compose..."
    brew list docker-compose &>/dev/null || brew install docker-compose
    write_success "Done!"
    write_blank_line

    write_info "Configuring Docker CLI to use 'docker compose' as command instead of 'docker-compose' by creating a symbolic link..."
    mkdir -p "${docker_dir}/cli-plugins"
    ln -sfn $(brew --prefix)/opt/docker-compose/bin/docker-compose "${docker_dir}/cli-plugins/docker-compose"
    write_success "Done!"
    write_blank_line
}

uninstall_docker_compose() {
    write_info "Uninstalling docker-compose package..."

    write_info "Uninstalling docker-compose..."
    brew uninstall docker-compose || { write_warning "WARNING! docker-compose is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}