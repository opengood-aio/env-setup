# java properties
default_java_version=13

# local directories
setup_dir="${workspace_dir}"/env-setup
packages_dir=${setup_dir}/packages

downloads_dir=~/Downloads
library_dir=~/Library
volumes_dir=/Volumes

app_support_dir="${library_dir}/Application Support"
caches_dir=${library_dir}/Caches
containers_dir=${library_dir}/Containers
logs_dir=${library_dir}/Logs
prefs_dir=${library_dir}/Preferences
start_up_dir=${library_dir}/StartupItems

# local files
bash_profile=~/.bash_profile

# required workstation packages
required_workstation_packages=()
required_workstation_packages+=("bats")
required_workstation_packages+=("cf")
required_workstation_packages+=("chrome")
required_workstation_packages+=("dep")
required_workstation_packages+=("docker")
required_workstation_packages+=("fly")
required_workstation_packages+=("flycut")
required_workstation_packages+=("gnused")
required_workstation_packages+=("go")
required_workstation_packages+=("gradle")
required_workstation_packages+=("intellijidea")
required_workstation_packages+=("iterm")
required_workstation_packages+=("java")
required_workstation_packages+=("jenv")
required_workstation_packages+=("jq")
required_workstation_packages+=("kotlin")
required_workstation_packages+=("marklogic")
required_workstation_packages+=("mysql")
required_workstation_packages+=("node")
required_workstation_packages+=("pip")
required_workstation_packages+=("postman")
required_workstation_packages+=("python")
required_workstation_packages+=("rabbitmq")
required_workstation_packages+=("shiftit")
required_workstation_packages+=("slack")
required_workstation_packages+=("sublimetext")
required_workstation_packages+=("wget")
required_workstation_packages+=("yq")

# supported Java versions
supported_java_versions=()
supported_java_versions+=("11")
supported_java_versions+=("13")

# supported node packages
supported_node_packages=()
supported_node_packages+=("cypress")

# supported pip packages
supported_pip_packages=()
supported_pip_packages+=("tensorflow")

# supported setup actions
supported_setup_actions=()
supported_setup_actions+=("install")
supported_setup_actions+=("update")
supported_setup_actions+=("uninstall")

# version properties
marklogic_version=10.0-4.2
