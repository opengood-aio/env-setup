function install_slack() {
    write_info "Installing Slack package..."

    if [[ ! -d "/Applications/Slack.app" ]]; then
        write_info "Installing Slack..."
        brew cask install slack
        write_success "Done!"
        write_blank_line
    else
        write_progress "Slack already installed"
        write_success "Done!"
        write_blank_line
    fi
}

function uninstall_slack() {
    write_info "Uninstalling Slack package..."

    write_info "Uninstalling Slack..."
    brew cask uninstall slack || { write_warning "WARNING! Slack is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
