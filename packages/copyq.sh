install_copyq() {
    write_info "Installing CopyQ package..."

    if [[ ! -d "${apps_dir}/CopyQ.app" ]]; then
        write_info "Installing CopyQ..."
        brew list copyq &>/dev/null || brew install --cask copyq
        write_success "Done!"
        write_blank_line
    else
        write_progress "CopyQ is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

uninstall_copyq() {
    write_info "Uninstalling CopyQ package..."

    write_info "Uninstalling CopyQ..."
    brew uninstall --cask copyq || { write_warning "WARNING! CopyQ is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
