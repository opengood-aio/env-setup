function install_java() {
    write_info "Installing Java package..."
    local java_home=$(/usr/libexec/java_home -v "${default_java_version}" -F)

    if [[ ! -d "${java_home}" ]] && [[ "$(contains_string "${java_home}" "Unable to find any JVMs matching version \"${version}\"")" == "false" ]]; then
        write_info "Installing AdoptOpenJDK HomeBrew tap..."
        brew tap AdoptOpenJDK/openjdk
        write_success "Done!"
        write_blank_line

        write_info "Installing Java OpenJDK packages..."
        local version
        for version in "${supported_java_versions[@]}"; do
            brew cask list "adoptopenjdk${version}" &>/dev/null || brew cask install "adoptopenjdk${version}"
        done
        unset version
        write_success "Done!"
        write_blank_line

        write_info "Configuring JAVA_HOME path variable with Java version '${default_java_version}' as default version..."
        export JAVA_HOME=$(/usr/libexec/java_home -v "${default_java_version}")
        write_success "Done!"
        write_blank_line

        write_info "Verifying Java version '${default_java_version}' is default version and JAVA_HOME path variable is set correctly..."
        java -version
        write_success "Done!"
        write_blank_line

        write_info "Configuring Bash profile with JAVA_HOME env variable...'"
        cat << EOF >> "${bash_profile}"
# JAVA_HOME env variable
export JAVA_HOME=${JAVA_HOME}

EOF
        write_success "Done!"
        write_blank_line

        write_info "Installing Pivotal IDE preferences for IntelliJ IDEA...'"
        cd_push "${workspace_dir}"/pivotal_ide_prefs/cli
        ./bin/ide_prefs install --ide=intellij
        cd_pop
        write_success "Done!"
        write_blank_line
    else
        write_progress "Java is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

function uninstall_java() {
    write_info "Uninstalling Java package..."

    write_info "Uninstalling Java OpenJDK packages..."
    local version
    for version in "${supported_java_versions[@]}"; do
        brew cask uninstall "adoptopenjdk${version}" || { write_warning "Java OpenJDK ${version} is not installed and cannot be uninstalled. Continuing on..."; }
    done
    unset version
    write_success "Done!"
    write_blank_line
}
