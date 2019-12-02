#!/usr/bin/env bats

load test-helper

source "${src_dir}"/modules/package.sh

dir=dir

@test "'load' loads all packages" {
    test_create_dir "${dir}"

    cat <<EOF >>"${dir}/foo.sh"
function install_foo() {
    echo "package foo installed"
}

function uninstall_foo() {
    echo "package foo uninstalled"
}
EOF

    cat <<EOF >>"${dir}/bar.sh"
function install_bar() {
    echo "package bar installed"
}

function uninstall_bar() {
    echo "package bar uninstalled"
}
EOF

    run load "${dir}"

    [ "${status}" -eq 0 ]
    [ "$(test_contains_string "${output}" "Loaded package 'foo'")" = "true" ]
    [ "$(test_contains_string "${output}" "Loaded package 'bar'")" = "true" ]

    test_remove_dir "${dir}"
}

@test "'install' installs one package" {
    function install_foo() {
        echo "package foo installed"
    }

    packages=()
    packages+=("foo")

    run install "${packages[@]}"

    [ "${status}" -eq 0 ]
    [ "$(test_contains_string "${output}" "package foo installed")" = "true" ]
}

@test "'install' installs multiple packages" {
    function install_foo() {
        echo "package foo installed"
    }

    function install_bar() {
        echo "package bar installed"
    }

    packages=()
    packages+=("foo")
    packages+=("bar")

    run install "${packages[@]}"

    [ "${status}" -eq 0 ]
    [ "$(test_contains_string "${output}" "package foo installed")" = "true" ]
    [ "$(test_contains_string "${output}" "package bar installed")" = "true" ]
}

@test "'install' installs package dependencies and package" {
    function get_foo_dependencies() {
        local dependencies=()
        dependencies+=("bar")

        local array
        array="$(declare -p dependencies)"
        local IFS=$'\v'
        echo "${array#*=}"
    }

    function install_foo() {
        echo "package foo installed"
    }

    function install_bar() {
        echo "package bar installed"
    }

    packages=()
    packages+=("foo")

    run install "${packages[@]}"

    [ "${status}" -eq 0 ]
    [ "$(test_contains_string "${output}" "package bar installed")" = "true" ]
    [ "$(test_contains_string "${output}" "package foo installed")" = "true" ]
}

@test "'uninstall' uninstalls one package" {
    function uninstall_foo() {
        echo "package foo uninstalled"
    }

    packages=()
    packages+=("foo")

    run uninstall "${packages[@]}"

    [ "${status}" -eq 0 ]
    [ "$(test_contains_string "${output}" "package foo uninstalled")" = "true" ]
}

@test "'uninstall' uninstalls multiple packages" {
    function uninstall_foo() {
        echo "package foo uninstalled"
    }

    function uninstall_bar() {
        echo "package bar uninstalled"
    }

    packages=()
    packages+=("foo")
    packages+=("bar")

    run uninstall "${packages[@]}"

    [ "${status}" -eq 0 ]
    [ "$(test_contains_string "${output}" "package foo uninstalled")" = "true" ]
    [ "$(test_contains_string "${output}" "package bar uninstalled")" = "true" ]
}

@test "'verify' verifies all packages exist" {
    test_create_dir "${dir}"

    cat <<EOF >>"${dir}/foo.sh"
function install_foo() {
    echo "package foo installed"
}

function uninstall_foo() {
    echo "package foo uninstalled"
}
EOF

    cat <<EOF >>"${dir}/bar.sh"
function install_bar() {
    echo "package bar installed"
}

function uninstall_bar() {
    echo "package bar uninstalled"
}
EOF

    packages=()
    packages+=("foo")
    packages+=("bar")

    run verify "${dir}" "${packages[@]}"

    [ "${status}" -eq 0 ]
    [ "$(test_contains_string "${output}" "Verified package 'foo' is valid and exists")" = "true" ]
    [ "$(test_contains_string "${output}" "Verified package 'bar' is valid and exists")" = "true" ]

    test_remove_dir "${dir}"
}

@test "'verify' verifies packages exist and do not exist" {
    test_create_dir "${dir}"

    cat <<EOF >>"${dir}/foo.sh"
function install_foo() {
    echo "package foo installed"
}

function uninstall_foo() {
    echo "package foo uninstalled"
}
EOF

    packages=()
    packages+=("foo")
    packages+=("bar")

    run verify "${dir}" "${packages[@]}"

    [ "${status}" -eq 0 ]
    [ "$(test_contains_string "${output}" "Verified package 'foo' is valid and exists")" = "true" ]
    [ "$(test_contains_string "${output}" "WARNING! Package 'bar' not found")" = "true" ]

    test_remove_dir "${dir}"
}
