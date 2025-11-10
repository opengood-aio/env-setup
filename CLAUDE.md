# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

## Overview

This is an automated environment setup and configuration system for macOS
workstations, specifically designed for OpenGood computing environments. It uses
a modular Bash-based architecture to install and manage development tools via
Homebrew.

**Target Platform**:

* macOS
* Tahoe 16.x (compatible with Sequoia 15.x)
* Apple Silicon (Mx processors)

## Key Commands

### Workstation Setup

```bash
# Install all default software/tools
bin/setup-workstation.sh install all

# Install specific package(s)
bin/setup-workstation.sh install <package>

# Update all packages
bin/setup-workstation.sh update

# Uninstall specific package(s)
bin/setup-workstation.sh uninstall <package>

# Uninstall everything
bin/setup-workstation.sh uninstall all
```

### BMad-core Sync

Sync BMad-Method framework from npm package:

```bash
# Sync to current directory (default)
bin/sync-bmad-core.sh

# Sync to specific subdirectory
bin/sync-bmad-core.sh path/to/project
```

### Testing

Tests use BATS (Bash Automated Testing System):

```bash
# Run tests (requires bats to be installed)
bats test/commons.bats
bats test/package.bats
```

## Architecture

### Core Components

1. **Entry Point** (`bin/setup-workstation.sh`)
    - Main orchestration script
    - Sources configuration and modules
    - Supports three actions: `install`, `uninstall`, `update`
    - Requires sudo privileges for package installation

2. **Configuration** (`config/`)
    - `global.sh`: Defines supported setup actions
    - `packages.sh`: Defines package arrays (base, required, node, pip packages)
    - `io.sh`: I/O configuration
    - `jetbrains.sh`: JetBrains product configurations

3. **Modules** (`modules/`)
    - `commons.sh`: Core utility functions (41 functions, alphabetically ordered,
      fully documented)
    - `package.sh`: Package management functions (`load()`, `install()`,
      `uninstall()`, `verify()`)
    - `jetbrains.sh`: JetBrains-specific installation utilities (6 functions)
    - `colors.sh`: Terminal color definitions (ANSI codes)
    - `io.sh`: Directory stack utilities (`cd_push()`, `cd_pop()`)
    - `parse.sh`: JSON parsing utilities (`get_json()` using jq)

4. **Packages** (`packages/`)
    - Each `.sh` file defines installation/uninstallation logic for a specific
      package
    - Must implement `install_<package>()` function
    - May implement `uninstall_<package>()` and `get_<package>_dependencies()`
      functions
    - Loaded dynamically by the package management system

5. **Resources** (`resources/`)
    - Configuration files, settings archives, and customization scripts
    - Includes JetBrains IDE settings, iTerm2 configs, Bash themes, etc.

### Package System

The package system uses a convention-based approach:

- Package scripts in `packages/` are loaded automatically
- Package names map to function names: `install_git`, `install_docker`, etc.
- Dependencies can be declared via `get_<package>_dependencies()` function
- Package arrays in `config/packages.sh`:
    - `base_packages`: Core tools (homebrew, vim, bash, bash_it, git)
    - `required_packages`: Standard development tools (includes dependencies like
      dockutil, gcc, node)
    - `optional_packages`: Additional tools (docker, gnused, kafka, postgres, etc.)
    - `supported_node_packages`: Node.js packages
    - `supported_pip_packages`: Python packages

### JetBrains Integration

The system has special handling for JetBrains IDEs:

- Uses JetBrains API to fetch latest product versions and plugins
- Automatically downloads and applies settings from `resources/` directory
- Supports IntelliJ IDEA and PyCharm
- Settings are stored as ZIP archives in `resources/`

### Common Utility Functions

All functions in `modules/commons.sh` are fully documented with comments and
organized alphabetically. Key categories include:

- **Array operations**: `contains_item_in_array()`, `get_array_length()`,
  `get_array_item_index()`, `get_array_item_value()`, `print_items_in_array()`,
  `print_entries_in_map()`
- **String manipulation**: `to_lower_case()`, `to_upper_case()`, `to_title_case()`,
  `replace_string()`, `remove_special_chars()`, `remove_trailing_char()`
- **File operations**: `find_string_in_file()`, `find_strings_in_file()`,
  `replace_string_in_file()`
- **Output functions**: `write_info()`, `write_error()`, `write_success()`,
  `write_warning()`, `write_progress()`, `write_blank_line()`, `write_message()`
- **Other utilities**: `function_exists()`, `get_arg_value()`,
  `read_password_input()`
- Color-coded console output for better user experience
- Total of 41 utility functions, all alphabetically organized

## Development Workflow

### Adding a New Package

1. Create `packages/<package_name>.sh`
2. Implement `install_<package_name>()` function
3. Optionally implement `uninstall_<package_name>()` function
4. If package has dependencies, implement `get_<package_name>_dependencies()`
   returning an array
5. Add package to appropriate array in `config/packages.sh` if it should be part
   of default installations

### Modifying Existing Packages

- Package scripts are self-contained in `packages/` directory
- Use utility functions from `modules/commons.sh` for consistency
- Follow existing patterns for user input, logging, and error handling
- Git package installation prompts for user name, email, GitHub username, and
  access token

### Testing

- Test files are in `test/` directory
- Use `test/test-helper.bash` for test setup and utilities (11 helper functions)
- Tests use bats-support and bats-assert libraries
- `test/commons.bats`: 36 tests for utility functions (alphabetically ordered)
- `test/package.bats`: Tests for package management functions
- Sourced modules: `config/global.sh`, `config/io.sh`, `config/packages.sh`,
  `modules/colors.sh`, `modules/commons.sh`
- All test helper functions are fully documented with comments

### Code Organization

- **All functions** across all modules are documented with descriptive comments
  explaining purpose, parameters, and return values
- **Alphabetical ordering**: Functions in `modules/commons.sh` and tests in
  `test/commons.bats` are alphabetically sorted for easy navigation
- **Removed unused code**: 13 unused utility functions have been removed,
  reducing complexity and maintenance burden