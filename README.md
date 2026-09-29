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

This configuration is optimized for the following directory layout:

```text
~/dev/
├── java/phoebe/
│   ├── backend/                # Spring Boot application
│   │   ├── gradlew             # Gradle wrapper
│   │   ├── Makefile            # Build shortcuts
│   │   ├── logs/               # Application logs
│   │   │   └── application.log
│   │   ├── docker-compose.yml  # Local services (MySQL, etc.)
│   │   └── src/main/resources/ # Config files (pconf)
│   ├── frontend/               # Frontend application
│   └── database/               # Database scripts
├── frontends/                  # All frontend projects
│   ├── nextjs/
│   ├── angular/
│   ├── react/
│   └── vue/
└── dotfiles/                   # This repository
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

### ✅ Verify installation

After installation, type:

```bash
phi
```

This shows the context-aware Phoebe cheat sheet with all available commands. If you see the command list — you're good to go.

---

## 🎯 Quick Reference

The most useful commands at a glance:

| Command         | Description                                            |
| --------------- | ------------------------------------------------------ |
| `phi`           | 📘 Show all Phoebe commands (context-aware cheat sheet) |
| `p`             | Go to Phoebe project root                              |
| `pbe`           | Go to Phoebe backend                                   |
| `pfe`           | Go to Frontends directory                              |
| `gw build`      | Build backend with Gradle wrapper                      |
| `mk reset`      | Run `make reset` from anywhere                         |
| `pdev`          | Full Phoebe restart (`make reset && make run-hybrid`)  |
| `pfull`         | Clean, build, and test backend                         |
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

```bash
# 1. Go to Phoebe project root
alias p='cd ~/dev/java/phoebe'

# 2. Go to Phoebe backend (Spring Boot)
alias pbe='cd ~/dev/java/phoebe/backend'

# 3. Go to Frontends directory (all frontend projects)
alias pfe='cd ~/dev/frontends'

# 4. Go to backend resources (application.yml, etc.)
alias pconf='cd ~/dev/java/phoebe/backend/src/main/resources'

# 5. Short alias for frontends directory
alias pf='cd ~/dev/frontends'

# 6. Quick jump to specific frontend framework
alias nx='cd ~/dev/frontends/nextjs'
alias ng='cd ~/dev/frontends/angular'
alias rn='cd ~/dev/frontends/react'
alias vue='cd ~/dev/frontends/vue'
```

| Command            | Description                                       |
| ------------------ | ------------------------------------------------- |
| `p`                | Go to Phoebe project root (`~/dev/java/phoebe`)   |
| `pbe`              | Go to Phoebe backend                              |
| `pfe` / `pf`       | Go to Frontends directory (`~/dev/frontends`)     |
| `pconf`            | Go to backend `src/main/resources`                |
| `nx` / `ng` / `rn` | Quick jump to Next.js, Angular, or React frontend |
| `vue`              | Quick jump to Vue frontend                        |

---

## 🏗️ Build & Development

```bash
# 1. Smart Gradle wrapper
# Finds gradlew in the current dir, parent, or backend and runs it.
gw() {
    if [[ -f "./gradlew" ]]; then
        ./gradlew "$@"
    elif [[ -f "../gradlew" ]]; then
        (cd .. && ./gradlew "$@")
    elif [[ -d "$HOME/dev/java/phoebe/backend" ]]; then
        (cd "$HOME/dev/java/phoebe/backend" && ./gradlew "$@")
    else
        echo "❌ gradlew not found!"
        return 1
    fi
}

# 2. Safe Make wrapper (aliased as 'mk')
# Locates Makefile and runs make without overriding system 'make'.
pmake() {
    if [[ -f "./Makefile" ]]; then
        command make "$@"
    elif [[ -f "../Makefile" ]]; then
        (cd .. && command make "$@")
    elif [[ -f "$HOME/dev/java/phoebe/backend/Makefile" ]]; then
        (cd "$HOME/dev/java/phoebe/backend" && command make "$@")
    else
        echo "❌ Makefile not found"
        return 1
    fi
}
alias mk='pmake'

# 3. Full Phoebe restart
alias pdev='cd ~/dev/java/phoebe/backend && make reset && make run-hybrid'

# 4. Clean, build, and test backend
alias pfull='cd ~/dev/java/phoebe/backend && make clean && make build && make test'

# 5. Debug mode (JDWP on port 5005)
alias pdebug='cd ~/dev/java/phoebe/backend && SPRING_PROFILES_ACTIVE=debug gw bootRun --debug-jvm'
```

| Command     | Description                                            |
| ----------- | ------------------------------------------------------ |
| `gw <args>` | Smart Gradle wrapper (auto-finds `gradlew` in backend) |
| `mk <args>` | Safe Make wrapper (auto-finds `Makefile`)              |
| `pdev`      | Full Phoebe restart (`make reset && make run-hybrid`)  |
| `pfull`     | Clean, build, and test backend                         |
| `pdebug`    | Run backend with remote debugger on port 5005          |

**Examples:**

```bash
gw clean build      # clean + build backend
gw bootRun          # run Spring Boot application
gw test             # run all tests
mk reset            # reset Phoebe environment
mk run-hybrid       # run in hybrid mode
```

---

## 🐳 Docker Management

```bash
# 1. Start / stop Phoebe Docker containers
alias pbd-up='cd ~/dev/java/phoebe/backend && docker-compose up -d'
alias pbd-down='cd ~/dev/java/phoebe/backend && docker-compose down'

# 2. Follow logs / show status
alias pbd-logs='cd ~/dev/java/phoebe/backend && docker-compose logs -f'
alias pbd-ps='cd ~/dev/java/phoebe/backend && docker-compose ps'

# 3. Restart containers
alias pbd-restart='cd ~/dev/java/phoebe/backend && docker-compose restart'

# 4. Launch or quit Docker Desktop app (macOS)
alias docker-start='open -a Docker'
alias docker-stop='osascript -e "quit app \"Docker\""'

# 5. Clean only Phoebe-specific Docker resources
pclean-docker() {
    echo "🧹 Cleaning Phoebe Docker environment..."
    (cd ~/dev/java/phoebe/backend && docker-compose down)
    docker system prune -f
    echo "✅ Phoebe Docker cleanup complete!"
}
```

| Command                        | Description                                                  |
| ------------------------------ | ------------------------------------------------------------ |
| `pbd-up` / `pbd-down`          | Start / Stop Phoebe Docker containers                        |
| `pbd-logs`                     | Follow Phoebe Docker logs                                    |
| `pbd-ps`                       | Show Phoebe container status                                 |
| `pbd-restart`                  | Restart Phoebe containers                                    |
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

#### 🧹 Detailed Docker Cleanup Commands

```bash
# 1. Stop all running containers
# Gracefully stops every container that's currently running.
# Does NOT delete anything — just halts the processes.
alias dstop-all='docker stop $(docker ps -aq)'

# 2. Remove all containers (running and stopped)
# Deletes every container definition. Running containers must be
# stopped first, otherwise Docker will refuse to remove them.
alias drm-all='docker rm $(docker ps -aq)'

# 3. Remove all unused Docker resources (images, networks, build cache)
# Frees disk space by deleting stopped containers, unused networks,
# dangling images, and the build cache. Safe to run anytime.
alias dprune='docker system prune'

# 4. Remove all unused volumes (CAUTION: will remove data!)
# Deletes volumes not currently attached to any container.
# ⚠️ Any database or persistent data stored in those volumes is LOST.
alias dvol-prune='docker volume prune'

# 5. Remove all Docker images (CAUTION: will delete all images!)
# Force-removes every image on your machine. Anything not saved
# in a registry will need to be rebuilt or re-pulled.
alias drmi-all='docker rmi -f $(docker images -aq)'

# 6. Complete Docker cleanup (aggressive — removes everything unused)
# Nuclear option: stops all containers, removes them, then runs a
# full system prune with -a and --volumes. Basically resets Docker
# to a pristine state.
alias dclean-all='docker stop $(docker ps -aq) 2>/dev/null; docker rm $(docker ps -aq) 2>/dev/null; docker system prune -a -f --volumes'

# 7. Step-by-step Docker cleanup (SAFE — asks for confirmation)
# Interactive cleanup that asks before doing anything destructive.
dclean-step() {
    echo "⚠️  WARNING: This will stop and remove ALL Docker containers and volumes on this machine."
    read -q "REPLY?Are you absolutely sure you want to continue? (y/N) "
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Docker cleanup cancelled."
        return 1
    fi

    echo "Step 1: Stopping all containers..."
    docker stop $(docker ps -aq) 2>/dev/null || echo "No containers to stop"

    echo "Step 2: Removing all containers..."
    docker rm $(docker ps -aq) 2>/dev/null || echo "No containers to remove"

    echo "Step 3: Pruning system..."
    docker system prune -f

    echo "Step 4: Pruning volumes..."
    docker volume prune -f

    echo "✅ Docker cleanup complete!"
}
```

---

## 🐙 Git Shortcuts

```bash
# 1. git status — see what's changed
alias gs='git status'

# 2. Pretty log — one line per commit with graph and refs
alias gl='git log --oneline --graph --decorate'

# 3. Diff
alias gd='git diff'

# 4. Commit with message — gcm "my message"
alias gcm='git commit -m'

# 5. Pull / Push — sync with remote
alias gp='git pull'
alias gps='git push'

# 6. Checkout / branch
alias gco='git checkout'
alias gb='git branch'
```

| Command      | Description                            |
| ------------ | -------------------------------------- |
| `gs`         | `git status`                           |
| `gl`         | `git log --oneline --graph --decorate` |
| `gd`         | `git diff`                             |
| `gcm "msg"`  | `git commit -m "msg"`                  |
| `gp` / `gps` | `git pull` / `git push`                |
| `gco` / `gb` | `git checkout` / `git branch`          |

---

## 📊 Monitoring

```bash
# 1. Full Phoebe status check
# Backend health, Docker containers, listening ports.
pstatus() {
    echo "📊 Phoebe Backend Status:"
    echo "========================="

    echo "🐳 Docker containers:"
    (cd ~/dev/java/phoebe/backend && docker-compose ps)
    echo ""

    echo "🔌 Listening ports:"
    lsof -i :8080 2>/dev/null | grep LISTEN || echo "❌ Port 8080 not listening"
    lsof -i :3306 2>/dev/null | grep LISTEN || echo "❌ Port 3306 (MySQL) not listening"
    echo ""

    echo "🏥 Health check:"
    curl -s http://localhost:8080/actuator/health 2>/dev/null || echo "❌ Application not responding"
}

# 2. Tail Spring Boot application logs
alias plogs='cd ~/dev/java/phoebe/backend && tail -f logs/application.log'

# 3. Docker container statistics
alias pstats='cd ~/dev/java/phoebe/backend && docker stats'

# 4. List all listening ports
alias ports='lsof -i -P -n | grep LISTEN'

# 5. Context-aware Phoebe cheat sheet
alias phi='phoebe-info'
```

| Command   | Description                                                           |
| --------- | --------------------------------------------------------------------- |
| `pstatus` | Check backend status, Docker containers, and ports (8080, 3306 MySQL) |
| `plogs`   | Tail the Spring Boot application logs                                 |
| `pstats`  | Show Docker container statistics                                      |
| `ports`   | List all listening ports on the system                                |
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
| `dots-restore`  | Restore from repository (with backup)             |
| `dots-status`   | Check repository status                           |
| `dots-log`      | Show recent commit history                        |
| `dots-diff`     | Compare local vs repo version                     |
| `dots-update`   | Pull and apply updates (with backup)              |
| `dots-help`     | Show all dotfiles commands                        |

**Under the hood:**

```bash
# Sync with confirmation prompt
sync-dotfiles() {
    echo "🔄 Syncing dotfiles..."
    cd ~/dev/dotfiles || return
    cp ~/.zshrc .

    if git diff --quiet; then
        echo "✅ No changes to sync"
    else
        echo "📝 Changes detected:"
        git diff --stat
        echo ""
        read -q "REPLY?Commit and push? (y/N) "
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git add .
            git commit -m "Update: $(date +'%Y-%m-%d %H:%M')"
            git push
            echo "✅ Dotfiles synced to GitHub"
        else
            echo "❌ Sync cancelled"
        fi
    fi
}

# Pull latest and apply (with automatic backup)
dots-update() {
    cd ~/dev/dotfiles || return
    git pull
    cp ~/.zshrc "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null
    cp .zshrc ~/.zshrc
    source ~/.zshrc
    echo "✅ Updated from repository (old version backed up)"
}

# Restore from repository (with automatic backup)
dots-restore() {
    cd ~/dev/dotfiles || return
    cp ~/.zshrc "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null
    cp .zshrc ~/.zshrc
    source ~/.zshrc
    echo "✅ Configuration restored from repository (old version backed up)"
}
```

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

1. Back up your current `~/.zshrc` to `~/.zshrc.backup.<timestamp>`
2. Pull the latest changes from GitHub
3. Copy the new `.zshrc` to your home directory
4. Reload the shell

If anything breaks, restore the previous version from the backup:

```bash
cp ~/.zshrc.backup.YYYYMMDD_HHMMSS ~/.zshrc
source ~/.zshrc
```

---

## 📄 License

MIT License. See the [LICENSE](LICENSE) file for details.