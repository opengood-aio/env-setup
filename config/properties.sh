# java properties
default_java_version=11
jvm_home=/Library/Java/JavaVirtualMachines
openjdk_type=adoptopenjdk
openjdk_search_path='${jvm_home}/${openjdk_type}-${java_version}*.jdk/Contents/Home'
intellij_jdk_type=intellijjdk
intellij_keystore_path='~/Library/Caches/IntelliJIdea${intellij_idea_version}/tasks/cacerts'

# supported Java versions
supported_java_versions=()
supported_java_versions+=("8")
supported_java_versions+=("11")

# local directories
setup_dir=${workspace_dir}/env-setup
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

# required packages
required_packages=()
required_packages+=("bats")
required_packages+=("bash")
required_packages+=("cf")
required_packages+=("chrome")
required_packages+=("chromedriver")
required_packages+=("docker")
required_packages+=("fly")
required_packages+=("flycut")
required_packages+=("gnused")
required_packages+=("intellijidea")
required_packages+=("iterm")
required_packages+=("java")
required_packages+=("jq")
required_packages+=("gradle")
required_packages+=("maven")
required_packages+=("ml")
required_packages+=("mysql")
required_packages+=("node")
required_packages+=("postman")
required_packages+=("rabbitmq")
required_packages+=("shiftit")
required_packages+=("slack")
required_packages+=("springboot")
required_packages+=("sublimetext")
required_packages+=("wget")
required_packages+=("yq")

# supported node packages
supported_node_packages=()
supported_node_packages+=("cypress")

# supported setup actions
supported_setup_actions=()
supported_setup_actions+=("install")
supported_setup_actions+=("update")
supported_setup_actions+=("uninstall")

# version properties
intellij_idea_version=2019.2
ml_version=9.0-10