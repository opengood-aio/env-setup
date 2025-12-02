install_llama_cpp() {
    write_info "Installing llama.cpp package..."

    write_info "Installing llama.cpp..."
    brew list llama.cpp &>/dev/null || brew install llama.cpp
    write_success "Done!"
    write_blank_line
}

uninstall_llama_cpp() {
    write_info "Uninstalling llama.cpp package..."

    write_info "Uninstalling llama.cpp..."
    brew uninstall llama.cpp || { write_warning "WARNING! llama.cpp is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
