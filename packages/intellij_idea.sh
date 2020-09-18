source "${setup_dir}"/config/intellij_idea.sh

function get_intellij_idea_dependencies() {
    write_info "Getting Gradle package dependencies to install..."

    local dependencies=()
    dependencies+=("jq")

    local array
    array="$(declare -p dependencies)"
    local IFS=$'\v'
    echo "${array#*=}"
}

function install_intellij_idea() {
    write_info "Installing IntelliJ IDEA package..."

    if [[ ! -d "${apps_dir}/IntelliJ IDEA.app" ]]; then
        write_info "Installing IntelliJ IDEA..."
        brew cask list intellij-idea &>/dev/null || brew cask install intellij-idea
        write_success "Done!"
        write_blank_line

        get_intellij_idea_product_info
        write_success "Done!"
        write_blank_line

        write_info "Installing Pivotal IDE preferences for IntelliJ IDEA...'"
        cd_push "${workspace_dir}"/pivotal_ide_prefs/cli
        ./bin/ide_prefs install --ide=intellij
        cd_pop
        write_success "Done!"
        write_blank_line

        install_intellij_idea_plugins
        install_intellij_idea_settings
        write_success "Done!"
        write_blank_line
    else
        write_progress "IntelliJ IDEA is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

function uninstall_intellij_idea() {
    write_info "Uninstalling IntelliJ IDEA package..."

    get_intellij_idea_product_info

    write_info "Uninstalling IntelliJ IDEA..."
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

function get_intellij_idea_product_info() {
    write_info "Obtaining product information for latest version of IntelliJ IDEA..."

    local json
    json=$(curl -s "${intellij_idea_releases_api_base_uri}?code=${intellij_idea_product_code}&latest=true&type=release")

    intellij_idea_version=$(get_json "${json}" ".${intellij_idea_product_code}[0].majorVersion")
    intellij_idea_build_version=$(get_json "${json}" ".${intellij_idea_product_code}[0].build")
    intellij_idea_build="IU-${intellij_idea_build_version}"

    intellij_idea_product_dir=IntelliJIdea${intellij_idea_version}
    intellij_idea_cache_dir="${caches_dir}/JetBrains/${intellij_idea_product_dir}"
    intellij_idea_logs_dir="${logs_dir}/JetBrains/${intellij_idea_product_dir}"
    intellij_idea_plugins_dir="${app_support_dir}/JetBrains/${intellij_idea_product_dir}/plugins"
    intellij_idea_prefs_dir="${app_support_dir}/JetBrains/${intellij_idea_product_dir}"

    write_success "Done!"
    write_blank_line
}

function download_intellij_idea_plugin() {
    local name="$1"
    local id="$2"
    local file="$3"

    local uri="${intellij_idea_plugins_api_base_uri}?action=download&id=${id}&build=${intellij_idea_build}"

    write_progress "Downloading IntelliJ IDEA plugin '${name}' from '${uri}'..."
    curl -o "${file}" "${uri}"
    write_success "Done!"
    write_blank_line
}

function install_intellij_idea_plugin() {
    local name="$1"
    local file="$2"

    if [[ ! -d "${intellij_idea_plugins_dir}" ]]; then
        mkdir -p "${intellij_idea_plugins_dir}"
    fi

    write_progress "Installing IntelliJ IDEA plugin '${name}' to '${intellij_idea_plugins_dir}'..."
    cp "${file}" "${intellij_idea_plugins_dir}"
    write_success "Done!"
    write_blank_line
}

function install_intellij_idea_plugins() {
    write_info "Installing IntelliJ IDEA plugins..."

    local plugins=()
    plugins+=("Go,org.jetbrains.plugins.go")
    plugins+=("Ignore,mobi.hsz.idea.gitignore")
    plugins+=("LinesSorter,org.sylfra.idea.plugins.linessorter")
    plugins+=("Lombok,Lombook%20Plugin")
    plugins+=("MarkdownNavigator,com.vladsch.idea.multimarkdown")
    plugins+=("Python,Pythonid")
    plugins+=("Toml,org.toml.lang")

    cd_push "${downloads_dir}"

    local plugin
    for plugin in "${plugins[@]}"; do
        local parts=(${plugin//,/ })
        local name=${parts[0]}
        local id=${parts[1]}

        local file
        file=$(to_lower_case "${name}.jar")

        download_intellij_idea_plugin "${name}" "${id}" "${file}"
        install_intellij_idea_plugin "${name}" "${file}"
        rm -f "${file}"
    done
    unset plugin

    cd_pop
}

function install_intellij_idea_settings() {
    write_progress "Installing IntelliJ IDEA settings to '${intellij_idea_prefs_dir}'..."

    rm -Rf "${intellij_idea_prefs_dir}"
    if [[ ! -d "${intellij_idea_prefs_dir}" ]]; then
        mkdir -p "${intellij_idea_prefs_dir}"
    fi

    cp resources/intellij_idea_settings.zip "${prefs_dir}"
    cd_push "${prefs_dir}"
    unzip -o intellij_idea_settings.zip -d intellij_idea_settings
    cp -R intellij_idea_settings/* "${intellij_idea_prefs_dir}"/
    rm -Rf intellij_idea_settings/
    rm -f intellij_idea_settings.zip
    cd_pop

    write_success "Done!"
    write_blank_line
}
