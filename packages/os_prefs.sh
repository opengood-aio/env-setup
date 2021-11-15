function get_os_prefs_dependencies() {
    write_info "Getting macOS preferences package dependencies to install..."

    local dependencies=()
    dependencies+=("dockutil")

    local array
    array="$(declare -p dependencies)"
    local IFS=$'\v'
    echo "${array#*=}"
}

function install_os_prefs() {
    write_info "Installing macOS preferences..."

    write_info "Setting macOS menu clock format..."
    write_info "http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns"
    defaults write com.apple.menuextra.clock "DateFormat" 'EEE MMM d  h:mm:ss a'
    killall SystemUIServer
    write_success "Done!"
    write_blank_line

    write_info "Setting auto-hide macOS Dock..."
    defaults write com.apple.dock autohide -bool true
    killall Dock
    write_success "Done!"
    write_blank_line

    write_info "Setting fast key repeat rates..."
    write_warning "NOTE: Requires reboot to take effect"
    defaults write -g KeyRepeat -int 1
    defaults write -g InitialKeyRepeat -int 15
    write_success "Done!"
    write_blank_line

    write_info "Setting Finder to display full path in title bar..."
    defaults write com.apple.finder '_FXShowPosixPathInTitle' -bool true
    write_success "Done!"
    write_blank_line

    write_info "Setting Photos to stop opening automatically..."
    defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
    write_success "Done!"
    write_blank_line

    write_info "Modifying appearance of Dock to remove standard icons and add custom icons..."
    curl https://raw.githubusercontent.com/kcrawford/dockutil/master/scripts/dockutil > "${downloads_dir}/dockutil"
    chmod a+rx,go-w "${downloads_dir}/dockutil"
    sudo mv "${downloads_dir}/dockutil" /usr/local/bin
    dockutil --list | awk -F\t '{print "dockutil --remove \""$1"\" --no-restart"}' | sh
    if dockutil --find Google\ Chrome | grep "was not found"; then dockutil --add "${apps_dir}"/Google\ Chrome.app --no-restart; fi
    if dockutil --find IntelliJ\ IDEA | grep "was not found"; then dockutil --add "${apps_dir}"/IntelliJ\ IDEA.app; fi
    if dockutil --find iTerm | grep "was not found"; then dockutil --add "${apps_dir}"/iTerm.app; fi
    write_success "Done!"
    write_blank_line
}

function uninstall_os_prefs() {
    write_info "Uninstalling macOS preferences..."

    write_info "Resetting macOS menu clock format..."
    defaults write com.apple.menuextra.clock "DateFormat" 'EEE h:mm a'
    killall SystemUIServer
    write_success "Done!"
    write_blank_line

    write_info "Resetting auto-hide macOS Dock..."
    defaults write com.apple.dock autohide -bool false
    killall Dock
    write_success "Done!"
    write_blank_line

    write_info "Resetting Finder to not display full path in title bar..."
    defaults write com.apple.finder '_FXShowPosixPathInTitle' -bool false
    write_success "Done!"
    write_blank_line

    write_info "Resetting Photos to opening automatically..."
    defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool false
    write_success "Done!"
    write_blank_line

    write_info "Resetting appearance of Dock to standard icons..."
    dockutil --list | awk -F\t '{print "dockutil --remove \""$1"\" --no-restart"}' | sh
    if dockutil --find App\ Store | grep "was not found"; then dockutil --add "${apps_dir}"/App\ Store.app; fi
    if dockutil --find System\ Preferences | grep "was not found"; then dockutil --add "${apps_dir}"/System\ Preferences.app; fi
    if dockutil --find Launchpad | grep "was not found"; then dockutil --add "${apps_dir}"/Launchpad.app; fi
    write_success "Done!"
    write_blank_line
}
