function install_ideprefs() {
    write_info "Installing IDE preferences package..."

    write_info "Installing IDE preferences..."
    write_info "Downloading Pivotal IDE preferences..."
    cd_push "${workspace_dir}"
    if [[ ! -d pivotal_ide_prefs ]]; then
        git clone https://github.com/pivotal/pivotal_ide_prefs
    else
        cd_push pivotal_ide_prefs
        git checkout .
        git pull -r
        cd_pop
    fi
    cd_pop
    write_success "Done!"
    write_blank_line
}

function uninstall_ideprefs() {
    write_info "Uninstalling IDE preferences package..."

    write_info "Uninstalling IDE preferences..."
    write_info "Removing Pivotal IDE preferences..."
    rm -Rf "${workspace_dir}"/pivotal_ide_prefs
    write_success "Done!"
    write_blank_line
}
