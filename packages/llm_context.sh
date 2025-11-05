get_llm_context_dependencies() {
    write_info "Getting llm-context package dependencies to install..."

    local dependencies=()
    dependencies+=("uv")

    local array
    array="$(declare -p dependencies)"
    local IFS=$'\v'
    echo "${array#*=}"
}

install_llm_context() {
    write_info "Installing llm-context package..."

    if ! hash llm-context 2>/dev/null; then
        write_info "Installing llm-context via uv..."
        uv tool install "llm-context>=0.5.0"
        write_success "Done!"
        write_blank_line
    else
        write_progress "llm-context is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

uninstall_llm_context() {
    write_info "Uninstalling llm-context package..."

    write_info "Uninstalling llm-context..."
    uv tool uninstall llm-context || { write_warning "WARNING! llm-context is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}