function install_node() {
    write_info "Installing Node package..."

    if ! hash npm 2>/dev/null; then
        write_info "Installing Node..."
        brew list node &>/dev/null || brew install node
        write_success "Done!"
        write_blank_line

        write_info "Installing Node packages..."
        print_items_in_array "${supported_node_packages[@]}"

        npm config set strict-ssl false

        local package
        for package in "${supported_node_packages[@]}"; do
            local package_installed
            package_installed=$(npm list -g "${package}")

            if [[ "$(contains_string "${package_installed}" "(empty)")" == "true" ]]; then
                write_progress "- Installing Node package '${package}'"
                write_blank_line
                npm install "${package}" -g
            fi
        done
        unset package

        write_success "Done!"
        write_blank_line
    else
        write_progress "Node is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

function uninstall_node() {
    write_info "Uninstalling Node package..."

    local package
    for package in "${supported_node_packages[@]}"; do
        local package_installed
        package_installed=$(npm list -g "${package}")

        if [[ "$(contains_string "${package_installed}" "(empty)")" == "false" ]]; then
            write_progress "- Uninstalling Node package '${package}'"
            write_blank_line
            npm uninstall "${package}" -g
        fi
    done
    unset package

    write_info "Uninstalling Node..."
    brew uninstall node || { write_warning "Node is not installed and cannot be uninstalled. Continuing on..."; }
    write_success "Done!"
    write_blank_line
}
