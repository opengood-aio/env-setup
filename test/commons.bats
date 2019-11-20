#!/usr/bin/env bats

load test-helper

dir=dir
file=file.txt

@test "'contains_item_in_array' returns true when item contained in array" {
    array=()
    array+=("foo")
    array+=("bar")

    run contains_item_in_array "foo" "${array[@]}"

    [ "${status}" -eq 0 ]
    [ "${output}" = "true" ]
}

@test "'contains_item_in_array' returns false when item not contained in array" {
    array=()
    array+=("foo")

    run contains_item_in_array "bar" "${array[@]}"

    [ "${status}" -eq 0 ]
    [ "${output}" = "false" ]
}

@test "'contains_string' returns true when item contained in string" {
    run contains_string "foo bar" "foo"

    [ "${status}" -eq 0 ]
    [ "${output}" = "true" ]
}

@test "'contains_string' returns false when item not contained in string" {
    run contains_string "foo bar" "hello world"

    [ "${status}" -eq 0 ]
    [ "${output}" = "false" ]
}

@test "'contains_string_in_file' returns true when item contained in file" {
    test_create_file_with_contents "${file}" "foo bar"

    run contains_string_in_file "${file}" "foo"

    [ "${status}" -eq 0 ]
    [ "${output}" = "true" ]

    test_remove_file "${file}"
}

@test "'contains_string_in_file' returns false when item not contained in file" {
    test_create_file_with_contents "${file}" "bar"

    run contains_string_in_file "${file}" "foo"

    [ "${status}" -eq 0 ]
    [ "${output}" = "false" ]

    test_remove_file "${file}"
}

@test "'create_dir' creates directory when it does not exist" {
    run create_dir "${dir}"

    exists=$(if [[ -d "${dir}" ]]; then echo true; else false; fi)

    [ "${status}" -eq 0 ]
    [ "${output}" = "" ]
    [ "${exists}" = "true" ]

    test_remove_dir "${dir}"
}

@test "'file_not_empty' returns true when contents contained in file" {
    test_create_file_with_contents "${file}" "foo bar"

    run file_not_empty "${file}"

    [ "${status}" -eq 0 ]
    [ "${output}" = "true" ]

    test_remove_file "${file}"
}

@test "'file_not_empty' returns false when contents not contained in file" {
    test_create_file "${file}"

    run file_not_empty "${file}"

    [ "${status}" -eq 0 ]
    [ "${output}" = "false" ]

    test_remove_file "${file}"
}

@test "'find_string_in_file' returns item contained in file" {
    test_create_file_with_contents "${file}" "foo"
    test_append_file_with_contents "${file}" "bar"

    run find_string_in_file "${file}" "foo"

    [ "${status}" -eq 0 ]
    [ "${output}" = "foo" ]

    test_remove_file "${file}"
}

@test "'find_string_in_file' does not return item not contained in file" {
    test_create_file_with_contents "${file}" "bar"

    run find_string_in_file "${file}" "foo"

    [ "${status}" -eq 0 ]
    [ "${output}" = "" ]

    test_remove_file "${file}"
}

@test "'find_strings_in_file' returns items contained in file" {
    test_create_file_with_contents "${file}" "1+1"
    test_append_file_with_contents "${file}" "1+2"

    run find_strings_in_file "${file}" "1+"

    [ "${status}" -eq 0 ]
    [ "${output}" = "1+1,1+2" ]

    test_remove_file "${file}"
}

@test "'find_strings_in_file' does not return items not contained in file" {
    test_create_file_with_contents "${file}" "1+1"
    test_append_file_with_contents "${file}" "1+2"

    run find_strings_in_file "${file}" "3"

    [ "${status}" -eq 0 ]
    [ "${output}" = "" ]

    test_remove_file "${file}"
}

@test "'find_strings_and_line_numbers_in_file' returns items contained in file" {
    test_create_file_with_contents "${file}" "1+1"
    test_append_file_with_contents "${file}" "1+2"

    run find_strings_and_line_numbers_in_file "${file}" "1+"

    [ "${status}" -eq 0 ]
    [ "${output}" = "1:1+1,2:1+2" ]

    test_remove_file "${file}"
}

@test "'find_strings_and_line_numbers_in_file' does not return items not contained in file" {
    test_create_file_with_contents "${file}" "1+1"
    test_append_file_with_contents "${file}" "1+2"

    run find_strings_and_line_numbers_in_file "${file}" "3"

    [ "${status}" -eq 0 ]
    [ "${output}" = "" ]

    test_remove_file "${file}"
}

@test "'function_exists' returns true when function defined" {
    run function_exists "contains_string"

    [ "${status}" -eq 0 ]
}

@test "'function_exists' returns false when function not defined" {
    run function_exists "foo"

    [ "${status}" -ne 0 ]
}

@test "'get_arg_value' returns value of specified argument" {
    args=()
    args+=("-foo")
    args+=("bar")

    run get_arg_value "-foo" "${args[@]}"

    [ "${status}" -eq 0 ]
    [ "${output}" = "bar" ]
}

@test "'get_array_item_index' returns index of item in array" {
    array=()
    array+=("foo")
    array+=("bar")

    run get_array_item_index "foo" "${array[@]}"

    [ "${status}" -eq 0 ]
    [ "${output}" = "1" ]
}

@test "'get_array_item_index' returns invalid index of item in array when item not in array" {
    array=()
    array+=("foo")

    run get_array_item_index "bar" "${array[@]}"

    [ "${status}" -eq 0 ]
    [ "${output}" = "0" ]
}

@test "'get_array_item_value' returns item from array at specified index" {
    array=()
    array+=("foo")

    run get_array_item_value "1" "${array[@]}"

    [ "${status}" -eq 0 ]
    [ "${output}" = "foo" ]
}

@test "'get_array_length' returns length of array when items contained in array" {
    array=()
    array+=("foo")
    array+=("bar")

    run get_array_length "${array[@]}"

    [ "${status}" -eq 0 ]
    [ "${output}" = "2" ]
}

@test "'get_array_length' returns length of array when no items contained in array" {
    array=()

    run get_array_length "${array[@]}"

    [ "${status}" -eq 0 ]
    [ "${output}" = "0" ]
}

@test "'get_count_of_leading_spaces_in_string' returns count of lead spaces in string when leading spaces exist in string" {
    run get_count_of_leading_spaces_in_string "   Hello World!"

    [ "${status}" -eq 0 ]
    [ "${output}" = "3" ]
}

@test "'get_count_of_leading_spaces_in_string' returns count of lead spaces in string when no leading spaces exist in string" {
    run get_count_of_leading_spaces_in_string "Hello World!"

    [ "${status}" -eq 0 ]
    [ "${output}" = "0" ]
}

@test "'join_string' returns concatenated string of items contained in array with specified delimiter when items exists in array" {
    array=()
    array+=("foo")
    array+=("bar")

    run join_string "," "${array[@]}"

    [ "${status}" -eq 0 ]
    [ "${output}" = "foo,bar" ]
}

@test "'join_string' returns empty string of items without specified delimiter when no items exist in array" {
    array=()

    run join_string "," "${array[@]}"

    [ "${status}" -eq 0 ]
    [ "${output}" = "" ]
}

@test "'left_pad_string' returns string left padded with specified character" {
    run left_pad_string "Hello World!" " " "5"

    [ "${status}" -eq 0 ]
    [ "${output}" = "     Hello World!" ]
}

@test "'left_trim_occurrences' returns string left trimmed of specified number of characeters" {
    run left_trim_occurrences "     Hello World!" "5"

    [ "${status}" -eq 0 ]
    [ "${output}" = "Hello World!" ]
}

@test "'print_items_in_array' outputs list of items in array" {
    write_info() {
        local msg="$1"
        echo "\\${msg}"
    }

    array=()
    array+=("foo")
    array+=("bar")

    run print_items_in_array "${array[@]}"

    [ "${status}" -eq 0 ]
    [ "$(test_contains_string "${output}" "\- foo")" = "true" ]
    [ "$(test_contains_string "${output}" "\- bar")" = "true" ]
}

@test "'print_items_in_array' does not output list of items in array when no items contained in array" {
    array=()

    run print_items_in_array "${array[@]}"

    [ "${status}" -eq 0 ]
    [ "${output}" = "" ]
}

@test "'remove_leading_char' removes first character in string and returns modified string" {
    run remove_leading_char "Hello World!"

    [ "${status}" -eq 0 ]
    [ "${output}" = "ello World!" ]
}

@test "'remove_special_chars' removes special characters from string and returns modified string" {
    run remove_special_chars "Hello-_+. World!"

    [ "${status}" -eq 0 ]
    [ "${output}" = "HelloWorld!" ]
}

@test "'remove_special_chars_but_period' removes special characters except period from string and returns modified string" {
    run remove_special_chars_but_period "Hello-_+. World!"

    [ "${status}" -eq 0 ]
    [ "${output}" = "Hello.World!" ]
}

@test "'remove_trailing_char' removes removes first character in string and returns modified string" {
    run remove_trailing_char "Hello World!"

    [ "${status}" -eq 0 ]
    [ "${output}" = "Hello World" ]
}

@test "'remove_whitespace_chars' removes removes spaces from string and returns modified string" {
    run remove_whitespace_chars "Hello  World!"

    [ "${status}" -eq 0 ]
    [ "${output}" = "HelloWorld!" ]
}

@test "'replace_special_chars_with_dash' replaces special characters with dash in string and returns modified string" {
    run replace_special_chars_with_dash "Hello_+. World!"

    [ "${status}" -eq 0 ]
    [ "${output}" = "Hello----World!" ]
}

@test "'replace_special_chars_with_whitespace' replaces special characters with dash in string and returns modified string" {
    run replace_special_chars_with_whitespace "Hello_+. World!"

    [ "${status}" -eq 0 ]
    [ "${output}" = "Hello    World!" ]
}

@test "'replace_string' replaces search substring with replacement substring in string and returns modified string" {
    run replace_string "Hello+World!" "+" " "

    [ "${status}" -eq 0 ]
    [ "${output}" = "Hello World!" ]
}

@test "'split_string_into_array' splits string into array using specified delimiter" {
    write_info() {
        local msg="$1"
        echo "\\${msg}"
    }

    eval declare -a array="$(split_string_into_array "foo,bar" ',')"

    run print_items_in_array "${array[@]}"

    [ "${status}" -eq 0 ]
    [ "$(test_contains_string "${output}" "\- foo")" = "true" ]
    [ "$(test_contains_string "${output}" "\- bar")" = "true" ]
}

@test "'split_string_into_array' does not split string into array when string is empty" {
    eval declare -a array="$(split_string_into_array "" ',')"

    run print_items_in_array "${array[@]}"

    [ "${status}" -eq 0 ]
    [ "$(test_contains_string "${output}" "")" = "true" ]
}

@test "'string_ends_with' returns true when string ends in specified character" {
    run string_ends_with "Hello World!" "!"

    [ "${status}" -eq 0 ]
    [ "${output}" = "true" ]
}

@test "'string_ends_with' returns false when string does not end in specified character" {
    run string_ends_with "Hello World!" "d"

    [ "${status}" -eq 0 ]
    [ "${output}" = "false" ]
}

@test "'string_starts_with' returns true when string starts in specified character" {
    run string_starts_with "Hello World!" "H"

    [ "${status}" -eq 0 ]
    [ "${output}" = "true" ]
}

@test "'string_starts_with' returns false when string does not start in specified character" {
    run string_starts_with "Hello World!" "e"

    [ "${status}" -eq 0 ]
    [ "${output}" = "false" ]
}

@test "'to_lower_case' lower cases string and returns modified string" {
    run to_lower_case "HELLO WORLD!"

    [ "${status}" -eq 0 ]
    [ "${output}" = "hello world!" ]
}

@test "'to_title_case' title cases string and returns modified string" {
    run to_title_case "hello world!"

    [ "${status}" -eq 0 ]
    [ "${output}" = "Hello World!" ]
}

@test "'to_upper_case' lower cases string and returns modified string" {
    run to_upper_case "hello world!"

    [ "${status}" -eq 0 ]
    [ "${output}" = "HELLO WORLD!" ]
}

@test "'var_is_defined' returns true when variable is defined" {
    test="foo"

    run var_is_defined "test"

    [ "${status}" -eq 0 ]
    [ "${output}" = "true" ]
}

@test "'var_is_defined' returns false when variable is not defined" {
    run var_is_defined "test"

    [ "${status}" -eq 0 ]
    [ "${output}" = "false" ]
}

@test "'write_blank_line' writes blank line to standard output" {
    run write_blank_line

    contains_msg=$(contains_string "${output}", "")

    [ "${status}" -eq 0 ]
    [ "${contains_msg}" = "true" ]
}

@test "'write_error' writes error message to standard output" {
    run write_error "Error"

    contains_msg=$(contains_string "${output}", "Error")

    [ "${status}" -eq 0 ]
    [ "${contains_msg}" = "true" ]
}

@test "'write_info' writes information message to standard output" {
    run write_info "Info"

    contains_msg=$(contains_string "${output}", "Info")

    [ "${status}" -eq 0 ]
    [ "${contains_msg}" = "true" ]
}

@test "'write_message' writes message to standard output" {
    run write_message "Message"

    contains_msg=$(contains_string "${output}", "Message")

    [ "${status}" -eq 0 ]
    [ "${contains_msg}" = "true" ]
}

@test "'write_progress' writes progress message to standard output" {
    run write_progress "Progress"

    contains_msg=$(contains_string "${output}", "Progress")

    [ "${status}" -eq 0 ]
    [ "${contains_msg}" = "true" ]
}

@test "'write_success' writes success message to standard output" {
    run write_success "Success"

    contains_msg=$(contains_string "${output}", "Success")

    [ "${status}" -eq 0 ]
    [ "${contains_msg}" = "true" ]
}

@test "'write_warning' writes warning message to standard output" {
    run write_warning "Warning"

    contains_msg=$(contains_string "${output}", "Warning")

    [ "${status}" -eq 0 ]
    [ "${contains_msg}" = "true" ]
}
