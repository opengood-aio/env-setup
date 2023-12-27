source "${setup_dir}"/modules/jetbrains.sh

get_pycharm_dependencies() {
    write_info "Getting JetBrains IntelliJ IDEA package dependencies to install..."

    local dependencies=()
    dependencies+=("jq")

    local array
    array="$(declare -p dependencies)"
    local IFS=$'\v'
    echo "${array#*=}"
}

install_pycharm() {
    install_jetbrains_product "${jetbrains_intellij_idea_ultimate_product_code}" jetbrains_intellij_idea_plugins
}

uninstall_pycharm() {
    uninstall_jetbrains_product "${jetbrains_intellij_idea_ultimate_product_code}"
}
