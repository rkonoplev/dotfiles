# 🚀 Phoebe Dotfiles

My personal terminal configuration optimized for **Phoebe** (Java/Spring Boot + Modern Frontends) development on macOS.

---

## 📑 Table of Contents

- [✨ Features](#-features)
- [📋 Prerequisites](#-prerequisites)
- [📂 Project Structure](#-project-structure)
- [⚡ Installation](#-installation)
- [🎯 Quick Reference](#-quick-reference)
- [🧭 Navigation](#-navigation)
- [🏗️ Build & Development](#️-build--development)
- [🐳 Docker Management](#-docker-management)
- [🐙 Git Shortcuts](#-git-shortcuts)
- [📊 Monitoring](#-monitoring)
- [🗃️ Dotfiles Management](#️-dotfiles-management)
- [🔒 Security & Secrets](#-security--secrets)
- [🔄 Updating](#-updating)
- [📄 License](#-license)

---

## ✨ Features

* 🎨 **Custom Zsh Prompt**: Multi-line, colorful, with real-time Git branch and status indicators.
* 🧭 **Smart Navigation**: Project-specific aliases for instant access to backend and frontend directories.
* 🛠️ **Build Tools**: Safe wrappers for Gradle (`gw`) and Make (`mk`) that auto-locate the correct project directories.
* 🐳 **Docker Management**: Shortcuts for Compose, plus **safe** cleanup commands with confirmation prompts to prevent accidental data loss.
* 🐙 **Git Productivity**: Essential aliases for daily Git workflows.
* 🔒 **Security**: Built-in support for loading local secrets from `~/.secrets.zsh` (safely ignored by Git).
* 📦 **Modern Tools**: Auto-detection of `eza` (modern `ls` replacement) with fallback to `exa` or native `ls`.

---

## 📋 Prerequisites

* **OS**: macOS (tested on Ventura+)
* **Shell**: `zsh` (default on macOS Catalina+)
* **Runtime**: Java 17/21 (for Phoebe backend), Node.js (for frontends)
* **Containers**: Docker Desktop or Colima (optional, but recommended)

---

## 📂 Project Structure

This configuration is optimized for the following project structure:

```text
~/dev/
├── java/phoebe/
│   ├── backend/        # Spring Boot application
│   │   ├── gradlew     # Gradle wrapper
│   │   ├── Makefile    # Build shortcuts
│   │   ├── logs/       # Application logs
│   │   └── src/main/resources/
│   ├── frontend/       # Frontend application
│   └── database/       # Database scripts
├── frontends/          # All frontend projects
│   ├── nextjs/
│   ├── angular/
│   └── react/
└── dotfiles/           # This repository
```

---

## ⚡ Installation

### Option 1: Quick Install (One-liner)

Downloads and installs the configuration directly from GitHub:

```bash
curl -s https://raw.githubusercontent.com/rkonoplev/dotfiles/main/install.sh | bash
```

### Option 2: Manual Installation

```bash
git clone https://github.com/rkonoplev/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
cp .zshrc ~/.zshrc
source ~/.zshrc
```

### Verify installation

After installation, type:

```bash
phi
```

This shows the context-aware Phoebe cheat sheet with all available commands.

---

## 🎯 Quick Reference

The most useful commands at a glance:

| Command         | Description                                            |
| --------------- | ------------------------------------------------------ |
| `phi`           | 📘 Show all Phoebe commands (context-aware cheat sheet) |
| `p`             | Go to Phoebe project root                              |
| `pbe`           | Go to Phoebe backend                                   |
| `pfe`           | Go to Phoebe frontend                                  |
| `gw build`      | Build backend with Gradle wrapper                      |
| `mk reset`      | Run `make reset` from anywhere                         |
| `pdev`          | Full Phoebe restart (`make reset && make run-hybrid`)  |
| `pstatus`       | Check backend, Docker, and ports status                |
| `plogs`         | Tail Spring Boot application logs                      |
| `pbd-up`        | Start Phoebe Docker containers                         |
| `pbd-down`      | Stop Phoebe Docker containers                          |
| `dclean-step`   | Safe step-by-step Docker cleanup                       |
| `pclean-docker` | Clean only Phoebe-specific Docker resources            |
| `gs` / `gl`     | `git status` / pretty log                              |
| `dots-sync`     | Sync dotfiles to GitHub (with confirmation)            |
| `dots-update`   | Pull latest config (with automatic backup)             |

> 💡 **Tip**: Type `phi` at any time to see this list directly in your terminal.

---

## 🧭 Navigation

| Command            | Description                                       |
| ------------------ | ------------------------------------------------- |
| `p`                | Go to Phoebe project root (`~/dev/java/phoebe`)   |
| `pbe`              | Go to Phoebe backend                              |
| `pfe`              | Go to Phoebe frontend                             |
| `pconf`            | Go to backend `src/main/resources`                |
| `pf`               | Go to Frontends directory (`~/dev/frontends`)     |
| `nx` / `ng` / `rn` | Quick jump to Next.js, Angular, or React frontend |

---

## 🏗️ Build & Development

| Command     | Description                                            |
| ----------- | ------------------------------------------------------ |
| `gw <args>` | Smart Gradle wrapper (auto-finds `gradlew` in backend) |
| `mk <args>` | Safe Make wrapper (auto-finds `Makefile`)              |
| `pdev`      | Full Phoebe restart (`make reset && make run-hybrid`)  |
| `pfull`     | Clean, build, and test the backend                     |

**Examples:**

```bash
gw clean build      # clean + build backend
gw bootRun          # run Spring Boot application
gw test             # run tests
mk reset            # reset Phoebe environment
mk run-hybrid       # run in hybrid mode
```

---

## 🐳 Docker Management

| Command                        | Description                                                  |
| ------------------------------ | ------------------------------------------------------------ |
| `pbd-up` / `pbd-down`          | Start / Stop Phoebe Docker containers                        |
| `pbd-logs`                     | Follow Phoebe Docker logs                                    |
| `pbd-ps`                       | Show Phoebe container status                                 |
| `docker-start` / `docker-stop` | Launch or quit Docker Desktop app                            |
| `dclean-step`                  | **Safe** step-by-step Docker cleanup (asks for confirmation) |
| `pclean-docker`                | Clean only Phoebe-specific Docker resources                  |

> ⚠️ **Warning**: Commands like `dclean-all` or `drmi-all` are available but will aggressively remove **all** containers and volumes on your machine. Use with extreme caution.

**Aggressive commands (use with care):**

```bash
dclean-all     # stop + rm + prune -a --volumes (wipes Docker)
drmi-all       # remove all images
dvol-prune     # remove all unused volumes (data loss!)
```

---

## 🐙 Git Shortcuts

| Command      | Description                            |
| ------------ | -------------------------------------- |
| `gs`         | `git status`                           |
| `gl`         | `git log --oneline --graph --decorate` |
| `gd`         | `git diff`                             |
| `gcm "msg"`  | `git commit -m "msg"`                  |
| `gp` / `gps` | `git pull` / `git push`                |
| `gco`        | `git checkout`                         |

---

## 📊 Monitoring

| Command   | Description                                                           |
| --------- | --------------------------------------------------------------------- |
| `pstatus` | Check backend status, Docker containers, and ports (8080, 5432)       |
| `plogs`   | Tail the Spring Boot application logs                                 |
| `ports`   | List all listening ports on the system                                |
| `pstats`  | Show Docker container statistics                                      |
| `phi`     | Show context-aware Phoebe command cheat sheet                         |

---

## 🗃️ Dotfiles Management

Keep your configuration synced with this repository safely.

**Short aliases:**

| Command       | Description                                                       |
| ------------- | ----------------------------------------------------------------- |
| `dots`        | Navigate to the dotfiles repository                               |
| `ds`          | Sync changes to GitHub (with confirmation prompt)                 |
| `dotsu`       | Pull latest changes and apply them (**creates automatic backup**) |
| `dr`          | Restore config from repository (**creates automatic backup**)     |
| `dotc`        | Preview local changes before syncing                              |

**Full commands:**

| Command         | Description                                       |
| --------------- | ------------------------------------------------- |
| `dots-sync`     | Sync with confirmation prompt                     |
| `dots-quick`    | Quick sync without prompts                        |
| `dots-check`    | Preview changes before syncing                    |
| `dots-restore`  | Restore from repository                           |
| `dots-status`   | Check repository status                           |
| `dots-log`      | Show recent commit history                        |
| `dots-diff`     | Compare local vs repo version                     |
| `dots-update`   | Pull and apply updates                            |
| `dots-help`     | Show all dotfiles commands                        |

---

## 🔒 Security & Secrets

This repository is public. **Never commit passwords, API keys, or tokens.**

The `.gitignore` is configured to ignore `~/.secrets.zsh`. To use personal secrets:

1. Create the file:

```bash
nano ~/.secrets.zsh
```

2. Add your exports (e.g., `export MY_API_KEY="secret"`).

3. The main `.zshrc` will automatically and safely load it on startup if it exists:

```bash
# Load personal secrets if present
[[ -f ~/.secrets.zsh ]] && source ~/.secrets.zsh
```

---

## 🔄 Updating

To update your local configuration to the latest version from GitHub:

```bash
dotsu
```

This will:

1. Back up your current `~/.zshrc` to `~/.zshrc.bak.<timestamp>`
2. Pull the latest changes from GitHub
3. Copy the new `.zshrc` to your home directory
4. Reload the shell

---

## 📄 License

MIT License. See the [LICENSE](LICENSE) file for details.