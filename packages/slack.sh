function install_slack() {
    write_info "Installing Slack package..."
    if [[ ! -d "/Applications/Slack.app" ]]; then brew cask install slack; else write_progress "Slack already installed"; fi
    write_success "Done!"
    write_blank_line
}

function uninstall_slack() {
    write_info "Uninstalling Slack package..."
    brew cask uninstall slack || { write_warning "WARNING! Slack is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
