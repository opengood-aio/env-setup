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

    write_info "Configuring jEnv shims and auto completion in Bash profile..."
    cat <<EOF >>"${bash_profile}"

# jEnv enable shims and auto completion
if which jenv > /dev/null; then eval "\$(jenv init -)"; fi

EOF
        source "${bash_profile}"
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
