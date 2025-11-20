install_bash() {
    write_info "Installing Bash package..."

    if [[ ! -f "${bash_latest}" ]]; then
        write_info "Installing latest Bash version..."
        brew list bash &>/dev/null || brew install bash
        write_success "Done!"
        write_blank_line

        write_info "Displaying current Bash installations..."
        command -v "bash"
        write_success "Done!"
        write_blank_line

        write_info "Displaying installed Bash versions..."
        "${bash_latest}" --version
        "${bash_base}" --version
        write_success "Done!"
        write_blank_line

        write_info "Whitelisting new Bash installation to make it a trusted shell..."
        write_warning "Manually add '${bash_latest}' to '${shells}'"
        write_warning "Script will wait for 10 seconds before continuing to open ${shells}' in Vim..."
        sleep 10
        sudo vim "${shells}"
        write_success "Done!"
        write_blank_line

        write_info "Setting new Bash installation as default..."
        write_warning "Afterwards you will be prompted for your password to confirm new Bash installation as default"
        write_warning "NOTE: Requires terminal restart to take effect"
        chsh -s "${bash_latest}"
        sudo chsh -s "${bash_latest}"
        write_success "Done!"
        write_blank_line

        write_info "Exiting installation..."
        write_info "Please restart a new terminal to use new Bash installation"
        write_blank_line
        exit 0
    else
        write_progress "Bash is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

uninstall_bash() {
    write_info "Uninstalling Bash package..."

    write_info "Uninstalling latest Bash version..."
    brew uninstall bash || { write_warning "WARNING! Bash is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line

    write_info "Resetting prior Bash installation as default..."
    write_warning "NOTE: Requires terminal restart to take effect"
    #chsh -s "${bash_base}"
    #sudo chsh -s "${bash_base}"
    write_success "Done!"
    write_blank_line
}
