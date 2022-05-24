install_vim() {
    write_info "Installing Vim package..."

    write_info "Installing Vim..."
    brew list vim &>/dev/null || brew install vim
    write_success "Done!"
    write_blank_line

    write_info "Installing Vim configuration..."
    cd_push ~/
    if [[ ! -d "${vim_dir}" ]]; then
        git clone https://github.com/pivotal/vim-config "${vim_dir}"
        "${vim_dir}"/bin/install
    fi
    cd_pop
    write_success "Done!"
    write_blank_line
}

uninstall_vim() {
    write_info "Uninstalling Vim package..."

    write_info "Uninstalling Vim configuration..."
    rm -Rf "${vim_dir}"
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling Vim..."
    brew uninstall vim || { write_warning "WARNING! Vim is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
