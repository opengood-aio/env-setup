if [[ $(command -v brew) != "" ]]; then
    test_brew_prefix="$(brew --prefix)"
    if test -f "${test_brew_prefix}/lib/bats-support/load.bash" && \
        test -f "${test_brew_prefix}/lib/bats-assert/load.bash"; then
        load "${test_brew_prefix}/lib/bats-support/load.bash"
        load "${test_brew_prefix}/lib/bats-assert/load.bash"
    else
        load "../node_modules/bats-support/load"
        load "../node_modules/bats-assert/load"
    fi
else
    load "../node_modules/bats-support/load"
    load "../node_modules/bats-assert/load"
fi

src_dir="${BATS_TEST_DIRNAME}/.."
tmp_dir="${BATS_TMPDIR}"

source "${src_dir}"/config/global.sh
source "${src_dir}"/config/io.sh
source "${src_dir}"/config/packages.sh
source "${src_dir}"/modules/colors.sh
source "${src_dir}"/modules/commons.sh

# BATS setup function - runs before each test
# Changes to the temporary directory for test isolation
setup() {
    test_cd_tmp_dir
}

# BATS teardown function - runs after each test
# Prints test output and returns to original directory
teardown() {
    echo "Output: '${output}'"

    test_cd_pop
}

# Append contents to an existing file
# Arguments:
#   $1 - File path
#   $2 - Contents to append
test_append_file_with_contents() {
    local file="$1"
    local contents="$2"

    echo "${contents}" >>"${file}"
}

# Pop the top directory from the directory stack
# Silences output and exits on failure
test_cd_pop() {
    popd >/dev/null || exit
}

# Push a directory onto the directory stack and change to it
# Arguments:
#   $1 - Directory path
# Silences output and exits on failure
test_cd_push() {
    local path="$1"
    pushd "${path}" >/dev/null || exit
}

# Change to the BATS temporary directory for test isolation
# Uses the $tmp_dir variable set in test setup
test_cd_tmp_dir() {
    test_cd_push "${tmp_dir}"
}

# Check if a string contains a substring (case-insensitive)
# Arguments:
#   $1 - String to search in
#   $2 - Substring to search for
# Returns: "true" if found, "false" otherwise
test_contains_string() {
    local string="$1"
    local search_string="$2"

    if echo "${string}" | grep -iqF "${search_string}"; then
        echo true
    else
        echo false
    fi
}

# Create a directory if it doesn't exist
# Arguments:
#   $1 - Directory path
# Creates parent directories as needed
test_create_dir() {
    local dir="$1"

    if [[ ! -d "${dir}" ]]; then
        mkdir -p "${dir}"
    fi
}

# Create an empty file if it doesn't exist
# Arguments:
#   $1 - File path
test_create_file() {
    local file="$1"

    if [[ ! -f "${file}" ]]; then
        touch "${file}"
    fi
}

# Create a file with specified contents
# Arguments:
#   $1 - File path
#   $2 - File contents
# Overwrites file if it already exists
test_create_file_with_contents() {
    local file="$1"
    local contents="$2"

    echo "${contents}" >"${file}"
}

# Remove a directory if it exists
# Arguments:
#   $1 - Directory path
# Recursively removes directory and all contents
test_remove_dir() {
    local dir="$1"

    if [[ -d "${dir}" ]]; then
        write_info "Removing directory '${dir}'"
        rm -rf "${dir}"
    fi
}

# Remove a file if it exists
# Arguments:
#   $1 - File path
test_remove_file() {
    local file="$1"

    if [[ -f "${file}" ]]; then
        write_info "Removing file '${file}'"
        rm -f "${file}"
    fi
}
