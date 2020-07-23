function get_jenv_dependencies() {
    write_info "Getting jEnv package dependencies to install..."

    local dependencies=()
    dependencies+=("java")

    local array
    array="$(declare -p dependencies)"
    local IFS=$'\v'
    echo "${array#*=}"
}

function install_jenv() {
    write_info "Installing jEnv package..."

    write_info "Installing jEnv..."
    brew list jenv &>/dev/null || brew install jenv
    write_success "Done!"
    write_blank_line
}

function uninstall_jenv() {
    write_info "Uninstalling jEnv package..."

    write_info "Uninstalling jEnv..."
    brew uninstall jenv || { write_warning "WARNING! jEnv is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
