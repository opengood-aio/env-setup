intellij_idea_product_dir=IntelliJIdea${intellij_idea_version}
intellij_idea_cache_dir="${caches_dir}/${intellij_idea_product_dir}"
intellij_idea_logs_dir="${logs_dir}/${intellij_idea_product_dir}"
intellij_idea_plugins_dir="${app_support_dir}/${intellij_idea_product_dir}"
intellij_idea_prefs_dir="${prefs_dir}/${intellij_idea_product_dir}"

function install_intellijidea() {
    write_info "Installing IntelliJ IDEA package..."

    if [[ ! -d "/Applications/IntelliJ IDEA.app" ]]; then
        brew cask list intellij-idea &>/dev/null || brew cask install intellij-idea
        write_success "Done!"
        write_blank_line

        write_info "Installing IntelliJ IDEA plugins..."
        plugins=()
        plugins+=("Ignore,https://plugins.jetbrains.com/plugin/download?rel=true&updateId=48036")
        plugins+=("LinesSorter,https://plugins.jetbrains.com/plugin/download?rel=true&updateId=13587")
        plugins+=("Lombok,https://plugins.jetbrains.com/plugin/download?rel=true&updateId=53314")

        cd_push "${downloads_dir}"

        local plugin
        for plugin in "${plugins[@]}"; do
            parts=(${plugin//,/ })
            name=${parts[0]}
            file=$(to_lower_case "${name}.jar")
            uri=${parts[1]}

            download_intellijidea_plugin "${name}" "${file}" "${uri}"
            install_intellijidea_plugin "${name}" "${file}"
            rm -f "${file}"
        done
        unset plugin

        cd_pop

        install_intellijidea_settings
        write_success "Done!"
        write_blank_line
    else
        write_progress "IntelliJ IDEA is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

function uninstall_intellijidea() {
    write_info "Uninstalling IntelliJ IDEA package..."
    brew cask uninstall intellij-idea || { write_warning "WARNING! IntelliJ IDEA is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling IntelliJ IDEA cache..."
    rm -Rf "${intellij_idea_cache_dir}"
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling IntelliJ IDEA logs..."
    rm -Rf "${intellij_idea_logs_dir}"
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling IntelliJ IDEA plugins..."
    rm -Rf "${intellij_idea_plugins_dir}"
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling IntelliJ IDEA preferences..."
    rm -Rf "${intellij_idea_prefs_dir}"
    write_success "Done!"
    write_blank_line
}

function download_intellijidea_plugin() {
    local name="$1"
    local file="$2"
    local uri="$3"

    write_progress "Downloading IntelliJ IDEA plugin '${name}' from ${uri}..."
    curl -o "${file}" "${uri}"
    write_success "Done!"
    write_blank_line
}

function install_intellijidea_plugin() {
    local name="$1"
    local file="$2"

    if [[ ! -d "${intellij_idea_plugins_dir}" ]]; then
        mkdir -p "${intellij_idea_plugins_dir}"
    fi

    write_progress "Installing IntelliJ IDEA plugin '${name}' to '${intellij_idea_plugins_dir}/${file}'..."
    cp "${file}" "${intellij_idea_plugins_dir}/${file}"
    write_success "Done!"
    write_blank_line
}

function install_intellijidea_settings() {
    write_progress "Installing IntelliJ IDEA settings to '${intellij_idea_prefs_dir}'..."

    rm -Rf "${intellij_idea_prefs_dir}"
    if [[ ! -d "${intellij_idea_prefs_dir}" ]]; then
        mkdir -p "${intellij_idea_prefs_dir}"
    fi

    cp resources/intellij_idea_settings.zip "${prefs_dir}"
    cd_push "${prefs_dir}"
    unzip -o intellij_idea_settings.zip -d intellij_idea_settings
    cd_push intellij_idea_settings
    cp -R * "${intellij_idea_prefs_dir}"/
    cd_pop
    rm -Rf intellij_idea_settings/
    rm -f intellij_idea_settings.zip
    cd_pop

    write_success "Done!"
    write_blank_line
}
