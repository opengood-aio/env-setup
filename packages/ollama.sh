install_ollama() {
    write_info "Installing ollama package..."

    write_info "Installing ollama..."
    brew list ollama &>/dev/null || brew install ollama
    write_success "Done!"
    write_blank_line
}

uninstall_ollama() {
    write_info "Uninstalling ollama package..."

    write_info "Uninstalling ollama..."
    brew uninstall ollama || { write_warning "WARNING! ollama is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
