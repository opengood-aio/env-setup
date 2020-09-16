function install_minikube() {
    write_info "Installing Minikube package..."

    write_info "Installing Minikube..."
    brew list minikube &>/dev/null || brew install minikube
    write_success "Done!"
    write_blank_line
}

function uninstall_minikube() {
    write_info "Uninstalling Minikube package..."

    write_info "Uninstalling Minikube..."
    brew uninstall minikube || { write_warning "WARNING! Minikube is not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
