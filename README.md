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
tools:

| Requirement | Version      |
|-------------|--------------|
| macOS       | Sequoia 15.x |
| Processor   | Apple Mx     |

## Getting Started

* Open **Terminal** and type `git`
* One will be prompted to install the required
**Command Line Developer Tools**
* Once installed, run the following commands from Terminal:

### Create `workspace` Directory

```bash
mkdir -p ~/workspace
```

### Download Project

```bash
cd ~/workspace
git clone https://github.com/opengood-aio/env-setup
cd env-setup
```

## Workstation Setup

### Supported Packages

#### Base Packages (Core Tools)

* `homebrew` - Package manager for macOS
* `vim` - Text editor
* `bash` - Bash shell (5.0+)
* `bash_it` - Bash framework with themes and plugins
* `git` - Version control system

#### Required Packages (Standard Development Tools)

* `bats` - Bash Automated Testing System
* `docker` - Container platform
* `gnused` - GNU implementation of sed
* `gradle` - Build automation tool
* `intellij_idea` - JetBrains IDE for Java/Kotlin
* `iterm` - Terminal emulator for macOS
* `java` - Java Development Kit
* `jenv` - Java environment manager
* `jq` - JSON processor
* `kafka` - Distributed streaming platform
* `kotlin` - Kotlin programming language
* `ktlint` - Kotlin linter
* `llm_context` - LLM context management tool
* `maccy` - Clipboard manager
* `pip` - Python package installer
* `postgres` - PostgreSQL database
* `python` - Python programming language
* `rectangle` - Window management tool
* `uv` - Fast Python package installer and manager
* `wget` - File downloader
* `yq` - YAML processor

#### Additional Packages

* `dockutil` - Dock management utility
* `gcc` - GNU Compiler Collection
* `git_together` - Git pair programming tool
* `minikube` - Local Kubernetes cluster
* `node` - Node.js runtime
* `os_prefs` - macOS preferences configuration
* `pycharm` - JetBrains IDE for Python

#### Node.js Packages

* `cypress` - End-to-end testing framework

#### Python Packages

* `tensorflow` - Machine learning framework

### Install Default Software/Tools

```bash
bin/setup-workstation.sh install all
```

**Notes:**

* One will be prompted to enter credentials to grant elevated privileges
to install packages
* One will be prompted to interactively enter the path to `Bash 5.0`
shell, as this cannot be automated due to security restrictions in macOS
requiring root level access to modify `/etc/shells` shells
configuration file
* For `Git`, one will be prompted for the following information to complete the setup of various Git configurations:
  * Git `name`
  * Git `email`
  * GitHub `username`
  * GitHub `password` or `access token` (latter used for 2FA)
* After `Maacy` and `Rectangle` are installed, one will need to
open the *System Preferences* and grant them elevated privileges under 
`Security & Privacy > Privacy > Accessibility`

### Install Specific Software/Tools

```bash
bin/setup-workstation.sh install <package>
```

### Update Everything

```bash
bin/setup-workstation.sh update
```

### Uninstall Specific Software/Tools

```bash
bin/setup-workstation.sh uninstall <package>
```

### Uninstall Everything

```bash
bin/setup-workstation.sh uninstall all
```

### Bulk Git Pull/Rebase

At times, one needs to perform a `git pull -r` for multiple repos. This
usually involves changing directories to each repo and manually issuing
the above command.

To perform this recursively in all sub-directories with repos:

```bash
bin/pull-git-repos.sh ~/workspace
```
