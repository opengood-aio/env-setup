bash=/usr/local/bin/bash
old_bash=/bin/bash
shells_whitelist=/etc/shells

function install_bash() {
    write_info "Installing Bash package..."

    if [[ ! -f "${bash}" ]]; then
        write_info "Installing latest Bash package..."
        brew list bash &>/dev/null || brew install bash
        write_success "Done!"
        write_blank_line

        write_info "Displaying current Bash installations..."
        command -v "bash"
        write_success "Done!"
        write_blank_line

        write_info "Displaying installed Bash versions..."
        "${bash}" --version
        "${old_bash}" --version
        write_success "Done!"
        write_blank_line

        write_info "Whitelisting new Bash installation to make it a trusted shell..."
        write_warning "Manually add '${bash}' to '${shells_whitelist}'"
        write_warning "Script will wait for 5 seconds before continuing to open ${shells_whitelist}' in Vim..."
        sleep 5
        sudo vim "${shells_whitelist}"
        write_success "Done!"
        write_blank_line

        write_info "Setting new Bash installation as default..."
        write_warning "Afterwards you will be prompted for your password to confirm new Bash installation as default"
        write_warning "NOTE: Requires terminal restart to take effect"
        chsh -s "${bash}"
        sudo chsh -s "${bash}"
        write_success "Done!"
        write_blank_line
    else
        write_progress "Bash is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

function uninstall_bash() {
    write_info "Uninstalling Bash package..."

    brew uninstall bash || { write_warning "WARNING! Bash is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line

    write_info "Resetting prior Bash installation as default..."
    write_warning "NOTE: Requires terminal restart to take effect"
    chsh -s "${old_bash}"
    sudo chsh -s "${old_bash}"
    write_success "Done!"
    write_blank_line
}