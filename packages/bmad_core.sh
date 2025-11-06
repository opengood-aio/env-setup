get_bmad_core_dependencies() {
    write_info "Getting bmad-core package dependencies to install..."

    local dependencies=()
    dependencies+=("node")

    local array
    array="$(declare -p dependencies)"
    local IFS=$'\v'
    echo "${array#*=}"
}

install_bmad_core() {
    write_info "Installing bmad-core package..."

    if [ ! -d "~/${bmad_core_dir}" ]; then
        write_info "Installing bmad-method and syncing .bmad-core..."
        local temp_dir
        temp_dir=$(mktemp -d)

        cd_push "${temp_dir}"
        npx bmad-method install

        if [ -d "${temp_dir}/${bmad_core_dir}" ]; then
            write_info "Copying .bmad-core to home directory..."
            cp -R "${temp_dir}/${bmad_core_dir}" "~/"

            if [ -n "${workspace_dir}" ] && [ -d "${setup_dir}" ]; then
                write_info "Copying .bmad-core to '${setup_dir}' project..."
                cp -R "${temp_dir}/${bmad_core_dir}" "${setup_dir}/"

                if [ -d "${temp_dir}/${bmad_commands_dir}" ]; then
                    write_info "Copying bmad commands to '${setup_dir}/${bmad_commands_dir}' project..."
                    mkdir -p "${setup_dir}/${bmad_commands_dir}"
                    cp -R "${temp_dir}/${bmad_commands_dir}" "${setup_dir}/${bmad_commands_dir}/"
                fi
            fi
        fi

        rm -rf "${temp_dir}"
        write_success "Done!"
        write_blank_line
    else
        write_progress "bmad-core is already installed in ~/${bmad_core_dir}"
        write_info "To update, run bin/sync-bmad-core.sh"
        write_success "Done!"
        write_blank_line
    fi
}

uninstall_bmad_core() {
    write_info "Uninstalling bmad-core package..."

    if [ -d "~/${bmad_core_dir}" ]; then
        write_info "Removing .bmad-core from home directory..."
        rm -rf "~/${bmad_core_dir}"
        write_success "Done!"
    else
        write_warning "WARNING! bmad-core is not installed and cannot be uninstalled. Continuing on."
    fi

    write_blank_line
}