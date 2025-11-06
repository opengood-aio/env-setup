get_pip_dependencies() {
    write_info "Getting pip package dependencies to install..."

    local dependencies=()
    dependencies+=("python")

    local array
    array="$(declare -p dependencies)"
    local IFS=$'\v'
    echo "${array#*=}"
}

install_pip() {
    write_info "Installing pip package..."

    if ! hash pip3 2>/dev/null; then
        write_info "Installing pip..."
        python3 -m pip install --upgrade setuptools
        write_success "Done!"
        write_blank_line

        write_info "Installing pip packages..."
        print_items_in_array "${supported_pip_packages[@]}"

        local package
        for package in "${supported_pip_packages[@]}"; do
            local package_installed
            package_installed=$(pip3 list | grep -F "${package}" || { write_warning "Unable to install package"; })

            if [[ "${package_installed}" == "" ]]; then
                write_progress "- Installing pip package '${package}'"
                write_blank_line
                pip3 install "${package}"
            fi
        done
        unset package

        write_success "Done!"
        write_blank_line
    else
        write_progress "pip is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

uninstall_pip() {
    write_info "Uninstalling pip package..."

    if hash pip3 2>/dev/null; then
        local package
        for package in "${supported_pip_packages[@]}"; do
            local package_installed
            package_installed=$(pip3 list | grep -F "${package}" || { write_warning "Package not installed. Continuing on..."; write_blank_line; })

            if [[ "${package_installed}" != "" ]]; then
                write_progress "- Uninstalling pip package '${package}'"
                write_blank_line
                yes | pip3 uninstall "${package}" || { write_warning "Package not installed. Continuing on..."; write_blank_line; }
            fi
        done
        unset package
    fi

    write_info "Uninstalling pip..."
    python3 -m pip uninstall pip setuptools || { write_warning "pip is not installed and cannot be uninstalled. Continuing on..."; }
    write_success "Done!"
    write_blank_line
}
