if hash brew 2>/dev/null; then
    test_brew_prefix="$(brew --prefix)"
    load "${test_brew_prefix}/lib/bats-support/load.bash"
    load "${test_brew_prefix}/lib/bats-assert/load.bash"
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

setup() {
    test_cd_tmp_dir
}

teardown() {
    echo "Output: '${output}'"

    test_cd_pop
}

function test_append_file_with_contents() {
    local file="$1"
    local contents="$2"

    echo "${contents}" >>"${file}"
}

function test_cd_pop() {
    popd >/dev/null || exit
}

function test_cd_push() {
    local path="$1"
    pushd "${path}" >/dev/null || exit
}

function test_cd_tmp_dir() {
    test_cd_push "${tmp_dir}"
}

function test_contains_string() {
    local string="$1"
    local search_string="$2"

    if echo "${string}" | grep -iqF "${search_string}"; then
        echo true
    else
        echo false
    fi
}

function test_create_dir() {
    local dir="$1"

    if [[ ! -d "${dir}" ]]; then
        mkdir -p "${dir}"
    fi
}

function test_create_file() {
    local file="$1"

    if [[ ! -f "${file}" ]]; then
        touch "${file}"
    fi
}

function test_create_file_with_contents() {
    local file="$1"
    local contents="$2"

    echo "${contents}" >"${file}"
}

function test_remove_dir() {
    local dir="$1"

    if [[ -d "${dir}" ]]; then
        write_info "Removing directory '${dir}'"
        rm -rf "${dir}"
    fi
}

function test_remove_file() {
    local file="$1"

    if [[ -f "${file}" ]]; then
        write_info "Removing file '${file}'"
        rm -f "${file}"
    fi
}
