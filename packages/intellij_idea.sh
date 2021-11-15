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
        brew cask list intellij-idea &>/dev/null || brew install --cask intellij-idea
        write_success "Done!"
        write_blank_line

        get_intellij_idea_product_info
        install_intellij_idea_settings
        install_intellij_idea_plugins
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
    brew uninstall --cask intellij-idea || { write_warning "WARNING! IntelliJ IDEA is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line

    write_info "Deleting IntelliJ IDEA cache directory..."
    rm -Rf "${intellij_idea_cache_dir}"
    write_success "Done!"
    write_blank_line

    write_info "Deleting IntelliJ IDEA logs directory..."
    rm -Rf "${intellij_idea_logs_dir}"
    write_success "Done!"
    write_blank_line

    write_info "Deleting IntelliJ IDEA plugins directory..."
    rm -Rf "${intellij_idea_plugins_dir}"
    write_success "Done!"
    write_blank_line

    write_info "Deleting IntelliJ IDEA settings directory..."
    rm -Rf "${intellij_idea_settings_dir}"
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
    intellij_idea_app_support_dir="${app_support_dir}/JetBrains"
    intellij_idea_settings_dir="${intellij_idea_app_support_dir}/${intellij_idea_product_dir}"
    intellij_idea_plugins_dir="${intellij_idea_app_support_dir}/${intellij_idea_product_dir}/plugins"
    intellij_idea_cache_dir="${caches_dir}/JetBrains/${intellij_idea_product_dir}"
    intellij_idea_logs_dir="${logs_dir}/JetBrains/${intellij_idea_product_dir}"

    write_info "IntelliJ IDEA version: ${intellij_idea_version}"
    write_info "IntelliJ IDEA build version: ${intellij_idea_build_version}"
    write_info "IntelliJ IDEA build: ${intellij_idea_build}"
    write_info "IntelliJ IDEA product directory: ${intellij_idea_product_dir}"
    write_info "IntelliJ IDEA app spupport directory: ${intellij_idea_app_support_dir}"
    write_info "IntelliJ IDEA settings directory: ${intellij_idea_settings_dir}"
    write_info "IntelliJ IDEA plugins directory: ${intellij_idea_plugins_dir}"
    write_info "IntelliJ IDEA cache directory: ${intellij_idea_cache_dir}"
    write_info "IntelliJ IDEA logs directory: ${intellij_idea_logs_dir}"

    write_success "Done!"
    write_blank_line
}

function download_intellij_idea_plugin() {
    local name="$1"
    local id="$2"
    local file="$3"

    local uri="${intellij_idea_plugins_api_base_uri}?action=download&id=${id}&build=${intellij_idea_build}"
    write_info "IntelliJ IDEA plugin '${name}' download URI: '${uri}'"

    write_progress "Downloading IntelliJ IDEA plugin '${name}' from '${uri}' with output filename '${file}'..."
    curl -vL -o "${file}" "${uri}"
    if [[ -f "${file}" ]]; then
    	write_info "Completed download of IntelliJ IDEA plugin '${name}' to '${file}'"
    else
    	write_warning "Unable to download IntelliJ IDEA plugin '${name}' to '${file}'"
    fi

    write_progress "Unzipping IntelliJ IDEA plugin '${name}' from output filename '${file}'..."
    unzip -o "${file}"

    write_success "Done!"
    write_blank_line
}

function install_intellij_idea_plugins() {
    write_info "Installing IntelliJ IDEA plugins..."

    local plugins=()
    plugins+=("BashSupportPro,pro.bashsupport")
    plugins+=("Ignore,mobi.hsz.idea.gitignore")
    plugins+=("Kotest,kotest-plugin-intellij")
    plugins+=("Ktlint,com.nbadal.ktlint")
    plugins+=("Python,Pythonid")

    if [[ ! -d "${intellij_idea_plugins_dir}" ]]; then
    	write_progress "Creating IntelliJ IDEA plugins directory '${intellij_idea_plugins_dir}'..."
        mkdir -p "${intellij_idea_plugins_dir}"
    fi

    cd_push "${intellij_idea_plugins_dir}"

    local plugin
    for plugin in "${plugins[@]}"; do
        local parts=(${plugin//,/ })
        local name=${parts[0]}
        local id=${parts[1]}

        local file
        file=$(to_lower_case "${name}.zip")

        download_intellij_idea_plugin "${name}" "${id}" "${file}"
    done
    unset plugin

    cd_pop
}

function install_intellij_idea_settings() {
    write_progress "Installing IntelliJ IDEA settings to '${intellij_idea_settings_dir}'..."

    rm -Rf "${intellij_idea_settings_dir}"
    if [[ ! -d "${intellij_idea_settings_dir}" ]]; then
    	write_progress "Creating IntelliJ IDEA settings directory '${intellij_idea_settings_dir}'..."
        mkdir -p "${intellij_idea_settings_dir}"
    fi

    cp resources/intellij_idea_settings.zip "${intellij_idea_app_support_dir}"
    cd_push "${intellij_idea_app_support_dir}"
    unzip -o intellij_idea_settings.zip -d intellij_idea_settings
    rm -Rf intellij_idea_settings/__MACOSX
    cp -R intellij_idea_settings/* "${intellij_idea_settings_dir}"/
    rm -Rf intellij_idea_settings/
    rm -f intellij_idea_settings.zip
    cd_pop

    write_success "Done!"
    write_blank_line
}
