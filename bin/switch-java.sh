#!/usr/bin/env bash
set -e

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
work_dir=$(dirname "${script_dir}")
workspace_dir=$(dirname "${work_dir}")

source "${work_dir}"/config/properties.sh
source "${work_dir}"/modules/colors.sh
source "${work_dir}"/modules/commons.sh
source "${work_dir}"/modules/java.sh

function usage() {
    write_info "Usage: ./$(basename "$0") <java-version>"
    write_blank_line
    write_info "Supported Java versions:"
    print_items_in_array "${supported_java_versions[@]}"
    write_blank_line
    exit 1
}

write_info "*************************************************************************"
write_info "Workstation Java JDK Version Switcher"
write_info "*************************************************************************"
write_blank_line

if [[ $(get_array_length "$@") -lt 1 ]] || [[ "$(contains_item_in_array "-h" "$@")" == "true" ]]; then
    usage
fi

if ! hash gsed 2>/dev/null; then
    write_warning "GNU Sed is not installed! Auto-installing GNU Sed before continuing..."
    write_info "brew cask install gnu-sed"
    write_blank_line
    brew cask install gnu-sed
    write_blank_line
fi

java_version="${1}"

write_info "Switching Java JDK type '${openjdk_type}' version to '${java_version}'..."
java_home=$(get_java_home "${openjdk_search_path}")

if [[ -d "${java_home}" ]]; then
    path_separator_search_string='\/'
    path_separator_replace_string='\\\/'
    java_home_encoded=$(echo "${java_home}" | sed "s/${path_separator_search_string}/${path_separator_replace_string}/g")
    gsed -i "s/export\sJAVA_HOME\=.*/export JAVA_HOME=${java_home_encoded}/g" "${bash_profile}"
    source "${bash_profile}"
    write_progress "Updated Bash profile '${bash_profile}' with JAVA_HOME env variable"
else
    write_error "ERROR! Unable to locate JAVA_HOME '${java_home}'. Please try again."
    exit 1
fi
write_success "Done!"
write_blank_line

write_info "Setting JAVA_HOME env variable..."
export JAVA_HOME=${java_home}
write_progress "${JAVA_HOME}"
write_success "Done!"
write_blank_line

write_info "Verifying Java version '${java_version}' in JAVA_HOME path variable is set correctly..."
java -version
write_success "Done!"
write_blank_line

write_success "Java JDK type '${openjdk_type}' version '${java_version}' switched successfully!"
write_blank_line
