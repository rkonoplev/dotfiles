# 🚀 Phoebe Dotfiles

My personal terminal configuration optimized for **Phoebe** (Java/Spring Boot + Modern Frontends) development on macOS.

## ✨ Features

* 🎨 **Custom Zsh Prompt**: Multi-line, colorful, with real-time Git branch and status indicators.
* 🧭 **Smart Navigation**: Project-specific aliases for instant access to backend and frontend directories.
* 🛠️ **Build Tools**: Safe wrappers for Gradle (`gw`) and Make (`mk`) that auto-locate the correct project directories.
* 🐳 **Docker Management**: Shortcuts for Compose, plus **safe** cleanup commands with confirmation prompts to prevent accidental data loss.
* 🐙 **Git Productivity**: Essential aliases for daily Git workflows.
* 🔒 **Security**: Built-in support for loading local secrets from `~/.secrets.zsh` (safely ignored by Git).
* 📦 **Modern Tools**: Auto-detection of `eza` (modern `ls` replacement) with fallback to `exa` or native `ls`.

## 📋 Prerequisites

* **OS**: macOS (tested on Ventura+)
* **Shell**: `zsh` (default on macOS Catalina+)
* **Runtime**: Java 17/21 (for Phoebe backend), Node.js (for frontends)
* **Containers**: Docker Desktop or Colima (optional, but recommended)

## 📂 Expected Project Structure

This configuration is optimized for the following directory layout:

```text
~/dev/
├── java/phoebe/
│   ├── backend/        # Spring Boot application
│   └── ...
├── frontends/          # All frontend projects (nextjs, angular, react, vue)
└── dotfiles/           # This repository
```

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

## 🚀 Usage & Quick Reference

### 🧭 Navigation

| Command            | Description                                       |
| ------------------ | ------------------------------------------------- |
| `p`                | Go to Phoebe project root (`~/dev/java/phoebe`)   |
| `pbe`              | Go to Phoebe backend                              |
| `pfe`              | Go to Frontends directory (`~/dev/frontends`)     |
| `nx` / `ng` / `rn` | Quick jump to Next.js, Angular, or React frontend |

### 🏗️ Build & Development

| Command     | Description                                            |
| ----------- | ------------------------------------------------------ |
| `gw <args>` | Smart Gradle wrapper (auto-finds `gradlew` in backend) |
| `mk <args>` | Safe Make wrapper (auto-finds `Makefile`)              |
| `pdev`      | Full Phoebe restart (`make reset && make run-hybrid`)  |
| `pfull`     | Clean, build, and test the backend                     |

### 🐳 Docker Management

| Command                        | Description                                                  |
| ------------------------------ | ------------------------------------------------------------ |
| `pbd-up` / `pbd-down`          | Start / Stop Phoebe Docker containers                        |
| `docker-start` / `docker-stop` | Launch or quit Docker Desktop app                            |
| `dclean-step`                  | **Safe** step-by-step Docker cleanup (asks for confirmation) |
| `pclean-docker`                | Clean only Phoebe-specific Docker resources                  |

> ⚠️ **Warning**: Commands like `dclean-all` or `drmi-all` are available but will aggressively remove **all** containers and volumes on your machine. Use with extreme caution.

### 🐙 Git Shortcuts

| Command      | Description                            |
| ------------ | -------------------------------------- |
| `gs`         | `git status`                           |
| `gl`         | `git log --oneline --graph --decorate` |
| `gcm "msg"`  | `git commit -m "msg"`                  |
| `gp` / `gps` | `git pull` / `git push`                |

### 📊 Monitoring

| Command   | Description                                                           |
| --------- | --------------------------------------------------------------------- |
| `pstatus` | Check backend status, Docker containers, and ports (8080, 3306 MySQL) |
| `plogs`   | Tail the Spring Boot application logs                                 |
| `ports`   | List all listening ports on the system                                |
| `phi`     | Show context-aware Phoebe command cheat sheet                         |

### 🗃️ Dotfiles Management

Keep your configuration synced with this repository safely:

| Command | Description                                                       |
| ------- | ----------------------------------------------------------------- |
| `dots`  | Navigate to the dotfiles repository                               |
| `ds`    | Sync changes to GitHub (with confirmation prompt)                 |
| `dotsu` | Pull latest changes and apply them (**creates automatic backup**) |
| `dr`    | Restore config from repository (**creates automatic backup**)     |
| `dotc`  | Preview local changes before syncing                              |

## 🔒 Security & Secrets

This repository is public. **Never commit passwords, API keys, or tokens.**

The `.gitignore` is configured to ignore `~/.secrets.zsh`. To use personal secrets:

1. Create the file:

```bash
nano ~/.secrets.zsh
```

2. Add your exports (e.g., `export MY_API_KEY="secret"`).

3. The main `.zshrc` will automatically and safely load it on startup if it exists.

## 🔄 Updating

To update your local configuration to the latest version from GitHub:

```bash
dotsu
```

This will pull changes, back up your current `.zshrc`, and apply the update.

## 📄 License

MIT License. See the [LICENSE](LICENSE) file for details.