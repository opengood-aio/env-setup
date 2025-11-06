get_json() {
    local object="$1"
    local path="$2"

    local json
    json=$(echo "${object}" | jq -r "${path}")
    echo "${json}"
}
