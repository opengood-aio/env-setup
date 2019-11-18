function delete_yaml() {
    local file="$1"
    local path="$2"
    yq d -i "${file}" "${path}"
}

function get_json() {
    local object="$1"
    local path="$2"
    local json=$(echo "${object}" | jq -r "${path}")
    echo "${json}"
}

function get_json_from_yaml() {
    local file="$1"
    local path="$2"
    local yaml=$(yq r "${file}" "${path}" -j)
    echo "${yaml}"
}

function get_yaml() {
    local file="$1"
    local path="$2"
    local yaml=$(yq r "${file}" "${path}")
    echo "${yaml}"
}

function set_yaml() {
    local file="$1"
    local path="$2"
    local value="$3"
    yq w -i "${file}" "${path}" "${value}"
}
