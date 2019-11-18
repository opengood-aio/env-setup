function install_cf() {
    write_info "Installing CF CLI package..."

    if ! hash cf 2>/dev/null ||
        ! hash bosh 2>/dev/null ||
        ! hash bbl 2>/dev/null; then

        write_info "Installing CloudFoundry Homebrew tap..."
        brew tap cloudfoundry/tap
        write_success "Done!"
        write_blank_line

        write_info "Installing CF CLI package..."
        brew list cf-cli &>/dev/null || brew install cf-cli
        write_success "Done!"
        write_blank_line

        write_info "Installing Bosh CLI and dependencies packages..."
        brew list bosh-cli &>/dev/null || brew install bosh-cli
        brew list bbl &>/dev/null || brew install bbl
        write_success "Done!"
        write_blank_line
    else
        write_progress "CF CLI is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

function uninstall_cf() {
    write_info "Uninstalling CF CLI package..."
    brew uninstall cf-cli || { write_warning "WARNING! CF CLI is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling Bosh CLI and dependencies packages..."
    brew uninstall bbl || { write_warning "WARNING! bbl is not installed and cannot be uninstalled. Continuing on."; }
    brew uninstall bosh-cli || { write_warning "WARNING! Bosh CLI is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
