function get_pip_dependencies() {
    write_info "Getting Pip package dependencies to install..."

    local dependencies=()
    dependencies+=("python")

    local array
    array="$(declare -p dependencies)"
    local IFS=$'\v'
    echo "${array#*=}"
}

function install_pip() {
    write_info "Installing Pip package..."

    if ! hash pip3 2>/dev/null; then
        write_info "Installing Pip..."
        python3 -m pip install --upgrade setuptools
        write_success "Done!"
        write_blank_line

        write_info "Installing Pip packages..."
        print_items_in_array "${supported_pip_packages[@]}"

        local package
        for package in "${supported_pip_packages[@]}"; do
            local package_installed
            package_installed=$(pip3 list | grep -F "${package}")

            if [[ "${package_installed}" == "" ]]; then
                write_progress "- Installing Pip package '${package}'"
                write_blank_line
                pip3 install "${package}"
            fi
        done
        unset package

        write_success "Done!"
        write_blank_line
    else
        write_progress "Pip is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

function uninstall_pip() {
    write_info "Uninstalling Pip package..."

	if hash pip3 2>/dev/null; then
        local package
        for package in "${supported_pip_packages[@]}"; do
            local package_installed
            package_installed=$(pip3 list | grep -F "${package}")

            if [[ "${package_installed}" != "" ]]; then
                write_progress "- Uninstalling Pip package '${package}'"
                write_blank_line
                pip3 uninstall "${package}"
            fi
        done
        unset package
    fi

    write_info "Uninstalling Pip..."
    python3 -m pip uninstall pip setuptools || { write_warning "Pip is not installed and cannot be uninstalled. Continuing on..."; }
    write_success "Done!"
    write_blank_line
}
