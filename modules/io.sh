# Pop the top directory from the directory stack and change to it
# Silences output and exits on failure
cd_pop() {
    popd >/dev/null || exit
}

# Push a directory onto the directory stack and change to it
# Arguments:
#   $1 - Path to directory
# Silences output and exits on failure
cd_push() {
    local path="$1"
    pushd "${path}" >/dev/null || exit
}
