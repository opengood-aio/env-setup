#!/usr/bin/env bats

load test-helper

source "${src_dir}"/modules/parse.sh

@test "'get_json' extracts a simple string value from JSON object" {
    json='{"name":"John","age":30}'

    run get_json "${json}" ".name"

    [ "${status}" -eq 0 ]
    [ "${output}" = "John" ]
}

@test "'get_json' extracts a numeric value from JSON object" {
    json='{"name":"John","age":30}'

    run get_json "${json}" ".age"

    [ "${status}" -eq 0 ]
    [ "${output}" = "30" ]
}

@test "'get_json' extracts a nested value from JSON object" {
    json='{"person":{"name":"Jane","age":25}}'

    run get_json "${json}" ".person.name"

    [ "${status}" -eq 0 ]
    [ "${output}" = "Jane" ]
}

@test "'get_json' extracts an array element from JSON object" {
    json='{"items":["apple","banana","cherry"]}'

    run get_json "${json}" ".items[1]"

    [ "${status}" -eq 0 ]
    [ "${output}" = "banana" ]
}

@test "'get_json' extracts a value from nested array in JSON object" {
    json='{"users":[{"name":"Alice","id":1},{"name":"Bob","id":2}]}'

    run get_json "${json}" ".users[0].name"

    [ "${status}" -eq 0 ]
    [ "${output}" = "Alice" ]
}

@test "'get_json' extracts a boolean value from JSON object" {
    json='{"active":true,"verified":false}'

    run get_json "${json}" ".active"

    [ "${status}" -eq 0 ]
    [ "${output}" = "true" ]
}

@test "'get_json' extracts null value from JSON object" {
    json='{"name":"John","email":null}'

    run get_json "${json}" ".email"

    [ "${status}" -eq 0 ]
    [ "${output}" = "null" ]
}

@test "'get_json' returns empty string when path does not exist" {
    json='{"name":"John"}'

    run get_json "${json}" ".nonexistent"

    [ "${status}" -eq 0 ]
    [ "${output}" = "null" ]
}

@test "'get_json' handles JSON with special characters in values" {
    json='{"message":"Hello \"World\"","path":"/usr/bin"}'

    run get_json "${json}" ".message"

    [ "${status}" -eq 0 ]
    [ "${output}" = "Hello \"World\"" ]
}

@test "'get_json' extracts entire array from JSON object" {
    json='{"colors":["red","green","blue"]}'

    run get_json "${json}" ".colors"

    [ "${status}" -eq 0 ]
    [ "$(test_contains_string "${output}" "red")" = "true" ]
    [ "$(test_contains_string "${output}" "green")" = "true" ]
    [ "$(test_contains_string "${output}" "blue")" = "true" ]
}
