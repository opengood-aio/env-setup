function install_homebrew() {
    write_info "Installing Homebrew package..."

    if ! hash brew 2>/dev/null; then
        write_info "Installing Homebrew..."
        yes '' | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        write_success "Done!"
        write_blank_line

        write_info "Configuring Homebrew path in shell profiles and initial working directory..."
        cat <<EOF >>"${bash_profile}"

# Homebrew path
eval "\$(/opt/homebrew/bin/brew shellenv)"

# set initial working directory
cd ~/workspace

EOF

        cat <<EOF >>"${zsh_profile}"

# Homebrew path
eval "\$(/opt/homebrew/bin/brew shellenv)"

# set initial working directory
cd ~/workspace

EOF
        source "${bash_profile}"
        source "${zsh_profile}"
        write_success "Done!"
        write_blank_line

        write_info "Verifying Homebrew is up-to-date..."
        brew update
        write_success "Done!"
        write_blank_line

        write_info "Ensuring Homebrew directory is writable..."
        sudo chown -Rf $(whoami) $(brew --prefix)/*
        write_success "Done!"
        write_blank_line

        write_info "Installing Homebrew taps..."
        brew tap homebrew/services
        brew tap homebrew/cask
        write_success "Done!"
        write_blank_line

        write_info "Upgrading existing brews..."
        brew upgrade
        write_success "Done!"
        write_blank_line

        echo "Cleaning up Homebrew installation..."
        brew cleanup
        write_success "Done!"
        write_blank_line
    else
        write_progress "Homebrew is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

function uninstall_homebrew() {
    write_info "Uninstalling Homebrew package..."

    if hash brew 2>/dev/null; then
        write_info "Uninstalling Homebrew..."
        yes '' | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
        write_success "Done!"
        write_blank_line
    else
        write_warning "Homebrew is not installed and cannot be uninstalled. Continuing on..."
        write_success "Done!"
        write_blank_line
    fi
}
