function install_git() {
    write_info "Installing Git package..."

    if ! hash git 2>/dev/null ||
#        ! hash git-together 2>/dev/null ||
#        ! hash git-author 2>/dev/null ||
        ! hash vim 2>/dev/null; then

        write_info "Enter Git user name (i.e. John Smith)..."
        read -r git_user_name
        write_blank_line

        write_info "Enter Git user email (i.e. user@domain.com)..."
        read -r git_user_email
#        git_user_initials=$(left_chars "${git_user_email}" 2)
        write_blank_line

        write_info "Enter GitHub user name (i.e. jsmith)..."
        read -r github_user_name
        write_blank_line

        write_info "Enter GitHub access token (i.e. xcxcdt45tysfgfghty67tyhgghgsd544)..."
        local github_access_token
        github_access_token="$(read_password_input)"
        write_blank_line

        write_info "Installing Git..."
        brew list git &>/dev/null || brew install git
        write_success "Done!"
        write_blank_line

        write_info "Creating Git symlink..."
        sudo ln -s /opt/homebrew/bin/git /usr/local/bin/git
        write_success "Done!"
        write_blank_line

        write_info "Installing Git dependencies..."
#        brew list git-together &>/dev/null || brew install pivotal/tap/git-together
#        brew list git-author &>/dev/null || brew install pivotal/tap/git-author
        brew list vim &>/dev/null || brew install vim
        write_success "Done!"
        write_blank_line

        write_info "Setting global Git configurations..."
        git config --global user.name "${git_user_name}"
        git config --global user.email "${git_user_email}"
        git config --global core.editor /usr/local/bin/vim
        git config --global transfer.fsckobjects true
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
        git config --global alias.gtg "git config --global --add include.path ~/.git-together"
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

        write_info "Installing Vim configuration..."
        cd_push ~/
        if [[ ! -d ~/.vim ]]; then
            git clone https://github.com/pivotal/vim-config ~/.vim
            ~/.vim/bin/install
        fi
        cd_pop
        write_success "Done!"
        write_blank_line

#        write_info "Configuring Bash profile with git-together...'"
#        cat <<EOF >>"${bash_profile}"
## git-together alias
#alias git=git-together
#
#EOF
#
#        source "${bash_profile}"
#        write_success "Done!"
#        write_blank_line

#        write_info "Configuring global git-together configuration...'"
#        cat <<EOF >>"${git_together}"
#[git-together "authors"]
#  $git_user_initials = "$git_user_name; $git_user_email"
#
#EOF
#        source "${bash_profile}"
#        write_success "Done!"
#        write_blank_line

        write_info "Configuring GitHub properties...'"
        cat <<EOF >>"${github_properties}"
github.user=$github_user_name
github.access.token=$github_access_token

EOF
        source "${bash_profile}"
        write_success "Done!"
        write_blank_line

        write_info "Configuring Git commands line functions in Bash profile...'"
        cat <<EOF >>"${bash_profile}"
function git-push() {
    git st
    ktlint -F "src/**/*.kt"
    git add .
    git st
    git ci -m "$1"
    git pull -r
    git push
    git st
}

function git-release() {
    git ci --allow-empty -m "Create release"
    git push
}

function git-deploy() {
    git ci --allow-empty -m "Deploy $1 $2"
    git push
}
EOF
        source "${bash_profile}"
        write_success "Done!"
    else
        write_progress "Git are already installed"
        write_success "Done!"
        write_blank_line
    fi
}

function uninstall_git() {
    write_info "Uninstalling Git package..."

    write_info "Uninstalling Git..."
    brew uninstall git || { write_warning "WARNING! Git is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling Git dependencies..."
    brew uninstall git-author || { write_warning "WARNING! git-author is not installed and cannot be uninstalled. Continuing on."; }
    brew uninstall git-together || { write_warning "WARNING! git-together is not installed and cannot be uninstalled. Continuing on."; }
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
