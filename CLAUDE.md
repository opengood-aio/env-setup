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
* Sequoia 15.x
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

### Bulk Git Operations

```bash
# Perform git pull -r recursively in all subdirectories with repos
bin/pull-git-repos.sh ~/workspace
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
    - `commons.sh`: Core utility functions (string manipulation, arrays, file
      operations, I/O)
    - `package.sh`: Package management functions (`load()`, `install()`,
      `uninstall()`, `verify()`)
    - `jetbrains.sh`: JetBrains-specific installation utilities
    - `colors.sh`: Terminal color definitions
    - `io.sh`: I/O utilities
    - `parse.sh`: Parsing utilities

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
    - `required_packages`: Standard development tools
    - `supported_node_packages`: Node.js packages
    - `supported_pip_packages`: Python packages

### JetBrains Integration

The system has special handling for JetBrains IDEs:

- Uses JetBrains API to fetch latest product versions and plugins
- Automatically downloads and applies settings from `resources/` directory
- Supports IntelliJ IDEA and PyCharm
- Settings are stored as ZIP archives in `resources/`

### Common Utility Functions

Key functions from `modules/commons.sh`:

- Array operations: `contains_item_in_array()`, `get_array_length()`,
  `print_items_in_array()`
- String manipulation: `to_lower_case()`, `to_upper_case()`, `replace_string()`
- File operations: `contains_string_in_file()`, `find_string_in_file()`,
  `replace_string_in_file()`
- Output functions: `write_info()`, `write_error()`, `write_success()`,
  `write_warning()`, `write_progress()`
- Color-coded console output for better user experience

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
- Use `test/test-helper.bash` for test setup and utilities
- Tests use bats-support and bats-assert libraries
- Sourced modules: `config/global.sh`, `config/io.sh`, `config/packages.sh`,
  `modules/colors.sh`, `modules/commons.sh`