function load() {
    local dir="$1"

    local package
    for package in "${dir}"/*.sh; do
        source "${package}"
        package=$(basename -- "${package}")
        package="${package%.*}"
        write_progress "- Loaded package '${package}'"
    done
    unset package
}

function install() {
    local array=("$@")

    local package
    for package in "${array[@]}"; do
        local function_name="get_${package}_dependencies"
        if function_exists "${function_name}"; then
            eval declare -a dependencies="\$(${function_name})"
            write_progress "Installing package dependencies for '${package}':"
            print_items_in_array "${dependencies[@]}"
            install "${dependencies[@]}"
        fi

        function_name="install_${package}"
        if function_exists "${function_name}"; then
            write_progress "-----------------------------------------"
            write_progress "Installing package '${package}'"
            write_progress "-----------------------------------------"
            write_blank_line
            eval "${function_name}"
        fi
    done
    unset package
}

function uninstall() {
    local array=("$@")

    local package
    for package in "${array[@]}"; do
        local function_name="uninstall_${package}"
        if function_exists "${function_name}"; then
            write_progress "-----------------------------------------"
            write_progress "Uninstalling package '${package}'"
            write_progress "-----------------------------------------"
            write_blank_line
            eval "${function_name}"
        fi
    done
    unset package
}

function verify() {
    local dir="$1"
    shift 1
    local array=("$@")

    write_info "Packages to verify..."
    print_items_in_array "${array[@]}"

    local package
    for package in "${array[@]}"; do
        local file="${dir}"/${package}.sh
        if [[ -f ${file} ]]; then
            write_progress "Verified package '${package}' is valid and exists for install/uninstall"
        else
            write_warning "WARNING! Package '${package}' not found and package file '${file}' does not exist, skipping package"
        fi
    done
    unset package
}
