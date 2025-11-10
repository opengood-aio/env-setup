# Check if an item exists in an array
# Arguments:
#   $1 - Item to search for
#   $@ - Array elements
# Returns: "true" if found, "false" otherwise
contains_item_in_array() {
    local item="$1"
    shift

    local contains=false
    for value; do
        if [[ "${value}" == "${item}" ]]; then
            contains=true
            break
        fi
    done

    echo "${contains}"
}

# Check if a string contains a substring (case-insensitive)
# Arguments:
#   $1 - String to search in
#   $2 - Substring to search for
# Returns: "true" if found, "false" otherwise
contains_string() {
    local string="$1"
    local search_string="$2"

    if echo "${string}" | grep -iqF "${search_string}"; then
        echo true
    else
        echo false
    fi
}

# Find the first line in a file that contains a search string
# Arguments:
#   $1 - File path
#   $2 - Search string
# Returns: The first matching line, or empty string if not found
find_string_in_file() {
    local file="$1"
    local search_string="$2"

    IFS=''
    local output
    local line
    while read -r line; do
        case ${line} in
        *${search_string}*)
            output="${line}"
            break
            ;;
        esac
    done <"${file}"
    unset line

    echo "${output}"
}

# Find all lines in a file that contain a search string
# Arguments:
#   $1 - File path
#   $2 - Search string
# Returns: Comma-separated list of matching lines
find_strings_in_file() {
    local file="$1"
    local search_string="$2"

    local output
    output=$(grep -R "${search_string}" "${file}" | sed 's/.*://' | tr '\n' ',')
    output=$(remove_trailing_char "${output}")
    echo "${output}"
}

# Find all lines in a file that contain a search string with line numbers
# Arguments:
#   $1 - File path
#   $2 - Search string
# Returns: Comma-separated list of "line_number:matching_line" entries
find_strings_and_line_numbers_in_file() {
    local file="$1"
    local search_string="$2"

    local output
    output=$(grep -n "${search_string}" "${file}" | tr '\n' ',')
    output=$(remove_trailing_char "${output}")
    echo "${output}"
}

# Check if a bash function exists
# Arguments:
#   $1 - Function name
# Returns: Exit code 0 if exists, 1 otherwise
function_exists() {
    local name="$1"
    declare -f -F "${name}" >/dev/null
    return $?
}

# Get the value following a specific argument in an array
# Arguments:
#   $1 - Argument to find
#   $@ - Array to search
# Returns: The value after the argument, or empty string if not found
get_arg_value() {
    local arg="$1"
    shift

    local value=""
    if [[ "$(contains_item_in_array "${arg}" "$@")" == "true" ]]; then
        local index
        index=$(get_array_item_index "${arg}" "$@")

        local offset_index=$((index + 1))
        value=$(get_array_item_value "${offset_index}" "$@")
    fi
    echo "${value}"
}

# Get the index of a value in an array
# Arguments:
#   $1 - Value to find
#   $@ - Array to search
# Returns: Zero-based index of the value, or empty if not found
get_array_item_index() {
    local value="$1"
    local array=("$@")

    local index
    local i
    for i in "${!array[@]}"; do
        if [[ "${array[$i]}" == "${value}" ]]; then
            index="${i}"
        fi
    done
    unset i

    echo "${index}"
}

# Get an array element by index
# Arguments:
#   $1 - Index (zero-based)
#   $@ - Array
# Returns: Value at the specified index
get_array_item_value() {
    local index="$1"
    local array=("$@")

    echo "${array[${index}]}"
}

# Get the number of elements in an array
# Arguments:
#   $@ - Array
# Returns: Integer count of array elements
get_array_length() {
    local array=("$@")
    echo ${#array[@]}
}

# Print all key-value pairs in an associative array (map)
# Arguments:
#   $1 - Name reference to associative array
# Output: Formatted list of "- key = value" or "None" if empty
print_entries_in_map() {
    local -n map=$1

    if [[ $(get_array_length "${map[@]}") -eq 0 ]]; then
        write_info "None"
    else
        local key
        for key in "${!map[@]}"; do
            write_info "- ${key} = ${map[$key]}"
        done
        unset key
    fi
}

# Print all items in an array
# Arguments:
#   $@ - Array elements
# Output: Formatted list of "- item" or "None" if empty
print_items_in_array() {
    local array=("$@")

    if [[ $(get_array_length "${array[@]}") -eq 0 ]]; then
        write_info "None"
        write_blank_line
    else
        local item
        for item in "${array[@]}"; do
            write_info "- ${item}"
        done
        unset item
    fi
}

# Read password input from user with masked display (asterisks)
# Supports backspace for corrections
# Returns: The entered password string
read_password_input() {
    unset password
    local password=""
    while IFS= read -r -s -n1 input; do
        [[ -z ${input} ]] && {
            printf '\n' >&2
            break
        }
        if [[ ${input} == $'\x7f' ]]; then
            [[ -n ${password} ]] && password=${password%?}
            printf '\b \b' >&2
        else
            password+=${input}
            printf '*' >&2
        fi
    done
    echo "${password}"
}

# Remove the first character from a string
# Arguments:
#   $1 - String to modify
# Returns: String with first character removed
remove_leading_char() {
    local string="$1"
    local value=${string#?}
    echo "${value}"
}

# Remove all special characters from a string (dash, underscore, plus, period, space)
# Arguments:
#   $1 - String to modify
# Returns: String with special characters removed
remove_special_chars() {
    local string="$1"

    local value
    value=$(echo "${string}" | sed 's/[-_+. ]//g')
    echo "${value}"
}

# Remove special characters from a string except periods
# Arguments:
#   $1 - String to modify
# Returns: String with special characters removed (except periods)
remove_special_chars_but_period() {
    local string="$1"

    local value
    value=$(echo "${string}" | sed 's/[-_+ ]//g')
    echo "${value}"
}

# Remove the last character from a string
# Arguments:
#   $1 - String to modify
# Returns: String with last character removed
remove_trailing_char() {
    local string="$1"
    local value=${string%?}
    echo "${value}"
}

# Remove all whitespace characters from a string
# Arguments:
#   $1 - String to modify
# Returns: String with spaces removed
remove_whitespace_chars() {
    local string="$1"

    local value
    value=$(echo "${string}" | sed 's/[ ]//g')
    echo "${value}"
}

# Replace [newline] placeholders with actual newline characters in a file
# Arguments:
#   $1 - File path to modify
# Note: Modifies file in place
replace_newline_placeholder_in_file() {
    local file="$1"
    sed -i '' $'s/\[newline\]/\\\n/g' "${file}"
}

# Replace special characters with dashes (underscore, plus, period, space)
# Arguments:
#   $1 - String to modify
# Returns: String with special characters replaced by dashes
replace_special_chars_with_dash() {
    local string="$1"

    local value
    value=$(echo "${string}" | sed 's/[_+. ]/-/g')
    echo "${value}"
}

# Replace special characters with spaces (dash, underscore, plus, period)
# Arguments:
#   $1 - String to modify
# Returns: String with special characters replaced by spaces
replace_special_chars_with_whitespace() {
    local string="$1"

    local value
    value=$(echo "${string}" | sed 's/[-_+.]/ /g')
    echo "${value}"
}

# Replace all occurrences of a string with another string
# Arguments:
#   $1 - Original string
#   $2 - Search string
#   $3 - Replacement string
# Returns: Modified string
replace_string() {
    local string="$1"
    local search_string="$2"
    local replace_string="$3"

    local value
    value=$(echo "${string}" | sed "s/${search_string}/${replace_string}/g")
    echo "${value}"
}

# Replace all occurrences of a string in a file
# Arguments:
#   $1 - File path
#   $2 - Search string
#   $3 - Replacement string
# Note: Modifies file in place and processes newline placeholders
replace_string_in_file() {
    local file="$1"
    local search_string="$2"
    local replace_string="$3"

    sed -i '' "s/${search_string}/${replace_string}/g" "${file}"
    replace_newline_placeholder_in_file "${file}"
}

# Convert a string to lowercase
# Arguments:
#   $1 - String to convert
# Returns: Lowercase version of the string
to_lower_case() {
    local string="$1"

    local value
    value=$(echo "${string}" | awk '{print tolower($0)}')
    echo "${value}"
}

# Convert a string to title case (first letter of each word capitalized)
# Arguments:
#   $1 - String to convert
# Returns: Title case version of the string
to_title_case() {
    local string="$1"

    local value
    value=$(echo "${string}" | perl -ane 'foreach $wrd ( @F ) { print ucfirst($wrd)." "; } print "\n" ; ')
    value=$(remove_trailing_char "${value}")
    echo "${value}"
}

# Convert a string to uppercase
# Arguments:
#   $1 - String to convert
# Returns: Uppercase version of the string
to_upper_case() {
    local string="$1"

    local value
    value=$(echo "${string}" | awk '{print toupper($0)}')
    echo "${value}"
}

# Write a blank line to stderr
write_blank_line() {
    echo "" 1>&2
}

# Write an error message in red color to stderr
# Arguments:
#   $1 - Error message to display
write_error() {
    local msg="$1"
    echo -e "${red_color}${msg}${no_color}" >&2
}

# Write an informational message in cyan color to stderr
# Arguments:
#   $1 - Info message to display
write_info() {
    local msg="$1"
    echo -e "${cyan_color}${msg}${no_color}" 1>&2
}

# Write a plain message to stderr (no color)
# Arguments:
#   $1 - Message to display
write_message() {
    local msg="$1"
    echo -e "${msg}" 1>&2
}

# Write a progress message in purple color to stderr
# Arguments:
#   $1 - Progress message to display
write_progress() {
    local msg="$1"
    echo -e "${purple_color}${msg}${no_color}" 1>&2
}

# Write a success message in green color to stderr
# Arguments:
#   $1 - Success message to display
write_success() {
    local msg="$1"
    echo -e "${green_color}${msg}${no_color}" 1>&2
}

# Write a warning message in yellow color to stderr
# Arguments:
#   $1 - Warning message to display
write_warning() {
    local msg="$1"
    echo -e "${yellow_color}${msg}${no_color}" 1>&2
}
