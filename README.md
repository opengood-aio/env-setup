# Environment Setup

Automated environment setup scripts for OpenGood computing environments

## Prerequisites

* Access to GitHub with permissions to clone repos
* Familiarity with running commands and scripts from `macOS` Terminal
* Running the latest version of **macOS**, currently **Catalina**
  * These scripts might work on previous versions, but are maintained
  with only the latest macOS version in mind

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
bin/workstation-setup.sh install
```

> **Note:** After `Flycut` and `ShiftIt` are installed, one will need to
open the *System Preferences* and grant them elevated privileges under 
`Security & Privacy > Privacy > Accessibility`

### Install Specific Software/Tools

```bash
bin/workstation-setup.sh install <package>
```

### Update Everything

```bash
bin/workstation-setup.sh update
```

### Uninstall Specific Software/Tools

```bash
bin/workstation-setup.sh uninstall <package>
```

### Uninstall Everything

```bash
bin/workstation-setup.sh uninstall all
```
