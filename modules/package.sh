# Load all package scripts from a directory
# Arguments:
#   $1 - Directory path containing package .sh files
# Sources each .sh file and logs the loaded package name
load() {
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

# Install packages and their dependencies recursively
# Arguments:
#   $@ - Array of package names to install
# For each package:
#   1. Checks for get_<package>_dependencies function and installs dependencies first
#   2. Calls install_<package> function if it exists
install() {
    local array=("$@")

    local package
    for package in "${array[@]}"; do
        local function_name="get_${package}_dependencies"
        if function_exists "${function_name}"; then
            eval declare -a dependencies="\$(${function_name})"
            write_progress "Installing package dependencies for '${package}':"
            print_items_in_array "${dependencies[@]}"
            write_blank_line
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

# Uninstall packages
# Arguments:
#   $@ - Array of package names to uninstall
# Calls uninstall_<package> function for each package if it exists
uninstall() {
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

# Verify that package files exist in the packages directory
# Arguments:
#   $1 - Directory path to search for package files
#   $@ - Array of package names to verify
# Checks if <package>.sh file exists for each package
verify() {
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
