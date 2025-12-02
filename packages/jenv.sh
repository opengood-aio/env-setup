get_jenv_dependencies() {
    write_info "Getting jenv package dependencies to install..."

    local dependencies=()
    dependencies+=("java")

    local array
    array="$(declare -p dependencies)"
    local IFS=$'\v'
    echo "${array#*=}"
}

install_jenv() {
    write_info "Installing jenv package..."

    write_info "Installing jenv..."
    brew list jenv &>/dev/null || brew install jenv
    write_success "Done!"
    write_blank_line

    write_info "Configuring jenv shims and auto completion in Bash profile..."
    cat <<EOF >>"${bash_profile}"

# jenv enable shims and auto completion
if which jenv > /dev/null; then eval "\$(jenv init -)"; fi

EOF
    source "${bash_profile}"
    write_success "Done!"
    write_blank_line

    write_info "Creating jenv directory '${jenv_dir}'..."
    mkdir -p "${jenv_dir}"
    write_success "Done!"
    write_blank_line

    write_info "Adding Java installations to jenv..."
    local version
    for version in "${supported_java_versions[@]}"; do
        jenv add "/Library/Java/JavaVirtualMachines/temurin-${version}.jdk/Contents/Home"
    done
    unset version
    write_success "Done!"
    write_blank_line

    write_info "Configuring jenv with Java default version '${default_java_version}'..."
    jenv global "${default_java_version}"
    write_success "Done!"
    write_blank_line
}

uninstall_jenv() {
    write_info "Uninstalling jenv package..."

    write_info "Uninstalling jenv..."
    brew uninstall jenv || { write_warning "WARNING! jenv is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
