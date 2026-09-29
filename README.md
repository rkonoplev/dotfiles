# 🚀 Phoebe Dotfiles

My personal terminal configuration optimized for **Phoebe** (Java/Spring Boot + Modern Frontends) development on macOS.

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

---

## 🚀 Usage & Quick Reference

### 🧭 Navigation

```bash
# =======================
# 1. Go to Phoebe project root
# Jumps straight to ~/dev/java/phoebe regardless of where you are.
alias p='cd ~/dev/java/phoebe'

# 2. Go to Phoebe backend
# Shortcut to the Spring Boot backend directory.
alias pbe='cd ~/dev/java/phoebe/backend'

# 3. Go to Frontends directory
# Opens the folder that contains all frontend projects.
alias pfe='cd ~/dev/frontends'

# 4. Quick jump to specific frontend
# Each alias cd's into its corresponding framework folder.
alias nx='cd ~/dev/frontends/nextjs'
alias ng='cd ~/dev/frontends/angular'
alias rn='cd ~/dev/frontends/react'
```

| Command            | Description                                       |
| ------------------ | ------------------------------------------------- |
| `p`                | Go to Phoebe project root (`~/dev/java/phoebe`)   |
| `pbe`              | Go to Phoebe backend                              |
| `pfe`              | Go to Frontends directory (`~/dev/frontends`)     |
| `nx` / `ng` / `rn` | Quick jump to Next.js, Angular, or React frontend |

---

### 🏗️ Build & Development

```bash
# =======================
# 1. Smart Gradle wrapper
# Finds gradlew in the backend directory and runs it,
# so you can call `gw build` from anywhere.
gw() {
  local dir=$(find ~/dev/java/phoebe/backend -maxdepth 2 -name gradlew 2>/dev/null | head -n1)
  if [[ -n "$dir" ]]; then
    (cd "$(dirname "$dir")" && ./gradlew "$@")
  else
    echo "❌ gradlew not found in backend"
  fi
}

# 2. Safe Make wrapper
# Locates the Makefile in the current project tree and runs make,
# saving you from `cd`-ing manually.
mk() {
  local dir=$(find . -maxdepth 3 -name Makefile 2>/dev/null | head -n1)
  if [[ -n "$dir" ]]; then
    (cd "$(dirname "$dir")" && make "$@")
  else
    echo "❌ Makefile not found"
  fi
}

# 3. Full Phoebe restart
# Resets everything and boots the hybrid (backend + frontend) stack.
alias pdev='make reset && make run-hybrid'

# 4. Clean, build and test backend
# Standard "make sure nothing is broken" pipeline for Spring Boot.
alias pfull='cd ~/dev/java/phoebe/backend && ./gradlew clean build test'
```

| Command     | Description                                            |
| ----------- | ------------------------------------------------------ |
| `gw <args>` | Smart Gradle wrapper (auto-finds `gradlew` in backend) |
| `mk <args>` | Safe Make wrapper (auto-finds `Makefile`)              |
| `pdev`      | Full Phoebe restart (`make reset && make run-hybrid`)  |
| `pfull`     | Clean, build, and test the backend                     |

---

### 🐳 Docker Management

```bash
# =======================
# 1. Start / stop Phoebe Docker containers
# Uses the project's compose file to bring services up or down.
alias pbd-up='cd ~/dev/java/phoebe/backend && docker compose up -d'
alias pbd-down='cd ~/dev/java/phoebe/backend && docker compose down'

# 2. Launch or quit Docker Desktop app
# Convenient on macOS when Docker Desktop isn't running yet.
alias docker-start='open -a Docker'
alias docker-stop='osascript -e "quit app \"Docker\""'

# 3. Clean only Phoebe-specific Docker resources
# Removes containers, images, and volumes that belong to the
# Phoebe compose project — leaves the rest of Docker untouched.
alias pclean-docker='docker compose -f ~/dev/java/phoebe/backend/docker-compose.yml down -v --rmi local'
```

| Command                        | Description                                                  |
| ------------------------------ | ------------------------------------------------------------ |
| `pbd-up` / `pbd-down`          | Start / Stop Phoebe Docker containers                        |
| `docker-start` / `docker-stop` | Launch or quit Docker Desktop app                            |
| `dclean-step`                  | **Safe** step-by-step Docker cleanup (asks for confirmation) |
| `pclean-docker`                | Clean only Phoebe-specific Docker resources                  |

> ⚠️ **Warning**: Commands like `dclean-all` or `drmi-all` are available but will aggressively remove **all** containers and volumes on your machine. Use with extreme caution.

#### 🧹 Detailed Docker Cleanup Commands

```bash
# =======================
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

# 6. Complete Docker cleanup (aggressive - removes everything unused)
# Nuclear option: stops all containers, removes them, then runs a
# full system prune with -a and --volumes. Basically resets Docker
# to a pristine state.
alias dclean-all='docker stop $(docker ps -aq) 2>/dev/null; docker rm $(docker ps -aq) 2>/dev/null; docker system prune -a -f --volumes'

# 7. Step-by-step Docker cleanup
# Interactive, safe cleanup that asks for confirmation before each
# destructive step. Ideal when you want to free space without
# accidentally nuking your entire Docker setup.
dclean-step() {
  echo "🧹 Docker Step-by-Step Cleanup"
  echo "------------------------------"

  echo "🛑 Stopping all running containers..."
  docker stop $(docker ps -aq) 2>/dev/null

  echo "🗑️  Removing all containers..."
  docker rm $(docker ps -aq) 2>/dev/null

  echo "🧼 Pruning unused images, networks and build cache..."
  docker system prune -a -f

  echo "💾 Pruning unused volumes (data loss possible!)..."
  docker volume prune -f

  echo "✅ Docker cleanup complete."
}
```

---

### 🐙 Git Shortcuts

```bash
# =======================
# 1. git status — see what's changed
alias gs='git status'

# 2. Pretty log — one line per commit with graph and refs
alias gl='git log --oneline --graph --decorate'

# 3. Commit with message — gcm "my message"
alias gcm='git commit -m'

# 4. Pull / Push — sync with remote
alias gp='git pull'
alias gps='git push'
```

| Command      | Description                            |
| ------------ | -------------------------------------- |
| `gs`         | `git status`                           |
| `gl`         | `git log --oneline --graph --decorate` |
| `gcm "msg"`  | `git commit -m "msg"`                  |
| `gp` / `gps` | `git pull` / `git push`                |

---

### 📊 Monitoring

```bash
# =======================
# 1. Check backend status, Docker containers and ports
# One-shot health check for the whole stack.
alias pstatus='echo "🔍 Backend:"; lsof -i :8080 | grep LISTEN; echo "🐳 Docker:"; docker ps; echo "🗄️  MySQL:"; lsof -i :3306 | grep LISTEN'

# 2. Tail Spring Boot application logs
# Follows the main log file in real time.
alias plogs='tail -f ~/dev/java/phoebe/backend/logs/spring.log'

# 3. List all listening ports
# Handy when you need to figure out what's hogging a port.
alias ports='lsof -iTCP -sTCP:LISTEN -n -P'

# 4. Context-aware Phoebe cheat sheet
# Prints a quick reminder of the most useful commands.
alias phi='echo "📘 Phoebe Cheat Sheet: p | pbe | pfe | gw | mk | pdev | pstatus | plogs"'
```

| Command   | Description                                                           |
| --------- | --------------------------------------------------------------------- |
| `pstatus` | Check backend status, Docker containers, and ports (8080, 3306 MySQL) |
| `plogs`   | Tail the Spring Boot application logs                                 |
| `ports`   | List all listening ports on the system                                |
| `phi`     | Show context-aware Phoebe command cheat sheet                         |

---

### 🗃️ Dotfiles Management

```bash
# =======================
# 1. Navigate to dotfiles repo
alias dots='cd ~/dev/dotfiles'

# 2. Sync changes to GitHub (with confirmation)
# Shows a diff and asks before committing + pushing.
ds() {
  cd ~/dev/dotfiles || return
  git status
  read "?Sync dotfiles to GitHub? [y/N] " reply
  [[ "$reply" == "y" ]] && git add -A && git commit -m "Update dotfiles" && git push
}

# 3. Pull latest changes and apply (with automatic backup)
# Backs up your current ~/.zshrc before overwriting it.
dotsu() {
  cp ~/.zshrc ~/.zshrc.bak.$(date +%s)
  cd ~/dev/dotfiles && git pull
  cp .zshrc ~/.zshrc
  source ~/.zshrc
}

# 4. Restore config from repository (with automatic backup)
# Same as dotsu but skips the git pull — useful after a local mess.
dr() {
  cp ~/.zshrc ~/.zshrc.bak.$(date +%s)
  cp ~/dev/dotfiles/.zshrc ~/.zshrc
  source ~/.zshrc
}

# 5. Preview local changes before syncing
# Just a quick git diff of the dotfiles repo.
alias dotc='cd ~/dev/dotfiles && git diff'
```

| Command | Description                                                       |
| ------- | ----------------------------------------------------------------- |
| `dots`  | Navigate to the dotfiles repository                               |
| `ds`    | Sync changes to GitHub (with confirmation prompt)                 |
| `dotsu` | Pull latest changes and apply them (**creates automatic backup**) |
| `dr`    | Restore config from repository (**creates automatic backup**)     |
| `dotc`  | Preview local changes before syncing                              |

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

This will pull changes, back up your current `.zshrc`, and apply the update.

---

## 📄 License

MIT License. See the [LICENSE](LICENSE) file for details.