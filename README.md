# Environment Setup

[![Build](https://github.com/opengood-aio/env-setup/workflows/build/badge.svg)](https://github.com/opengood-aio/env-setup/actions?query=workflow%3Abuild)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/opengood-aio/env-setup/master/LICENSE)

Automated environment setup and configuration for OpenGood computing
environments

## Pre-Requisites

* Access to GitHub with permissions to clone repos
* Familiarity with running commands and scripts from `macOS` Terminal

## Compatibility

Installation is maintained for the recent version(s) of macOS and required
processors:

| Requirement | Version    |
|-------------|------------|
| macOS       | Tahoe 16.x |
| Processor   | Apple Mx   |

---

## Getting Started

* Open **Terminal** and type `git`
* One will be prompted to install the required
  **Command Line Developer Tools**
* Once installed, run the following commands from Terminal:

### Create `workspace` Directory

```bash
mkdir -p ~/workspace
```

### Download Repo

```bash
cd ~/workspace
git clone https://github.com/opengood-aio/env-setup
cd env-setup
```

---

## Workstation Setup

### Supported Packages

#### Base Packages (Core Tools)

* `homebrew` - Package manager for macOS
* `vim` - Text editor
* `bash` - Bash shell (5.0+)
* `bash_it` - Bash framework with themes and plugins
* `git` - Version control system

#### Required Packages (Standard Tools)

* `bats` - Bash Automated Testing System
* `dockutil` - Dock management utility
* `gcc` - GNU Compiler Collection
* `gradle` - Build automation tool
* `intellij_idea` - JetBrains IDE for Java/Kotlin
* `iterm` - Terminal emulator for macOS
* `java` - Java Development Kit
* `jenv` - Java environment manager
* `jq` - JSON processor
* `kotlin` - Kotlin programming language
* `ktlint` - Kotlin linter
* `llm_context` - LLM context management tool
* `maccy` - Clipboard manager
* `node` - Node.js runtime
* `pip` - Python package installer
* `pycharm` - JetBrains IDE for Python
* `python` - Python programming language
* `rectangle` - Window management tool
* `uv` - Fast Python package installer and manager

#### Additional Packages (Optional Tools)

* `docker` - Container platform
* `gnused` - GNU implementation of sed
* `google_chrome` - Google Chrome web browser
* `kafka` - Distributed streaming platform
* `minikube` - Local Kubernetes cluster
* `os_prefs` - macOS preferences configuration
* `postgres` - PostgreSQL database

---

### Install Default Tools

```bash
bin/setup-workstation.sh install all
```

**Notes:**

* One will be prompted to enter credentials to grant elevated privileges
  to install packages
* One will be prompted to interactively enter the path to the `Bash 5.0` or
  later shell, as this cannot be automated due to security restrictions in macOS
  requiring root level access to modify `/etc/shells` shells
  configuration file
* For `Git`, one will be prompted for the following information to complete the
  setup of various Git configurations:
    * Git `name`
    * Git `email`
    * GitHub `username`
    * GitHub `access token`
    * GitHub GPG signing key `gpg signing key`
* After `Maacy` and `Rectangle` are installed, one will need to
  open the *System Preferences* and grant them elevated privileges under
  `Security & Privacy > Privacy > Accessibility`

### Install Specific Tools

```bash
bin/setup-workstation.sh install <package>
```

### Uninstall Specific Tools

```bash
bin/setup-workstation.sh uninstall <package>
```

### Uninstall All Tools

```bash
bin/setup-workstation.sh uninstall all
```

---

## Custom Tools

### Sync BMad-Core

To install or update `.bmad-core` with the latest `bmad-method` npm package:

#### Install to current project (default)

```bash
bin/sync-bmad-core.sh
```

#### Install to another project in workspace

```bash
bin/sync-bmad-core.sh <relative-path>
```

#### Show help

```bash
bin/sync-bmad-core.sh -h
```

**Examples:**

#### Install to env-setup project (default)

```bash
bin/sync-bmad-core.sh
```

#### Install to my-project in workspace

```bash
bin/sync-bmad-core.sh my-project
```

**Notes:**

* Takes optional parameter for relative directory path from workspace directory
* Defaults to current project (env-setup) if no parameter provided
* Installs the latest `bmad-method` package in a temporary directory
* Backups existing `.bmad-core` directory with timestamp (if it exists)
* Copies the new `.bmad-core` to specified installation directory
* Copies updated BMad commands to `.claude/commands/BMad` (if applicable)
* Verifies installation directory exists before proceeding
