source "${setup_dir}"/config/jetbrains.sh

# Download and install a JetBrains plugin
# Arguments:
#   $1 - Plugin name
#   $2 - Plugin ID
#   $3 - Output filename for download
# Uses: jetbrains_product_info global associative array
download_jetbrains_plugin() {
    local name="$1"
    local id="$2"
    local file="$3"

    write_info "Downloading ${jetbrains_name} ${jetbrains_product_info[product_name]} plugin '${name}' from '${uri}' with output filename '${file}'..."

    local uri="${jetbrains_plugins_api_base_uri}?action=download&id=${id}&build=${jetbrains_product_info[build]}"
    write_progress "${jetbrains_name} ${jetbrains_product_info[product_name]} plugin '${name}' download URI: '${uri}'"

    curl -vL -o "${file}" "${uri}"

    if [[ -f "${file}" ]]; then
    	write_progress "Completed download of ${jetbrains_name} ${jetbrains_product_info[product_name]} plugin '${name}' to '${file}'"
    	write_progress "Unzipping ${jetbrains_name} ${jetbrains_product_info[product_name]} plugin '${name}' from output filename '${file}'..."
        unzip -o "${file}"
    else
    	write_warning "Unable to download ${jetbrains_name} ${jetbrains_product_info[product_name]} plugin '${name}' to '${file}'"
    fi

    write_success "Done!"
    write_blank_line
}

# Fetch product information for a JetBrains product from the JetBrains API
# Arguments:
#   $1 - Product code (e.g., "IIU" for IntelliJ IDEA Ultimate, "PCP" for PyCharm Professional)
# Sets: Global associative array jetbrains_product_info with version, build, and directory paths
get_jetbrains_product_info() {
    local product_code="$1"

    declare -gA jetbrains_product_info
    jetbrains_product_info[product_name]="${jetbrains_products[${product_code}]}"

    write_info "Obtaining product information for latest version of ${jetbrains_name} ${jetbrains_product_info[product_name]}..."

    local uri="${jetbrains_product_releases_api_base_uri}?code=${product_code}&latest=true&type=release"
    write_progress "${jetbrains_name} ${jetbrains_product_info[product_name]} product download URI: '${uri}'"

    local json
    json=$(curl -s "${uri}")

    jetbrains_product_info[version]=$(get_json "${json}" ".${product_code}[0].majorVersion")
    jetbrains_product_info[build_version]=$(get_json "${json}" ".${product_code}[0].build")
    jetbrains_product_info[build]="${jetbrains_product_editions[${product_code}]}-${jetbrains_product_info[build_version]}"

    jetbrains_product_info[product_dir]="${jetbrains_product_dirs[${product_code}]}${jetbrains_product_info[version]}"
    jetbrains_product_info[app_support_dir]="${app_support_dir}/${jetbrains_dir}"
    jetbrains_product_info[settings_dir]="${jetbrains_product_info[app_support_dir]}/${jetbrains_product_info[product_dir]}"
    jetbrains_product_info[plugins_dir]="${jetbrains_product_info[app_support_dir]}/${jetbrains_product_info[product_dir]}/plugins"
    jetbrains_product_info[cache_dir]="${caches_dir}/${jetbrains_dir}/${jetbrains_product_info[product_dir]}"
    jetbrains_product_info[logs_dir]="${logs_dir}/${jetbrains_dir}/${jetbrains_product_info[product_dir]}"

    write_progress "Completed obtaining ${jetbrains_name} ${jetbrains_product_info[product_name]} product information..."
    write_info "${jetbrains_name} ${jetbrains_product_info[product_name]} version: ${jetbrains_product_info[version]}"
    write_info "${jetbrains_name} ${jetbrains_product_info[product_name]} build version: ${jetbrains_product_info[build_version]}"
    write_info "${jetbrains_name} ${jetbrains_product_info[product_name]} build: ${jetbrains_product_info[build]}"
    write_info "${jetbrains_name} ${jetbrains_product_info[product_name]} product directory: ${jetbrains_product_info[product_dir]}"
    write_info "${jetbrains_name} ${jetbrains_product_info[product_name]} app support directory: ${jetbrains_product_info[app_support_dir]}"
    write_info "${jetbrains_name} ${jetbrains_product_info[product_name]} settings directory: ${jetbrains_product_info[settings_dir]}"
    write_info "${jetbrains_name} ${jetbrains_product_info[product_name]} plugins directory: ${jetbrains_product_info[plugins_dir]}"
    write_info "${jetbrains_name} ${jetbrains_product_info[product_name]} cache directory: ${jetbrains_product_info[cache_dir]}"
    write_info "${jetbrains_name} ${jetbrains_product_info[product_name]} logs directory: ${jetbrains_product_info[logs_dir]}"

    write_success "Done!"
    write_blank_line
}

# Install multiple plugins for a JetBrains product
# Arguments:
#   $1 - Name reference to associative array of plugins (name => plugin_id)
# Uses: jetbrains_product_info global associative array
install_jetbrains_plugins() {
    declare -n plugins=$1

    write_info "Installing ${jetbrains_name} ${jetbrains_product_info[product_name]} plugins..."

    if [[ ! -d "${jetbrains_product_info[plugins_dir]}" ]]; then
    	write_progress "Creating ${jetbrains_name} ${jetbrains_product_info[product_name]} plugins directory '${jetbrains_product_info[plugins_dir]}'..."
        mkdir -p "${jetbrains_product_info[plugins_dir]}"
    fi

    cd_push "${jetbrains_product_info[plugins_dir]}"

    write_info "Plugins to install..."
    print_entries_in_map plugins

    local plugin
    for plugin in "${!plugins[@]}"; do
        local name="${plugin}"
        local id="${plugins[$plugin]}"

        local file
        file=$(to_lower_case "${name}.zip")

        download_jetbrains_plugin "${name}" "${id}" "${file}"
    done
    unset plugin

    cd_pop
}

# Install a JetBrains product via Homebrew and apply settings/plugins
# Arguments:
#   $1 - Product code (e.g., "IIU" for IntelliJ IDEA Ultimate)
#   $2 - Name reference to associative array of plugins to install
# Installs product, settings from resources/, and specified plugins
install_jetbrains_product() {
    local product_code="$1"
    local -n product_plugins=$2

    get_jetbrains_product_info "${product_code}"
    write_info "Installing ${jetbrains_name} ${jetbrains_product_info[product_name]} package..."

    if [[ ! -d "${apps_dir}/${jetbrains_apps[${product_code}]}" ]]; then
        write_info "Installing ${jetbrains_name} ${jetbrains_product_info[product_name]}..."
        brew cask list "${jetbrains_homebrew_packages[$product_code]}" &>/dev/null || brew install --cask "${jetbrains_homebrew_packages[$product_code]}"
        write_success "Done!"
        write_blank_line

        install_jetbrains_product_settings "${product_code}"
        install_jetbrains_plugins product_plugins
    else
        write_progress "${jetbrains_name} ${jetbrains_product_info[product_name]} is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

# Install product settings from a settings archive in resources/ directory
# Arguments:
#   $1 - Product code
# Extracts settings ZIP archive to the product's settings directory
# Uses: jetbrains_product_info global associative array
install_jetbrains_product_settings() {
    local product_code="$1"

    write_info "Installing ${jetbrains_name} ${jetbrains_product_info[product_name]} product settings to '${jetbrains_product_info[settings_dir]}'..."

    local resource="${jetbrains_resources[${product_code}]}"
    local resource_dir=$(basename -- "${resource}" .zip)

    if [[ -f "${resources_dir}/${resource}" ]]; then
        rm -Rf "${jetbrains_product_info[settings_dir]}"
        if [[ ! -d "${jetbrains_product_info[settings_dir]}" ]]; then
            write_progress "Creating ${jetbrains_name} ${jetbrains_product_info[product_name]} product settings directory '${jetbrains_product_info[settings_dir]}'..."
            mkdir -p "${jetbrains_product_info[settings_dir]}"
        fi

        cp "${resources_dir}/${resource}" "${jetbrains_product_info[app_support_dir]}"
        cd_push "${jetbrains_product_info[app_support_dir]}"
        unzip -o "${resource}" -d "${resource_dir}"
        rm -Rf "${resource_dir}/__MACOSX"
        cp -R ${resource_dir}/* "${jetbrains_product_info[settings_dir]}"/
        rm -Rf "${resource_dir}"
        rm -f "${resource}"
        cd_pop
    else
        write_info "Resource '${resource}' for ${jetbrains_name} ${jetbrains_product_info[product_name]} product settings not found. Skipping."
    fi

    write_success "Done!"
    write_blank_line
}

# Uninstall a JetBrains product and remove all associated data
# Arguments:
#   $1 - Product code (e.g., "IIU" for IntelliJ IDEA Ultimate)
# Removes: Application, cache directory, logs directory, plugins directory, settings directory
uninstall_jetbrains_product() {
    local product_code="$1"

    get_jetbrains_product_info "${product_code}"
    write_info "Uninstalling ${jetbrains_product_info[product_name]} package..."

    write_info "Uninstalling ${jetbrains_name} ${jetbrains_product_info[product_name]} product..."
    brew uninstall --cask "${jetbrains_homebrew_packages[$product_code]}" || { write_warning "WARNING! ${jetbrains_name} ${jetbrains_product_info[product_name]} is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line

    write_info "Deleting ${jetbrains_name} ${jetbrains_product_info[product_name]} cache directory..."
    rm -Rf "${jetbrains_product_info[cache_dir]}"
    write_success "Done!"
    write_blank_line

    write_info "Deleting ${jetbrains_name} ${jetbrains_product_info[product_name]} logs directory..."
    rm -Rf "${jetbrains_product_info[logs_dir]}"
    write_success "Done!"
    write_blank_line

    write_info "Deleting ${jetbrains_name} ${jetbrains_product_info[product_name]} plugins directory..."
    rm -Rf "${jetbrains_product_info[plugins_dir]}"
    write_success "Done!"
    write_blank_line

    write_info "Deleting ${jetbrains_name} ${jetbrains_product_info[product_name]} settings directory..."
    rm -Rf "${jetbrains_product_info[settings_dir]}"
    write_success "Done!"
    write_blank_line
}
