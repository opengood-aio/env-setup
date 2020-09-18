source "${setup_dir}"/config/marklogic.sh

function install_marklogic() {
    write_info "Installing MarkLogic package..."

    if [[ ! -d "${library_dir}/MarkLogic" ]]; then
        write_info "Enter MarkLogic email address..."
        read -r email
        email="$(replace_string "${email}" "@" "%40")"
        write_blank_line

        write_info "Enter MarkLogic password..."
        local password
        password="$(read_password_input)"
        password="$(replace_string "${password}" "+" "%2B")"
        write_blank_line

        write_info "Logging into MarkLogic to get download URI..."
        cd_push "${downloads_dir}"
        local json
        json=$(curl -X POST \
            -d "email=${email}&password=${password}" \
            --cookie cookies.txt \
            --cookie-jar cookies.txt \
            "${marklogic_developer_site_uri}/login")

        if [[ $(contains_string "${json}" "Bad email/password combination") == "true" ]]; then
            write_error "Failed to authenticate into MarkLogic"
            write_progress "${json}"
            exit 1 
        fi 
        write_success "Done!"
        write_blank_line

        write_info "Getting download URI for MarkLogic version '${marklogic_version}'..."
        json=$(curl -X POST \
            -d "download=%2Fdownload%2Fbinaries%2F10.0%2FMarkLogic-${marklogic_version}-x86_64.dmg" \
            --cookie cookies.txt \
            --cookie-jar cookies.txt \
            "${marklogic_developer_site_uri}/get-download-url")
        local download_path
        download_path=$(get_json "${json}" ".path")
        write_progress "Download path: ${download_path}"
        rm -f cookies.txt
        write_success "Done!"
        write_blank_line

        write_info "Downloading MarkLogic version '${marklogic_version}'..."
        curl -o marklogic.dmg "${marklogic_developer_site_uri}${download_path}"
        write_success "Done!"
        write_blank_line

        write_info "Attaching MarkLogic image..."
        sudo hdiutil attach marklogic.dmg
        write_success "Done!"
        write_blank_line

        write_info "Installing MarkLogic..."
        open "${volumes_dir}"/MarkLogic/MarkLogic-${marklogic_version}-x86_64.pkg
        echo -e "Waiting for user to complete interactive installation. When done, press [ENTER]:"
        read -r complete
        write_success "Done!"
        write_blank_line

        if [[ -d "${volumes_dir}"/MarkLogic ]]; then
            write_info "Unmounting MarkLogic image..."
            sudo hdiutil unmount "${volumes_dir}"/MarkLogic
            write_success "Done!"
            write_blank_line
        fi

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

function uninstall_marklogic() {
    write_info "Uninstalling MarkLogic package..."

	if [[ -f "${start_up_dir}"/MarkLogic/MarkLogic ]]; then
        write_info "Stopping MarkLogic service..."
        "${start_up_dir}"/MarkLogic/MarkLogic stop
        write_success "Done!"
       write_blank_line
    fi

    write_info "Uninstalling MarkLogic converters..."
    sudo pkgutil --forget com.marklogic.converters || { write_warning "WARNING! MarkLogic converters not installed and cannot be uninstalled. Continuing on."; }
    rm -Rf "${library_dir}"/MarkLogic/Converters
    write_success "Done!"
    write_blank_line

    write_info "Removing MarkLogic data..."
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
