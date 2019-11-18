function install_ml() {
    write_info "Installing MarkLogic package..."

    if [[ ! -d "${library_dir}/MarkLogic" ]]; then
        write_info "Logging into MarkLogic to get download URI..."
        cd_push "${downloads_dir}"
        curl -X POST \
            -d "email=gaibaconlab%40gmail.com&password=Yummy1!" \
            --cookie cookies.txt \
            --cookie-jar cookies.txt \
            https://developer.marklogic.com/login
        write_success "Done!"
        write_blank_line

        write_info "Getting download URI for MarkLogic version '${ml_version}'..."
        local json=$(curl -X POST \
            -d "download=%2Fdownload%2Fbinaries%2F9.0%2FMarkLogic-${ml_version}-x86_64.dmg" \
            --cookie cookies.txt \
            --cookie-jar cookies.txt \
            https://developer.marklogic.com/get-download-url)
        local download_path=$(get_json "${json}" ".path")
        write_progress "Download path: ${download_path}"
        rm -f cookies.txt
        write_success "Done!"
        write_blank_line

        write_info "Downloading MarkLogic version '${ml_version}'..."
        curl -o marklogic.dmg "https://developer.marklogic.com${download_path}"
        write_success "Done!"
        write_blank_line

        write_info "Attaching MarkLogic image..."
        sudo hdiutil attach marklogic.dmg
        write_success "Done!"
        write_blank_line

        write_info "Installing MarkLogic package..."
        open "${volumes_dir}"/MarkLogic/MarkLogic-${ml_version}-x86_64.pkg
        echo -e "Waiting for user to complete interactive installation. When done, press [ENTER]:"
        read -r complete
        write_success "Done!"
        write_blank_line

        write_info "Unmounting MarkLogic image..."
        sudo hdiutil unmount "${volumes_dir}"/MarkLogic
        write_success "Done!"
        write_blank_line

        if [[ -f marklogic.dmg ]]; then
            write_info "Deleting MarkLogic image..."
            rm -f marklogic.dmg
            cd_pop
            write_success "Done!"
            write_blank_line
        fi

        write_info "Starting MarkLogic service..."
        "${start_up_dir}"/MarkLogic/Marklogic start
        write_success "Done!"
        write_blank_line
    else
        write_progress "MarkLogic is already installed"
        write_success "Done!"
        write_blank_line
    fi
}

function uninstall_ml() {
    write_info "Uninstalling MarkLogic package..."

    write_info "Stopping MarkLogic service..."
    "${start_up_dir}"/MarkLogic stop
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling MarkLogic converters..."
    sudo pkgutil --forget com.marklogic.converters || { write_warning "WARNING! MarkLogic converters not installed and cannot be uninstalled. Continuing on."; }
    rm -Rf "${library_dir}"/MarkLogic/Converters
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling MarkLogic data..."
    sudo rm -Rf "${app_support_dir}/MarkLogic/Data"
    write_success "Done!"
    write_blank_line

    write_info "Uninstalling MarkLogic..."
    sudo rm -Rf "${library_dir}"/MarkLogic
    sudo rm -Rf "${app_support_dir}/MarkLogic"
    sudo rm -Rf "${start_up_dir}"/MarkLogic
    sudo rm -Rf "${library_dir}"/PreferencePanes/MarkLogic.prefPane
    sudo pkgutil --forget com.marklogic.server || { write_warning "WARNING! MarkLogic Server not installed and cannot be uninstalled. Continuing on."; }
    write_success "Done!"
    write_blank_line
}
