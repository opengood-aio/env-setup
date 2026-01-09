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

    write_info "Setting auto-hide macOS Dock..."
    defaults write com.apple.dock autohide -bool true
    killall Dock
    write_success "Done!"
    write_blank_line

    write_info "Configuring Dock with custom applications layout..."
    write_blank_line

    write_info "Removing all Dock applications..."
    dockutil --remove all 2>/dev/null || true
    write_success "Done!"
    write_blank_line

    write_info "Adding custom applications to Dock..."

    # Organization
    dockutil --add "${apps_dir}/AppGrid.app" --no-restart 2>/dev/null || true
    dockutil --add '' --type small-spacer --after 'AppGrid' --no-restart 2>/dev/null || true

    dockutil --add "${apps_dir}/1Password.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Passwords.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/eero.app" --no-restart 2>/dev/null || true
    dockutil --add '' --type small-spacer --after 'eero' --no-restart 2>/dev/null || true

    # Web Browsers
    dockutil --add "${apps_dir}/Safari.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Google Chrome.app" --no-restart 2>/dev/null || true
    dockutil --add '' --type small-spacer --after 'Google Chrome' --no-restart 2>/dev/null || true

    # Email
    dockutil --add "${apps_dir}/Canary Mail.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Microsoft Outlook.app" --no-restart 2>/dev/null || true
    dockutil --add '' --type small-spacer --after 'Microsoft Outlook' --no-restart 2>/dev/null || true

    # Messaging & Video
    dockutil --add "${apps_dir}/Messages.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Microsoft Teams.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/FaceTime.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/zoom.us.app" --no-restart 2>/dev/null || true
    dockutil --add '' --type small-spacer --after 'zoom.us' --no-restart 2>/dev/null || true

    # Productivity
    dockutil --add "${apps_dir}/Obsidian.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Notes.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/MacWhisper.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Reminders.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Relog.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Calendar.app" --no-restart 2>/dev/null || true
    dockutil --add '' --type small-spacer --after 'Calendar' --no-restart 2>/dev/null || true

    # Software Engineering
    dockutil --add "${apps_dir}/IntelliJ IDEA.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/PyCharm.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/iTerm.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Docker.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Orka Desktop.app" --no-restart 2>/dev/null || true
    dockutil --add '' --type small-spacer --after 'Orka Desktop' --no-restart 2>/dev/null || true

    # AI & Computing
    dockutil --add "${apps_dir}/Claude.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Wolfram.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/QIDI Print.app" --no-restart 2>/dev/null || true
    dockutil --add '' --type small-spacer --after 'QIDI Print' --no-restart 2>/dev/null || true

    # File Sync and Backup
    dockutil --add "${apps_dir}/GoodSync.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/pCloud Drive.app" --no-restart 2>/dev/null || true
    dockutil --add '' --type small-spacer --after 'pCloud Drive' --no-restart 2>/dev/null || true

    # Entertainment
    dockutil --add "${apps_dir}/TV.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Music.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Photos.app" --no-restart 2>/dev/null || true
    dockutil --add '' --type small-spacer --after 'Photos' --no-restart 2>/dev/null || true

    # Creative
    dockutil --add "${apps_dir}/Canva.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Final Cut Pro.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/EaseUS Video Downloader.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Wondershare UniConverter 17.app" --no-restart 2>/dev/null || true
    dockutil --add '' --type small-spacer --after 'Wondershare UniConverter 17' --no-restart 2>/dev/null || true

    # System Management & Utilities
    dockutil --add "${apps_dir}/CleanMyMac_5.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Moonlock.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/iMazing.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/Shortcuts.app" --no-restart 2>/dev/null || true
    dockutil --add '' --type small-spacer --after 'Shortcuts' --no-restart 2>/dev/null || true

    # Home & Location
    dockutil --add "${apps_dir}/Home.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/ControllerForHomeKit.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/FindMy.app" --no-restart 2>/dev/null || true
    dockutil --add '' --type small-spacer --after 'FindMy' --no-restart 2>/dev/null || true

    # Continuity & System
    dockutil --add "${apps_dir}/Phone.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/iPhone Mirroring.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/App Store.app" --no-restart 2>/dev/null || true
    dockutil --add "${apps_dir}/System Settings.app" 2>/dev/null || true

    write_info "Refreshing Dock..."
    killall Dock
    write_blank_line

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

    write_info "Resetting Finder to not display full path in title bar..."
    defaults write com.apple.finder '_FXShowPosixPathInTitle' -bool false
    write_success "Done!"
    write_blank_line

    write_info "Resetting Photos to open automatically..."
    defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool false
    write_success "Done!"
    write_blank_line

    write_info "Resetting auto-hide macOS Dock..."
    defaults write com.apple.dock autohide -bool false
    killall Dock
    write_success "Done!"
    write_blank_line

    write_info "Resetting Dock to default applications layout..."
    dockutil --remove all 2>/dev/null || true
    if dockutil --find App\ Store | grep "was not found"; then dockutil --add "${apps_dir}"/App\ Store.app; fi
    if dockutil --find System\ Preferences | grep "was not found"; then dockutil --add "${apps_dir}"/System\ Preferences.app; fi
    killall Dock
    write_success "Done!"
    write_blank_line
}
