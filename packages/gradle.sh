get_gradle_dependencies() {
    write_info "Getting Gradle package dependencies to install..."

    local dependencies=()
    dependencies+=("java")

    local array
    array="$(declare -p dependencies)"
    local IFS=$'\v'
    echo "${array#*=}"
}

install_gradle() {
    write_info "Installing Gradle package..."

    write_info "Installing Gradle..."
    brew list gradle &>/dev/null || brew install gradle
    write_success "Done!"
    write_blank_line
}

uninstall_gradle() {
    write_info "Uninstalling Gradle package..."

    write_info "Uninstalling Gradle..."
    brew uninstall gradle || { write_warning "WARNING! Gradle is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
