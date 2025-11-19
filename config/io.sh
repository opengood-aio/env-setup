# macOS system directories
apps_dir=/Applications
downloads_dir=~/Downloads
library_dir=~/Library
volumes_dir=/Volumes

# macOS user library directories
app_support_dir="${library_dir}/Application Support"
caches_dir=${library_dir}/Caches
containers_dir=${library_dir}/Containers
logs_dir=${library_dir}/Logs
preferences_dir=${library_dir}/Preferences
startup_items_dir=${library_dir}/StartupItems

# Project resources directory
resources_dir=${setup_dir}/resources

# Bash shell paths and configuration
bash_base=/bin/bash
bash_latest=/opt/homebrew/bin/bash
shells=/etc/shells

# Shell profile files
bash_profile=~/.bash_profile
zsh_profile=~/.zprofile

# Bash-it framework directories
bash_it_dir=~/.bash_it
bash_it_aliases=~/.bash_it/aliases

# Claude Code configuration
claude_dir=.claude
claude_commands_dir=${claude_dir}/commands

# BMad framework configuration
bmad_core_dir=.bmad-core
bmad_commands_dir=${claude_commands_dir}/BMad

# Docker application directories
docker_app=${apps_dir}/Docker.app
docker_dir=~/.docker
docker_resources_dir=${docker_app}/Contents/Resources

# Git configuration and hooks
git_hooks_dir=${workspace_dir}/git-hooks-core
git_completion=~/.git-completion.bash
github_properties=~/.github.properties

# Java Virtual Machines directory
jvms_dir=${library_dir}/Java/JavaVirtualMachines

# jenv (Java environment manager) directory
jenv_dir=${workspace_dir}/.jenv

# Vim editor paths
vim=/usr/bin/vim
vim_dir=~/.vim
