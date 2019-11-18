function cd_pop() {
    popd >/dev/null || exit
}

function cd_push() {
    local path="$1"
    pushd "${path}" >/dev/null || exit
}
