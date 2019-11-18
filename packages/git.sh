function install_git() {
    write_info "Installing Git package..."
    
    if ! hash git 2>/dev/null ||
        ! hash git-together 2>/dev/null ||
        ! hash git-author 2>/dev/null ||
        ! hash vim 2>/dev/null; then

        write_info "Installing Git and associated packages..."
        brew list git &>/dev/null || brew install git
        brew list git-together &>/dev/null || brew install git-together
        brew list git-author &>/dev/null || brew install git-author
        brew list vim &>/dev/null || brew install vim
        write_success "Done!"
        write_blank_line

        write_info "Configuring global Git configurations..."
        git config --global core.editor /usr/local/bin/vim
        git config --global transfer.fsckobjects true
        write_success "Done!"
        write_blank_line

        write_info "Installing Git hooks..."
        hooks_dir=${workspace_dir}/git-hooks-core

        if [[ ! -d "${hooks_dir}" ]]; then
            write_progress "Installing git hooks for cred-alert"
            git clone https://github.com/pivotal-cf/git-hooks-core "${hooks_dir}"
            git config --global --add core.hooksPath "${hooks_dir}"
        else
            write_progress "Updating git hooks for cred-alert"
            cd_push "${hooks_dir}"
            git pull -r
            cd_pop
        fi
        write_success "Done!"
        write_blank_line

        if [[ ! -f "/usr/local/bin/cred-alert-cli" ]]; then
            write_info "Installing cred-alert..."
            os_name=$(uname | awk '{print tolower($1)}')
            cd_push "${downloads_dir}"
            curl -o cred-alert-cli https://s3.amazonaws.com/cred-alert/cli/current-release/cred-alert-cli_${os_name}
            chmod 755 cred-alert-cli
            mv cred-alert-cli /usr/local/bin
            cd_pop
            write_success "Done!"
            write_blank_line
        else
            write_info "cred-alert already installed..."
        fi

        write_info "Installing Git aliases..."
        git config --global alias.gst git status
        git config --global alias.st status
        git config --global alias.di diff
        git config --global alias.co checkout
        git config --global alias.cl clone
        git config --global alias.ci commit
        git config --global alias.br branch
        git config --global alias.ref reflog
        git config --global alias.sta stash
        git config --global alias.stap stash pop
        git config --global alias.ca "git commit -a -m"
        git config --global alias.llog "log --date=local"
        git config --global alias.flog "log --pretty=fuller --decorate"
        git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
        git config --global alias.lol "log --graph --decorate --oneline"
        git config --global alias.lola "log --graph --decorate --oneline --all"
        git config --global alias.blog "log origin/master... --left-right"
        git config --global alias.ds "diff --staged"
        git config --global alias.fixup "commit --fixup"
        git config --global alias.squash "commit --squash"
        git config --global alias.unstage "reset HEAD"
        git config --global alias.rum "rebase master@{u}"
        write_success "Done!"
        write_blank_line

        write_info "Installing bash-it aliases for Git..."
        if [[ ! -d ~/.bash_it/aliases/enable ]]; then
            bash_it_aliases=~/.bash_it/aliases/enable
            mkdir ${bash_it_aliases}
            echo "#Git" >> ${bash_it_aliases}/general.aliases.bash
            echo "alias gst='git status'" >> ${bash_it_aliases}/general.aliases.bash
            write_success "Done!"
            write_blank_line
        else
            write_info "Aliases already installed..."
        fi

        write_info "Installing Vim configuration..."
        cd_push ~/
        if [[ ! -d ~/.vim ]]; then
            git clone https://github.com/pivotal/vim-config ~/.vim
            ~/.vim/bin/install
        fi
        cd_pop
        write_success "Done!"
        write_blank_line

        write_info "Configuring Bash profile with git-together...'"
        echo "# git-together alias" >> "${bash_profile}"
        echo "alias git=git-together" >> "${bash_profile}"
        printf "\n" >> "${bash_profile}"
        source "${bash_profile}"
        write_success "Done!"
        write_blank_line
    else
        write_progress "Git and associated packages are already installed"
        write_success "Done!"
        write_blank_line
    fi
}

function uninstall_git() {
    write_info "Uninstalling Git package..."

    write_info "Uninstalling Git and associated packages..."
    brew uninstall git || { write_warning "WARNING! Git is not installed and cannot be uninstalled. Continuing on."; }
    brew uninstall git-together || { write_warning "WARNING! git-together is not installed and cannot be uninstalled. Continuing on."; }
    brew uninstall git-author || { write_warning "WARNING! git-author is not installed and cannot be uninstalled. Continuing on."; }
    brew uninstall vim || { write_warning "WARNING! Vim is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling Git hooks..."
    rm -Rf "${workspace_dir}"/git-hooks-core

    write_info "Uninstalling cred-alert..."
    sudo rm -f /usr/local/bin/cred-alert-cli
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling Vim configuration..."
    rm -Rf ~/.vim
    write_success "Done!"
    write_blank_line
}