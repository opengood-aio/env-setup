install_git_together() {
    write_info "Installing Git Together package..."

    if ! hash git-author 2>/dev/null || ! hash git-together 2>/dev/null; then
        write_info "Enter Git user name (i.e. John Smith)..."
        read -r git_user_name
        write_blank_line

        write_info "Enter Git user email (i.e. user@domain.com)..."
        read -r git_user_email
        git_user_initials=$(left_chars "${git_user_email}" 2)
        write_blank_line

        write_info "Installing Git Author dependency..."
        brew list git-author &>/dev/null || brew install pivotal/tap/git-author
        write_success "Done!"

        write_info "Installing Git Together..."
        brew list git-together &>/dev/null || brew install pivotal/tap/git-together
        write_success "Done!"

        write_info "Configuring git-together in Bash profile...'"
        cat <<EOF >>"${bash_profile}"
# git-together alias
alias git=git-together

EOF

        source "${bash_profile}"
        write_success "Done!"
        write_blank_line

        write_info "Configuring global git-together configuration...'"
        cat <<EOF >>"${git_together}"
[git-together "authors"]
  $git_user_initials = "$git_user_name; $git_user_email"

EOF
        source "${bash_profile}"
        write_success "Done!"
    else
        write_progress "Git Together is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

uninstall_git_together() {
    write_info "Uninstalling Git Together package..."

    write_info "Uninstalling Git Author..."
    brew uninstall git-author || { write_warning "WARNING! Git Author is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling Git Together..."
    brew uninstall git-together || { write_warning "WARNING! Git Together is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
