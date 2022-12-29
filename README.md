# Environment Setup

[![Build](https://github.com/opengoodio/env-setup/workflows/build/badge.svg)](https://github.com/opengoodio/env-setup/actions?query=workflow%3Abuild)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/opengoodio/env-setup/master/LICENSE)

Automated environment setup and configuration for OpenGood computing
environments

## Pre-Requisites

* Access to GitHub with permissions to clone repos
* Familiarity with running commands and scripts from `macOS` Terminal

## Compatibility

Installation is maintained for the recent version(s) of macOS and required
tools:

| Requirement | Version       |
|-------------|---------------|
| macOS       | Monterey 12.x |
| Processor   | Apple Mx      |


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
git clone https://github.com/opengoodio/env-setup
cd env-setup
```

## Workstation Setup

### Supported Packages

See [Packages](packages) for list of supported packages.

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
* After `Jumpcut` and `Rectangle` are installed, one will need to
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
