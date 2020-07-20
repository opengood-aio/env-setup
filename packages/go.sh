function install_go() {
    write_info "Installing Go package..."

    write_info "Installing Go..."
    brew list go &>/dev/null || brew install go
    write_success "Done!"
    write_blank_line

    write_info "Configuring Bash profile to export Go env variables..."
    export GOPATH=$HOME/workspace/go
    export GOBIN=$GOPATH/bin
    export GOPKG=$GOPATH/pkg
    export GOSRC=$GOPATH/src
    export GOPROJ=$GOSRC/github.com/opengoodio

    cat <<EOF >>"${bash_profile}"
# Go env variables
export GOPATH=\$HOME/workspace/go
export GOBIN=\$GOPATH/bin
export GOPKG=\$GOPATH/pkg
export GOSRC=\$GOPATH/src
export GOPROJ=\$GOSRC/github.com/opengoodio

# export GOPATH directory in PATH env variable
export PATH=\$PATH:\$(go env GOPATH)/bin:\$GOPATH

EOF

    source "${bash_profile}"
    write_success "Done!"
    write_blank_line

    write_info "Creating Go directories..."
    create_dir "${GOPATH}"
    create_dir "${GOBIN}"
    create_dir "${GOPKG}"
    create_dir "${GOSRC}"
    create_dir "${GOPROJ}"
    write_success "Done!"
    write_blank_line
}

function uninstall_go() {
    write_info "Uninstalling Go package..."

    write_info "Uninstalling Go..."
    brew uninstall go || { write_warning "WARNING! Go is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
