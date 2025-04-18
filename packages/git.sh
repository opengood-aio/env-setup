install_git() {
    write_info "Installing Git package..."

    if ! hash git 2>/dev/null; then
        write_info "Enter Git user name (i.e. John Smith)..."
        read -r git_user_name
        write_blank_line

        write_info "Enter Git user email (i.e. jsmith@users.noreply.github.com)..."
        read -r git_user_email
        write_blank_line

        write_info "Enter GitHub user name (i.e. jsmith)..."
        read -r github_user_name
        write_blank_line

        write_info "Enter GitHub access token (i.e. xcxcdt45tysfgfghty67tyhgghgsd544)..."
        local github_access_token
        github_access_token="$(read_password_input)"
        write_blank_line

        write_info "Enter GitHub GPG signing key (i.e. X9255HU3)..."
        local github_gpg_signing_key
        github_gpg_signing_key="$(read_password_input)"
        write_blank_line

        write_info "Installing Git..."
        brew list git &>/dev/null || brew install git
        write_success "Done!"
        write_blank_line

        write_info "Creating Git symlink..."
        sudo ln -s /opt/homebrew/bin/git /usr/local/bin/git
        write_success "Done!"
        write_blank_line

        write_info "Setting global Git configurations..."
        git config --global user.name "${git_user_name}"
        git config --global user.email "${git_user_email}"
        git config --global user.signingKey "${github_gpg_signing_key}"
        git config --global core.editor "${vim}"
        git config --global transfer.fsckobjects true
        git config --global pull.rebase true
        git config --global push.autoSetupRemote true
        git config --global commit.gpgSign true
        write_success "Done!"
        write_blank_line

        write_info "Installing Git completion..."
        if [[ ! -f "${git_completion}" ]]; then
            curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o "${git_completion}"
            chmod +x "${git_completion}"
        else
            write_info "Git completion installed..."
        fi
        write_success "Done!"
        write_blank_line

        write_info "Installing Git hooks..."
        if [[ ! -d "${git_hooks_dir}" ]]; then
            write_progress "Installing Git hooks for cred-alert"
            git clone https://github.com/pivotal-cf/git-hooks-core "${git_hooks_dir}"
            git config --global --add core.hooksPath "${git_hooks_dir}"
        else
            write_progress "Updating Git hooks for cred-alert"
            cd_push "${git_hooks_dir}"
            git checkout .
            git pull -r
            cd_pop
        fi
        write_success "Done!"
        write_blank_line

        write_info "Installing cred-alert..."
        if [[ ! -f "/usr/local/bin/cred-alert-cli" ]]; then
            os_name=$(uname | awk '{print tolower($1)}')
            cd_push "${downloads_dir}"
            curl -o cred-alert-cli https://s3.amazonaws.com/cred-alert/cli/current-release/cred-alert-cli_${os_name}
            chmod 755 cred-alert-cli
            sudo mkdir -p /usr/local/bin
            sudo mv cred-alert-cli /usr/local/bin
            cd_pop
        else
            write_info "cred-alert already installed..."
        fi
        write_success "Done!"
        write_blank_line

        write_info "Setting Git aliases..."
        git config --global alias.br branch
        git config --global alias.ci commit
        git config --global alias.cl clone
        git config --global alias.co checkout
        git config --global alias.di diff
        git config --global alias.m merge
        git config --global alias.ref reflog
        git config --global alias.st status
        git config --global alias.sta stash
        git config --global alias.stap stash pop
        git config --global alias.blog "log origin/main... --left-right"
        git config --global alias.ca "commit -a -m"
        git config --global alias.ds "diff --staged"
        git config --global alias.fixup "commit --fixup"
        git config --global alias.flog "log --pretty=fuller --decorate"
        git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
        git config --global alias.llog "log --date=local"
        git config --global alias.lol "log --graph --decorate --oneline"
        git config --global alias.lola "log --graph --decorate --oneline --all"
        git config --global alias.pl "pull -r"
        git config --global alias.ps "!git status && git add -A && git status && git commit -S -m \"$1\" && git pull -r && git push -u origin \"$(git symbolic-ref --short HEAD)\" && git status"
        git config --global alias.ra "rebase --abort"
        git config --global alias.rc "rebase --continue"
        git config --global alias.rum "rebase main@{u}"
        git config --global alias.squash "commit --squash"
        git config --global alias.unstage "reset HEAD"
        write_success "Done!"
        write_blank_line

        write_info "Setting bash-it aliases for Git..."
        if [[ ! -d ${bash_it_aliases}/enable ]]; then
            mkdir "${bash_it_aliases}"/enable
            echo "#Git" >>"${bash_it_aliases}"/general.aliases.bash
            echo "alias gst='git status'" >>"${bash_it_aliases}"/general.aliases.bash
        else
            write_info "bash-it aliases for Git already installed..."
        fi
        write_success "Done!"
        write_blank_line

        write_info "Configuring GitHub properties...'"
        cat <<EOF >>"${github_properties}"
github.user=$github_user_name
github.access.token=$github_access_token

EOF
        source "${bash_profile}"
        write_success "Done!"
    else
        write_progress "Git is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

uninstall_git() {
    write_info "Uninstalling Git package..."

    write_info "Uninstalling Git..."
    brew uninstall git || { write_warning "WARNING! Git is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling Git hooks..."
    rm -Rf "${workspace_dir}"/git-hooks-core

    write_info "Uninstalling cred-alert..."
    sudo rm -f /usr/local/bin/cred-alert-cli
    write_success "Done!"
    write_blank_line
}
