jetbrains_name="JetBrains"

jetbrains_product_releases_api_base_uri=https://data.services.jetbrains.com/products/releases
jetbrains_plugins_api_base_uri=https://plugins.jetbrains.com/pluginManager

jetbrains_intellij_idea_ultimate_product_code=IIU
jetbrains_py_charm_pro_product_code=PCP

declare -gA jetbrains_products
jetbrains_products["${jetbrains_intellij_idea_ultimate_product_code}"]="IntelliJ IDEA"
jetbrains_products["${jetbrains_py_charm_pro_product_code}"]="PyCharm"

declare -gA jetbrains_product_editions
jetbrains_product_editions["${jetbrains_intellij_idea_ultimate_product_code}"]="IU"
jetbrains_product_editions["${jetbrains_py_charm_pro_product_code}"]="IU"

declare -gA jetbrains_product_dirs
jetbrains_dir="JetBrains"
jetbrains_product_dirs["${jetbrains_intellij_idea_ultimate_product_code}"]="IntelliJIdea"
jetbrains_product_dirs["${jetbrains_py_charm_pro_product_code}"]="PyCharm"

declare -gA jetbrains_apps
jetbrains_apps["${jetbrains_intellij_idea_ultimate_product_code}"]="IntelliJ IDEA.app"
jetbrains_apps["${jetbrains_py_charm_pro_product_code}"]="PyCharm.app"

declare -gA jetbrains_homebrew_packages
jetbrains_homebrew_packages["${jetbrains_intellij_idea_ultimate_product_code}"]="intellij-idea"
jetbrains_homebrew_packages["${jetbrains_py_charm_pro_product_code}"]="pycharm"

declare -gA jetbrains_resources
jetbrains_resources["${jetbrains_intellij_idea_ultimate_product_code}"]="intellij_idea_settings.zip"
jetbrains_resources["${jetbrains_py_charm_pro_product_code}"]="pycharm_settings.zip"

declare -gA jetbrains_intellij_idea_plugins
jetbrains_intellij_idea_plugins[BashSupportPro]="pro.bashsupport"
jetbrains_intellij_idea_plugins[Ignore]="mobi.hsz.idea.gitignore"
jetbrains_intellij_idea_plugins[Kotest]="kotest-plugin-intellij"
jetbrains_intellij_idea_plugins[Ktlint]="com.nbadal.ktlint"

declare -gA jetbrains_py_charm_plugins
