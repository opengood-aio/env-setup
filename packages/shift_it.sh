install_shift_it() {
    write_info "Installing ShiftIt package..."

    if [[ ! -d "${apps_dir}/ShiftIt.app" ]]; then
        write_info "Installing ShiftIt..."
        brew list shiftit &>/dev/null || brew install shiftit
        write_success "Done!"
        write_blank_line

        write_info "Configuring ShiftIt to select 1/3 screen width, 1/2 screen width and 2/3 screen width..."
        defaults write org.shiftitapp.ShiftIt multipleActionsCycleWindowSizes YES
        write_success "Done!"
        write_blank_line

        write_info "Configuring ShiftIt..."
        open "${apps_dir}"/ShiftIt.app
        write_success "Done!"
        write_blank_line
    else
        write_info "ShiftIt is already installed..."
        write_success "Done!"
        write_blank_line
    fi
}

uninstall_shift_it() {
    write_info "Uninstalling ShiftIt package..."

    write_info "Uninstalling ShiftIt..."
    brew uninstall shiftit || { write_warning "WARNING! ShiftIt is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
