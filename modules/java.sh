function create_cert_from_uri() {
    local keytool_path="$1"
    local cert="$2"
    local cert_uri="$3"
    local cert_alias="$4"

    write_info "Creating certificate '${cert}' with alias '${cert_alias}' from URI '${cert_uri}'..."
    ${keytool_path} -printcert -rfc -sslserver ${cert_uri} >${cert}
    write_success "Done!"
    write_blank_line
}

function get_java_home() {
    local search_path="$1"
    eval "local jdk_search_path=${search_path}"
    for java_home in ${jdk_search_path}; do
        echo "${java_home}"
    done
}

function install_cert_into_java_keystores() {
    local cert="$1"
    local cert_uri="$2"
    local cert_alias="$3"
    local generate_cert="${4-true}"
    local delete_cert="${5-true}"

    local key_stores=()
    key_stores+=("${openjdk_type},${openjdk_search_path},none")
    key_stores+=("${intellij_jdk_type},${openjdk_search_path},${intellij_keystore_path}")

    local item
    for item in "${key_stores[@]}"; do
        local parts=(${item//,/ })
        local jdk_type=${parts[0]}
        eval "local jdk_search_path=${parts[1]}"
        eval "local keystore_path=${parts[2]}"

        write_info "--------------------------------------------"
        write_info "Java JDK type: ${jdk_type}"
        write_info "  Certificate: ${cert}"
        write_info "--------------------------------------------"
        write_blank_line

        for java_home in ${jdk_search_path}; do
            install_cert_into_java_keystore \
                "${java_home}" \
                "${keystore_path}" \
                "${cert}" \
                "${cert_uri}" \
                "${cert_alias}" \
                "${generate_cert}" \
                "${delete_cert}"
        done

        write_info "--------------------------------------------"
        write_blank_line
    done
    unset item
}

function install_certs() {
    install_cert_into_java_keystores \
        "${work_dir}/resources/root_ca.pem" \
        "${work_dir}/resources/root_ca.pem" \
        "root_ca" \
        "false" \
        "false"

    install_cert_into_java_keystores \
        "google_com.pem" \
        "google.com" \
        "google_com"
}

function install_cert_into_java_keystore() {
    local java_home="$1"
    local keystore_path="$2"
    local cert="$3"
    local cert_uri="$4"
    local cert_alias="$5"
    local generate_cert="${6-true}"
    local delete_cert="${7-true}"

    local jdk_keystore=lib/security/cacerts
    local jre_keystore=jre/lib/security/cacerts

    local keytool_path=${java_home}/bin/keytool
    local keystore_password=changeit

    if [[ -f ${keystore_path} ]]; then
        keystore_path=${keystore_path}
    elif [[ -f ${java_home}/${jdk_keystore} ]]; then
        keystore_path=${java_home}/${jdk_keystore}
    else
        keystore_path=${java_home}/${jre_keystore}
    fi

    if [[ -f ${keystore_path} ]]; then
        write_info "============================================"
        write_info "Java JDK information"
        write_info "============================================"
        write_info " JAVA_HOME: ${java_home}"
        write_info "  Keystore: ${keystore_path}"
        write_info "      Cert: ${cert}"
        write_info "  Cert URI: ${cert_uri}"
        write_info "Cert Alias: ${cert_alias}"
        write_info "============================================"
        write_blank_line

        write_info "Deleting existing certificate '${cert}' with alias '${cert_alias}' from keystore..."
        sudo "${keytool_path}" -delete -noprompt -alias "${cert_alias}" -keystore "${keystore_path}" -storepass ${keystore_password}
        write_success "Done!"
        write_blank_line

        if [[ "${generate_cert}" == "true" ]]; then
            create_cert_from_uri \
                "${keytool_path}" \
                "${cert}" \
                "${cert_uri}" \
                "${cert_alias}"
        fi

        write_info "Installing certificate '${cert}' with alias '${cert_alias}' into keystore..."
        sudo "${keytool_path}" -importcert -keystore "${keystore_path}" -alias "${cert_alias}" -storepass ${keystore_password} -file "${cert}" -noprompt
        write_success "Done!"
        write_blank_line

        if [[ $"${delete_cert}" == "true" ]]; then
            write_info "Deleting certificate '${cert}' from file system..."
            rm -f "${cert}"
            write_success "Done!"
            write_blank_line
        fi
    else
        write_warning "WARNING! Unable to locate keystore '${keystore_path}'"
        write_blank_line
    fi
}
