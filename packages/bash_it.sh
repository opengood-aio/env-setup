install_bash_it() {
    write_info "Installing bash-it package..."

    if [[ ! -d "${bash_it_dir}" ]]; then
        write_info "Configuring Bash with bash-it..."
        write_info "Installing bash-it dependencies..."
        brew list coreutils &>/dev/null || brew install coreutils
        brew list grc &>/dev/null || brew install grc
        brew list rbenv &>/dev/null || brew install rbenv
        brew list watch &>/dev/null || brew install watch
        write_success "Done!"
        write_blank_line

        write_info "Installing Bash 'Solarized Dark' color theme..."
        cp "${resources_dir}/dircolors.ansi-dark" ~/.dircolors
        write_success "Done!"
        write_blank_line

        write_info "Installing Bash 'inputrc' configuration..."
        cp "${resources_dir}/.inputrc" ~/.inputrc
        write_success "Done!"
        write_blank_line

        write_info "Downloading bash-it..."
        git clone https://github.com/Bash-it/bash-it ${bash_it_dir}
        write_success "Done!"
        write_blank_line

        write_info "Installing Bobby Bash theme..."
        cp "${resources_dir}/bobby.theme.bash" ${bash_it_dir}/themes/bobby/bobby.theme.bash
        write_success "Done!"
        write_blank_line

        write_info "Installing bash-it..."
        "${bash_it_dir}"/install.sh --silent
        write_success "Done!"
        write_blank_line

        write_info "Sourcing Bash profile and bash-it..."
        export BASH_IT=${bash_it_dir}
        source ${bash_rc}
        source ${bash_profile}
        source ${bash_it_dir}/bash_it.sh
        write_success "Done!"
        write_blank_line

        write_info "Enabling Bash parameter completion for Git and SSH..."
        bash-it enable completion git
        bash-it enable completion ssh
        write_success "Done!"
        write_blank_line

        write_info "Enabling plugins for SSH and rbenv..."
        bash-it enable plugin ssh
        bash-it enable plugin rbenv
        write_success "Done!"
        write_blank_line

        write_info "Configuring direnv with bash-it..."
        brew list direnv &>/dev/null || brew install direnv
        cp "${resources_dir}/direnv.bash" "${bash_it_dir}"/custom/direnv.bash
        write_success "Done!"
        write_blank_line
    else
        write_progress "bash-it is already installed..."
        write_success "Done!"
        write_blank_line
    fi
}

uninstall_bash_it() {
    write_info "Uninstalling bash-it package..."

    write_info "Uninstalling bash-it dependencies..."
    brew uninstall coreutils || { write_warning "WARNING! coreutils is not installed and cannot be uninstalled. Continuing on."; }
    brew uninstall grc || { write_warning "WARNING! grc is not installed and cannot be uninstalled. Continuing on."; }
    brew uninstall rbenv || { write_warning "WARNING! rbenv is not installed and cannot be uninstalled. Continuing on."; }
    brew uninstall watch || { write_warning "WARNING! watch is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling Bash 'Solarized Dark' color theme..."
    rm -f ~/.dircolors
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling Bash 'inputrc' configuration..."
    rm -f ~/.inputrc
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling bash-it..."
    rm -Rf "${bash_it_dir}"
    write_success "Done!"
    write_blank_line

    write_info "Removing Bash profile..."
    rm -f "${bash_profile}"
    write_success "Done!"
    write_blank_line
}
