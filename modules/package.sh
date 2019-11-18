function load() {
    local type="$1"
    local dir="$2"

    local item
    for item in "${dir}"/*.sh; do
        source "${item}"
        item=$(basename -- "${item}")
        item="${item%.*}"
        write_progress "- Loaded ${type} '${item}'"
    done
    unset item
}

function install() {
    local type="$1"
    shift 1
    local array=("$@")

    local function_name
    for item in "${array[@]}"; do
        function_name="install_${item}"
        if function_exists "${function_name}"; then
            write_progress "-----------------------------------------"
            write_progress "Installing ${type} '${item}'"
            write_progress "-----------------------------------------"
            write_blank_line
            eval "${function_name}"
        fi
    done
    unset function_name
}

function uninstall() {
    local type="$1"
    shift 1
    local array=("$@")

    local function_name
    for item in "${array[@]}"; do
        function_name="uninstall_${item}"
        if function_exists "${function_name}"; then
            write_progress "-----------------------------------------"
            write_progress "Uninstalling ${type} '${item}'"
            write_progress "-----------------------------------------"
            write_blank_line
            eval "${function_name}"
        fi
    done
    unset function_name
}

function verify() {
    local type="$1"
    local dir="$2"
    shift 2
    local array=("$@")

    write_info "Packages to verify..."
    print_items_in_array "${array[@]}"

    for item in "${array[@]}"; do
        file=${dir}/${item}.sh
        if [[ -f ${file} ]]; then
            write_progress "Verified ${type} '${item}' is valid and exists for install/uninstall"
        else
            write_warning "WARNING! ${type} '${item}' not found and ${type} file '${file}' does not exist, skipping ${type}"
        fi
    done
}
