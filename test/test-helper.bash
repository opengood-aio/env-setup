src_dir="${BATS_TEST_DIRNAME}/.."
tmp_dir="${BATS_TMPDIR}"

source "${src_dir}"/config/properties.sh
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

function test_contains_string_in_file() {
    local file="$1"
    local search_string="$2"

    local count
    count=$(grep -q "${search_string}" "${file}" && echo $?)

    if [[ ${count} == 0 ]]; then
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

function test_find_string_in_file() {
    local file="$1"
    local search_string="$2"

    IFS=''
    local line
    while read -r line; do
        case ${line} in
        *${search_string}*)
            echo "${line}"
            break
            ;;
        esac
    done <"${file}"
    unset line
}

function test_find_value_in_file() {
    local file="$1"
    local search_string="$2"

    local value
    value=$(test_find_string_in_file "${file}" "${search_string}" | sed -e "s/${search_string}\=//g")
    echo "${value}"
}

function test_function_exists() {
    local name="$1"
    declare -f -F "${name}" >/dev/null
    return $?
}

function test_get_file_contents() {
    local file="$1"

    local output
    output=$(cat "${file}")
    echo "${output}"
}

function test_get_json() {
    local object="$1"
    local path="$2"

    local json
    json=$(echo "${object}" | jq -r "${path}")
    echo "${json}"
}

function test_get_json_from_yaml() {
    local file="$1"
    local path="$2"

    local json
    json=$(yq r "${file}" "${path}" -j)
    echo "${json}"
}

function test_get_yaml() {
    local file="$1"
    local path="$2"

    local yaml
    yaml=$(yq r "${file}" "${path}")
    echo "${yaml}"
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

function test_replace_string() {
    local string="$1"
    local search_string="$2"
    local replace_string="$3"

    local value
    value=$(echo "${string}" | sed "s/${search_string}/${replace_string}/g")
    echo "${value}"
}
