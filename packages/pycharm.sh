source "${setup_dir}"/modules/jetbrains.sh

get_pycharm_dependencies() {
    write_info "Getting JetBrains PyCharm package dependencies to install..."

    local dependencies=()
    dependencies+=("jq")

    local array
    array="$(declare -p dependencies)"
    local IFS=$'\v'
    echo "${array#*=}"
}

install_pycharm() {
    install_jetbrains_product "${jetbrains_py_charm_pro_product_code}" jetbrains_py_charm_plugins
}

uninstall_pycharm() {
    uninstall_jetbrains_product "${jetbrains_py_charm_pro_product_code}"
}
