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

contains_string() {
    local string="$1"
    local search_string="$2"

    if echo "${string}" | grep -iqF "${search_string}"; then
        echo true
    else
        echo false
    fi
}

contains_string_in_file() {
    local file="$1"
    local search_string="$2"

    local count
    count=$(grep -o "${search_string}" "${file}" | wc -l)

    if [[ ${count} -gt 0 ]]; then
        echo true
    else
        echo false
    fi
}

create_dir() {
    local dir="$1"

    if [[ ! -d "${dir}" ]]; then
        mkdir -p "${dir}"
    fi
}

file_not_empty() {
    local file="$1"

    if [[ -f "${file}" ]] && [[ ! -s "${file}" ]]; then
        echo false
    else
        echo true
    fi
}

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

find_strings_in_file() {
    local file="$1"
    local search_string="$2"

    local output
    output=$(grep -R "${search_string}" "${file}" | sed 's/.*://' | tr '\n' ',')
    output=$(remove_trailing_char "${output}")
    echo "${output}"
}

find_strings_and_line_numbers_in_file() {
    local file="$1"
    local search_string="$2"

    local output
    output=$(grep -n "${search_string}" "${file}" | tr '\n' ',')
    output=$(remove_trailing_char "${output}")
    echo "${output}"
}

function_exists() {
    local name="$1"
    declare -f -F "${name}" >/dev/null
    return $?
}

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

get_array_item_value() {
    local index="$1"
    local array=("$@")

    echo "${array[${index}]}"
}

get_array_length() {
    local array=("$@")
    echo ${#array[@]}
}

get_count_of_leading_spaces_in_string() {
    local string="$1"

    local count
    count=$(echo "${string}" | awk -F'[^ \t]' '{print length($1)}')
    echo "${count}"
}

join_string() {
    local delimiter="$1"
    shift 1
    local array=("$@")

    local output
    output=$(
        IFS=${delimiter}
        echo "${array[*]}"
    )
    echo "${output}"
}

mask_string() {
    local string="$1"
    while read -r -n1 character; do
        value+="x"
    done < <(echo -n "${string}")
    echo "${value}"
}

left_chars() {
    local string="$1"
    local chars="$2"

    local value="${string:0:chars}"
    echo "${value}"
}

left_pad_string() {
    local string="$1"
    local pad_char="$2"
    local length="$3"

    local output=""
    while [[ ${#output} -ne ${length} ]]; do
        output+="${pad_char}"
    done

    output="${output}${string}"
    echo "${output}"
}

left_trim_occurrences() {
    local string="$1"
    local count="$2"

    local output
    output=$(echo "${string}" | cut -c "$((count + 1))"-)
    echo "${output}"
}

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

remove_leading_char() {
    local string="$1"
    local value=${string#?}
    echo "${value}"
}

remove_special_chars() {
    local string="$1"

    local value
    value=$(echo "${string}" | sed 's/[-_+. ]//g')
    echo "${value}"
}

remove_special_chars_but_period() {
    local string="$1"

    local value
    value=$(echo "${string}" | sed 's/[-_+ ]//g')
    echo "${value}"
}

remove_trailing_char() {
    local string="$1"
    local value=${string%?}
    echo "${value}"
}

remove_whitespace_chars() {
    local string="$1"

    local value
    value=$(echo "${string}" | sed 's/[ ]//g')
    echo "${value}"
}

replace_special_chars_with_dash() {
    local string="$1"

    local value
    value=$(echo "${string}" | sed 's/[_+. ]/-/g')
    echo "${value}"
}

replace_special_chars_with_whitespace() {
    local string="$1"

    local value
    value=$(echo "${string}" | sed 's/[-_+.]/ /g')
    echo "${value}"
}

replace_newline_placeholder_in_file() {
    local file="$1"
    sed -i '' $'s/\[newline\]/\\\n/g' "${file}"
}

replace_string() {
    local string="$1"
    local search_string="$2"
    local replace_string="$3"

    local value
    value=$(echo "${string}" | sed "s/${search_string}/${replace_string}/g")
    echo "${value}"
}

replace_string_in_file() {
    local file="$1"
    local search_string="$2"
    local replace_string="$3"

    sed -i '' "s/${search_string}/${replace_string}/g" "${file}"
    replace_newline_placeholder_in_file "${file}"
}

split_string_into_array() {
    local string="$1"
    local delimiter="$2"

    IFS="${delimiter}" read -ra items <<<"${string}"

    local array
    array="$(declare -p items)"
    local IFS=$'\v'
    echo "${array#*=}"
}

string_ends_with() {
    local string="$1"
    local character="$2"

    if [[ "${string: -1}" == "${character}" ]]; then
        echo true
    else
        echo false
    fi
}

string_starts_with() {
    local string="$1"
    local character="$2"

    if [[ "${string}" == ${character}* ]]; then
        echo true
    else
        echo false
    fi
}

to_lower_case() {
    local string="$1"

    local value
    value=$(echo "${string}" | awk '{print tolower($0)}')
    echo "${value}"
}

to_title_case() {
    local string="$1"

    local value
    value=$(echo "${string}" | perl -ane 'foreach $wrd ( @F ) { print ucfirst($wrd)." "; } print "\n" ; ')
    value=$(remove_trailing_char "${value}")
    echo "${value}"
}

to_upper_case() {
    local string="$1"

    local value
    value=$(echo "${string}" | awk '{print toupper($0)}')
    echo "${value}"
}

var_is_defined() {
    local name="$1"

    if [[ -n ${!name:-} ]]; then
        echo true
    else
        echo false
    fi
}

write_blank_line() {
    echo "" 1>&2
}

write_error() {
    local msg="$1"
    echo -e "${red_color}${msg}${no_color}" >&2
}

write_info() {
    local msg="$1"
    echo -e "${cyan_color}${msg}${no_color}" 1>&2
}

write_message() {
    local msg="$1"
    echo -e "${msg}" 1>&2
}

write_progress() {
    local msg="$1"
    echo -e "${purple_color}${msg}${no_color}" 1>&2
}

write_success() {
    local msg="$1"
    echo -e "${green_color}${msg}${no_color}" 1>&2
}

write_warning() {
    local msg="$1"
    echo -e "${yellow_color}${msg}${no_color}" 1>&2
}