install_sublime_text() {
    write_info "Installing Sublime Text package..."

    if [[ ! -d "${apps_dir}/Sublime Text.app" ]]; then
        write_info "Installing Sublime Text..."
        brew install --cask sublime-text
        write_success "Done!"
        write_blank_line
    else
        write_progress "Sublime Text is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

uninstall_sublime_text() {
    write_info "Uninstalling Sublime Text package..."

    write_info "Uninstalling Sublime Text..."
    brew uninstall --cask sublime-text || { write_warning "WARNING! Sublime Text is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
