source "${setup_dir}"/config/java.sh

install_java() {
    write_info "Installing Java package..."

    write_info "Obtaining JAVA_HOME path for installed Java version '${default_java_version}' as default version..."
    local java_home=$(/usr/libexec/java_home -v "${default_java_version}" -F)

    if [[ ! -d "${java_home}" ]] &&
        [[ "$(contains_string "${java_home}" "Unable to find any JVMs matching version \"${version}\"")" == "false" ]]; then

        write_info "Installing Adoptium Eclipse Temurin Java JDK versions..."
        local version
        for version in "${supported_java_versions[@]}"; do
            brew list "temurin@${version}" &>/dev/null || brew install "temurin@${version}"
        done
        unset version
        write_success "Done!"
        write_blank_line

        write_info "Installing GraalVM Java JDK versions..."
        for version in "${supported_java_versions[@]}"; do
            brew list "graalvm-jdk@${version}" &>/dev/null || brew install "graalvm-jdk@${version}"
            jvm_dir=$(find "${jvms_dir}" -type d -name "graalvm-jdk${version}*")
            sudo xattr -r -d com.apple.quarantine "${jvm_dir}"
        done
        unset version
        write_success "Done!"
        write_blank_line

        write_info "Configuring JAVA_HOME path env variable with Java version '${default_java_version}' as default version..."
        export JAVA_HOME=$(/usr/libexec/java_home -v "${default_java_version}")
        write_success "Done!"
        write_blank_line

        write_info "Verifying Java version '${default_java_version}' is default version and JAVA_HOME path env variable is set correctly..."
        java -version
        write_success "Done!"
        write_blank_line
    else
        write_progress "Java is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

uninstall_java() {
    write_info "Uninstalling Java package..."

    write_info "Uninstalling Adoptium Eclipse Temurin Java JDK versions..."
    local version
    for version in "${supported_java_versions[@]}"; do
        brew uninstall "temurin@${version}" || { write_warning "Adoptium Eclipse Temurin Java JDK ${version} is not installed and cannot be uninstalled. Continuing on..."; }
    done

    write_info "Uninstalling GraalVM Java JDK versions..."
    for version in "${supported_java_versions[@]}"; do
        brew uninstall --cask "graalvm-jdk@${version}" || { write_warning "GraalVM Java JDK ${version} is not installed and cannot be uninstalled. Continuing on..."; }
    done
    unset version
    write_success "Done!"
    write_blank_line
}
