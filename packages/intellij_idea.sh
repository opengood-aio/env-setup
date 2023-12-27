source "${setup_dir}"/modules/jetbrains.sh

get_intellij_idea_dependencies() {
    write_info "Getting JetBrains IntelliJ IDEA package dependencies to install..."

    local dependencies=()
    dependencies+=("jq")

    local array
    array="$(declare -p dependencies)"
    local IFS=$'\v'
    echo "${array#*=}"
}

install_intellij_idea() {
    install_jetbrains_product "${jetbrains_intellij_idea_ultimate_product_code}" jetbrains_intellij_idea_plugins
}

uninstall_intellij_idea() {
    uninstall_jetbrains_product "${jetbrains_intellij_idea_ultimate_product_code}"
}
