# JetBrains company name
jetbrains_name="JetBrains"

# JetBrains API endpoints
jetbrains_product_releases_api_base_uri=https://data.services.jetbrains.com/products/releases
jetbrains_plugins_api_base_uri=https://plugins.jetbrains.com/pluginManager

# JetBrains product codes
jetbrains_intellij_idea_ultimate_product_code=IIU
jetbrains_py_charm_pro_product_code=PCP

# JetBrains product names (indexed by product code)
declare -gA jetbrains_products
jetbrains_products["${jetbrains_intellij_idea_ultimate_product_code}"]="IntelliJ IDEA"
jetbrains_products["${jetbrains_py_charm_pro_product_code}"]="PyCharm"

# JetBrains product editions (indexed by product code)
declare -gA jetbrains_product_editions
jetbrains_product_editions["${jetbrains_intellij_idea_ultimate_product_code}"]="IU"
jetbrains_product_editions["${jetbrains_py_charm_pro_product_code}"]="IU"

# JetBrains product configuration directories (indexed by product code)
declare -gA jetbrains_product_dirs
jetbrains_dir="JetBrains"
jetbrains_product_dirs["${jetbrains_intellij_idea_ultimate_product_code}"]="IntelliJIdea"
jetbrains_product_dirs["${jetbrains_py_charm_pro_product_code}"]="PyCharm"

# JetBrains application names (indexed by product code)
declare -gA jetbrains_apps
jetbrains_apps["${jetbrains_intellij_idea_ultimate_product_code}"]="IntelliJ IDEA.app"
jetbrains_apps["${jetbrains_py_charm_pro_product_code}"]="PyCharm.app"

# JetBrains package names (indexed by product code)
declare -gA jetbrains_homebrew_packages
jetbrains_homebrew_packages["${jetbrains_intellij_idea_ultimate_product_code}"]="intellij-idea"
jetbrains_homebrew_packages["${jetbrains_py_charm_pro_product_code}"]="pycharm"

# JetBrains settings resource files (indexed by product code)
declare -gA jetbrains_resources
jetbrains_resources["${jetbrains_intellij_idea_ultimate_product_code}"]="intellij_idea_settings.zip"
jetbrains_resources["${jetbrains_py_charm_pro_product_code}"]="intellij_idea_settings.zip"

# IntelliJ IDEA plugins (plugin name to plugin ID mapping)
declare -gA jetbrains_intellij_idea_plugins
jetbrains_intellij_idea_plugins[CaseConversion]="me.laria.code.idea_caseconv"
jetbrains_intellij_idea_plugins[ClaudeCode]="com.anthropic.code.plugin"
jetbrains_intellij_idea_plugins[Codeowners]="fantom.codeowners"
jetbrains_intellij_idea_plugins[Ignore]="mobi.hsz.idea.gitignore"
jetbrains_intellij_idea_plugins[Kotest]="kotest-plugin-intellij"
jetbrains_intellij_idea_plugins[Ktlint]="com.nbadal.ktlint"
jetbrains_intellij_idea_plugins[UUIDGenerator]="com.github.leomillon.uuidgenerator"

# PyCharm plugins (plugin name to plugin ID mapping)
declare -gA jetbrains_py_charm_plugins
jetbrains_py_charm_plugins[CaseConversion]="me.laria.code.idea_caseconv"
jetbrains_py_charm_plugins[ClaudeCode]="com.anthropic.code.plugin"
jetbrains_py_charm_plugins[Codeowners]="fantom.codeowners"
jetbrains_py_charm_plugins[Ignore]="mobi.hsz.idea.gitignore"
jetbrains_py_charm_plugins[UUIDGenerator]="com.github.leomillon.uuidgenerator"
