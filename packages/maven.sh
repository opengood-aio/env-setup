function install_maven() {
    write_info "Installing Maven package..."
    brew list maven &>/dev/null || brew install maven
    write_success "Done!"
    write_blank_line

    local maven_home_dir=~/.m2

    if [[ ! -d "${maven_home_dir}" ]]; then
        write_info "Adding Nexus repository to settings.xml in '${maven_home_dir}' directory"
        mkdir "${maven_home_dir}"
        cp resources/settings.xml "${maven_home_dir}"/settings.xml
    fi
}

function uninstall_maven() {
    write_info "Uninstalling Maven package..."
    brew uninstall maven || { write_warning "WARNING! Maven is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
