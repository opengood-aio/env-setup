get_os_prefs_dependencies() {
    write_info "Getting macOS preferences package dependencies to install..."

    local dependencies=()
    dependencies+=("dockutil")

    local array
    array="$(declare -p dependencies)"
    local IFS=$'\v'
    echo "${array#*=}"
}

install_os_prefs() {
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

    write_info "Configuring Dock with custom application layout..."
    write_blank_line

    write_info "Removing all existing Dock items..."
    dockutil --list | awk -F\t '{print "dockutil --remove \""$1"\" --no-restart"}' | sh
    write_success "Done!"
    write_blank_line

    write_info "Adding applications to Dock..."

    # Productivity & Organization
    dockutil --add "${apps_dir}/AppGrid.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/1Password.app" --no-restart 2>/dev/null || true

    # Web Browsers
    dockutil --add /System/Applications/Safari.app --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Google Chrome.app" --no-restart 2>/dev/null || true

    # Communication & Productivity
    dockutil --add "${apps_dir}/Canary Mail.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/MacWhisper.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Obsidian.app" --no-restart 2>/dev/null || true
    dockutil --add /System/Applications/Notes.app --no-restart 2>/dev/null || true
    dockutil --add /System/Applications/Reminders.app --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Relog.app" --no-restart 2>/dev/null || true
    dockutil --add /System/Applications/Calendar.app --no-restart 2>/dev/null || true
    dockutil --add /System/Applications/Messages.app --no-restart 2>/dev/null || true

    # Development Tools
    dockutil --add "${apps_dir}/IntelliJ IDEA.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/PyCharm.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/iTerm.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Docker.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Orka Desktop.app" --no-restart 2>/dev/null || true

    # AI & Computing
    dockutil --add "${apps_dir}/Claude.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/ChatGPT.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Wolfram.app" --no-restart 2>/dev/null || true

    # File Utilities
    dockutil --add "${apps_dir}/GoodSync.app" --no-restart 2>/dev/null || true

    # Media & Entertainment
    dockutil --add /System/Applications/TV.app --no-restart 2>/dev/null || true
    dockutil --add /System/Applications/Music.app --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/QIDI Print.app" --no-restart 2>/dev/null || true
    dockutil --add /System/Applications/Photos.app --no-restart 2>/dev/null || true

    # Creative Tools
    dockutil --add "${apps_dir}/Canva.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/EaseUS Video Downloader.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Wondershare UniConverter 17.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Final Cut Pro.app" --no-restart 2>/dev/null || true

    # Device Management & Utilities
    dockutil --add "${apps_dir}/iMazing.app" --no-restart 2>/dev/null || true
    dockutil --add /System/Applications/Shortcuts.app --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/CleanMyMac.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Moonlock.app" --no-restart 2>/dev/null || true

    # Home & Location
    dockutil --add /System/Applications/Home.app --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/ControllerForHomeKit.app" --no-restart 2>/dev/null || true
    dockutil --add /System/Applications/FindMy.app --no-restart 2>/dev/null || true

    # Continuity & System
    dockutil --add /System/Applications/iPhone\ Mirroring.app --no-restart 2>/dev/null || true
    dockutil --add /System/Applications/Phone.app --no-restart 2>/dev/null || true
    dockutil --add /System/Applications/App\ Store.app --no-restart 2>/dev/null || true
    dockutil --add /System/Applications/System\ Settings.app 2>/dev/null || true

    write_success "Done!"
    write_blank_line
}

uninstall_os_prefs() {
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
