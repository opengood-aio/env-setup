# Extract a value from a JSON object using jq
# Arguments:
#   $1 - JSON object string
#   $2 - jq path (e.g., ".field", ".array[0].property")
# Returns: The extracted value as raw text (using jq -r)
# Requires: jq command-line JSON processor
get_json() {
    local object="$1"
    local path="$2"

    local json
    json=$(echo "${object}" | jq -r "${path}")
    echo "${json}"
}
