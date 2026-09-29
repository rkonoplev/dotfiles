#!/bin/zsh
# ====================================================
# 🎨 Ultimate Terminal Configuration for macOS
# Version 4.6 | Phoebe Project (SECURE + DOCUMENTED)
# ====================================================
#
# Description:
#   Enhances your macOS terminal with a git-aware prompt,
#   project aliases, safe Docker cleanup, and dotfiles
#   sync helpers for the Phoebe Java/Spring Boot project.
#
# Location:  ~/.zshrc
# Apply:     source ~/.zshrc  (or restart terminal)
#
# Sections:
#   1.  Initialization
#   2.  Git functions (safe)
#   3.  Custom prompt
#   4.  File listing (eza / exa / ls)
#   5.  Navigation
#   6.  Gradle & Make
#   6.5 Phoebe Full Cycles (pdev / pfull / pdebug)
#   7.  Docker management
#   8.  Docker cleanup (safe + aggressive)
#   9.  Git aliases
#   10. Development tools
#   11. System & macOS
#   12. Utilities
#   13. Productivity
#   14. Package managers
#   15. Custom functions (safe cd)
#   16. Environment & shell behavior
#   17. Completion
#   18. Final settings
#   19. Welcome + Phoebe detector
#   20. Dotfiles management
#   21. Interactive comments
#   22. Secrets (safe load)
#   23. Quick Usage Guide (cheat sheet)
#
# ====================================================

# =======================
# 🎯 1. INITIALIZATION
# =======================
# Enable colors in terminal
autoload -U colors && colors

# =======================
# 🐙 2. GIT FUNCTIONS (SAFE)
# =======================
# Function for git branch (returns plain text, safe outside git repos)
parse_git_branch() {
    git rev-parse --is-inside-work-tree &>/dev/null || return
    local git_branch
    git_branch=$(git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/\1/p')
    if [[ -n "$git_branch" ]]; then
        echo " $git_branch"
    fi
}

# Function for git status (returns plain text symbols, safe outside git repos)
parse_git_status() {
    git rev-parse --is-inside-work-tree &>/dev/null || return
    local git_state
    git_state=$(git status --porcelain 2> /dev/null)
    if [[ -n "$git_state" ]]; then
        echo "✗"  # Plain text cross
    else
        echo "✔"  # Plain text checkmark
    fi
}

setopt PROMPT_SUBST

# =======================
# 💻 3. CUSTOM PROMPT
# =======================
# Multi-line prompt - prompt escapes ONLY here
PROMPT=$'%F{blue}┌─[%f%F{cyan}%n%f%F{blue}@%f%F{yellow}%m%f%F{blue}]─[%f%F{white}%B%(4~|…/|)%3~%b%f%F{blue}]%f\n%F{blue}└─%f%F{red}❯%f '

# Right side: use %F{} here, not in functions
RPROMPT='%F{red}$(parse_git_status)%f%F{green}$(parse_git_branch)%f %F{yellow}%D{%H:%M}%f'

# =======================
# 📁 4. FILE LISTING (eza preferred over exa)
# =======================
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

# eza — modern ls replacement with icons
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -la --icons --group-directories-first --git --time-style=long-iso'
    alias la='eza -a --icons --group-directories-first'
    alias lt='eza --tree --icons --group-directories-first -L 3'

# exa — older modern ls replacement
elif command -v exa &> /dev/null; then
    alias ls='exa --icons --group-directories-first'
    alias ll='exa -la --icons --group-directories-first --git --time-style=long-iso'
    alias la='exa -a --icons --group-directories-first'
    alias lt='exa --tree --icons --group-directories-first -L 3'

# native fallback
else
    alias ls='ls -G'
    alias ll='ls -laGh'
    alias la='ls -AGh'
    alias l='ls -CFG'
fi

# =======================
# 🗺️ 5. NAVIGATION
# =======================
# Basic navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# Project aliases (Phoebe)
alias p="cd ~/dev/java/phoebe"
alias pbe="cd ~/dev/java/phoebe/backend"
alias pfe="cd ~/dev/frontends"
alias pconf="cd ~/dev/java/phoebe/backend/src/main/resources"

# Frontend projects
alias fe="cd ~/dev/frontends"
alias nx="cd ~/dev/frontends/nextjs"
alias ng="cd ~/dev/frontends/angular"
alias rn="cd ~/dev/frontends/react"
alias vue="cd ~/dev/frontends/vue"

# Quick navigation
alias be="cd ~/dev/java/phoebe/backend"
alias full="cd ~/dev"
alias work="cd ~/Work"
alias docs="cd ~/Documents"
alias dls="cd ~/Downloads"
alias desk="cd ~/Desktop"

# =======================
# ☕ 6. GRADLE & MAKE (Phoebe Project)
# =======================
# Smart Gradle wrapper — always works from backend folder
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

# Quick Gradle commands
alias grad='gw'
alias gwb='cd ~/dev/java/phoebe/backend && ./gradlew'
alias gclean='gw clean'
alias gbuild='gw build'
alias gtest='gw test'
alias grun='gw run'
alias gboot='gw bootRun'
alias gdeps='gw dependencies'

# Safe Make wrapper (does not override system 'make' dangerously)
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
alias mreset='cd ~/dev/java/phoebe/backend && make reset'
alias mrun='cd ~/dev/java/phoebe/backend && make run'
alias mrun-hybrid='cd ~/dev/java/phoebe/backend && make run-hybrid'
alias mclean='cd ~/dev/java/phoebe/backend && make clean'
alias mbuild='cd ~/dev/java/phoebe/backend && make build'

# =======================
# 🚀 6.5 PHOEBE FULL CYCLES
# =======================
# Full development cycles — the "big red buttons".
# These are the most useful commands in the whole config.

# Full Phoebe restart
# Resets everything and boots the hybrid (backend + frontend) stack.
alias pdev='cd ~/dev/java/phoebe/backend && make reset && make run-hybrid'

# Clean, build, and test backend
# Standard "make sure nothing is broken" pipeline for Spring Boot.
alias pfull='cd ~/dev/java/phoebe/backend && make clean && make build && make test'

# Debug mode (JDWP on port 5005)
# Runs Spring Boot with a remote debugger attached.
alias pdebug='cd ~/dev/java/phoebe/backend && SPRING_PROFILES_ACTIVE=debug gw bootRun --debug-jvm'

# =======================
# 🐋 7. DOCKER MANAGEMENT
# =======================
# Docker Compose for Phoebe
alias pbd='cd ~/dev/java/phoebe/backend && docker-compose'
alias pbd-up='cd ~/dev/java/phoebe/backend && docker-compose up -d'
alias pbd-down='cd ~/dev/java/phoebe/backend && docker-compose down'
alias pbd-logs='cd ~/dev/java/phoebe/backend && docker-compose logs -f'
alias pbd-restart='cd ~/dev/java/phoebe/backend && docker-compose restart'
alias pbd-stop='cd ~/dev/java/phoebe/backend && docker-compose stop'
alias pbd-start='cd ~/dev/java/phoebe/backend && docker-compose start'
alias pbd-ps='cd ~/dev/java/phoebe/backend && docker-compose ps'

# General Docker commands
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dpsa='docker ps -a'
alias dim='docker images'
alias dlog='docker logs'
alias dlogf='docker logs -f'
alias dex='docker exec -it'
alias dstop='docker stop'
alias drm='docker rm'
alias drmi='docker rmi'

# Docker Desktop (macOS)
docker-start() {
    echo "🚀 Starting Docker Desktop..."
    open -a Docker
    echo "✅ Docker Desktop is starting. Wait for the icon in the menu bar."
}

docker-stop() {
    echo "🛑 Stopping Docker Desktop..."
    osascript -e 'quit app "Docker"'
    echo "✅ Docker Desktop stopped."
}

docker-restart() {
    docker-stop
    sleep 2
    docker-start
}

# =======================
# 🧹 8. DOCKER CLEANUP (SECURE)
# =======================
# 1. Stop all running containers
#    Gracefully halts every container. Does NOT delete anything.
alias dstop-all='docker stop $(docker ps -aq)'

# 2. Remove all containers (running and stopped)
#    Deletes every container definition. Stop them first.
alias drm-all='docker rm $(docker ps -aq)'

# 3. Remove unused Docker resources (images, networks, build cache)
#    Frees disk space. Safe to run anytime.
alias dprune='docker system prune'

# 4. Remove unused volumes (CAUTION: will remove data!)
#    ⚠️  Any persistent data in those volumes is LOST.
alias dvol-prune='docker volume prune'

# 5. Remove ALL Docker images (CAUTION: will delete all images!)
#    Force-removes every image. Unpushed images will need rebuild.
alias drmi-all='docker rmi -f $(docker images -aq)'

# 6. Complete Docker cleanup (aggressive — removes everything unused)
#    Nuclear option: stop + rm + prune -a --volumes.
alias dclean-all='docker stop $(docker ps -aq) 2>/dev/null; docker rm $(docker ps -aq) 2>/dev/null; docker system prune -a -f --volumes'

# 7. Step-by-step Docker cleanup WITH CONFIRMATION
#    Safe mode: asks before doing anything destructive.
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

# 8. Phoebe-specific Docker cleanup (safe subshell)
#    Only touches containers/images belonging to the Phoebe project.
pclean-docker() {
    echo "🧹 Cleaning Phoebe Docker environment..."
    (
        cd ~/dev/java/phoebe/backend || return
        docker-compose down
        docker system prune -f
    )
    echo "✅ Phoebe Docker cleanup complete!"
}

# =======================
# ⚡ 9. GIT ALIASES
# =======================
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gb='git branch'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gp='git pull'
alias gps='git push'

# =======================
# 🛠️ 10. DEVELOPMENT TOOLS
# =======================
# NPM / Yarn
alias nr="npm run"
alias nd="npm run dev"
alias ns="npm start"
alias nt="npm test"
alias nb="npm run build"
alias ni="npm install"

alias y="yarn"
alias yd="yarn dev"
alias ys="yarn start"

# Frameworks
alias ngs="ng serve"
alias ngb="ng build"
alias nggc="ng generate component"

alias nxd="next dev"
alias nxs="next start"

alias tscw="tsc --watch"
alias tsn="ts-node"

# =======================
# 🖥️ 11. SYSTEM & MACOS
# =======================
# Finder
alias showhidden='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidehidden='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'

# Network
alias ip='curl -s ifconfig.me'
alias localip='ipconfig getifaddr en0'
alias ports='lsof -i -P -n | grep LISTEN'

# Port checking
alias port3000='lsof -i :3000'
alias port4200='lsof -i :4200'
alias port8080='lsof -i :8080'

# =======================
# 🔧 12. UTILITIES
# =======================
# Safety
alias rm='rm -I'   # -I prompts once before removing >3 files, safer than -i
alias cp='cp -i'
alias mv='mv -i'

# Files and disks
alias du='du -h'
alias df='df -h'
alias sizes='du -sh * | sort -hr'

# Text and search
alias grep='grep --color=auto'

# Utilities
alias c='clear'
alias h='history'
alias weather='curl -s "wttr.in/Setubal?format=3"'

# Python
alias python='python3'
alias pip='pip3'

# =======================
# 🚀 13. PRODUCTIVITY
# =======================
alias please='sudo !!'
alias sl='ls'

# Open applications
alias chrome='open -a "Google Chrome"'
alias vscode='code'

# =======================
# 📦 14. PACKAGE MANAGERS
# =======================
# Homebrew
alias brewup='brew update && brew upgrade && brew cleanup'
alias brewi='brew install'

# =======================
# 🛠️ 15. CUSTOM FUNCTIONS (SAFE CD)
# =======================
# Function to check Phoebe status (MySQL port 3306, subshell for cd)
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
    if command -v jq &> /dev/null; then
        curl -s http://localhost:8080/actuator/health 2>/dev/null | jq .status 2>/dev/null || echo "❌ Application not responding"
    else
        curl -s http://localhost:8080/actuator/health 2>/dev/null || echo "❌ Application not responding"
    fi
}

# Function to restart application (subshell prevents directory change)
prestart() {
    (
        cd ~/dev/java/phoebe/backend || return
        echo "🧹 Cleaning..."
        gw clean
        echo "🏗️  Building..."
        gw build
        echo "🐳 Restarting Docker..."
        docker-compose down 2>/dev/null
        docker-compose up -d 2>/dev/null
        echo "🚀 Starting application..."
        gw bootRun
    )
}

# Function to run a single test (subshell prevents directory change)
ptest-one() {
    (
        cd ~/dev/java/phoebe/backend || return
        gw test --tests "*$1*"
    )
}

# =======================
# ⚙️ 16. ENVIRONMENT & SHELL BEHAVIOR
# =======================
# History
export HISTSIZE=100000
export SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Editor
export EDITOR='nano'
export VISUAL='nano'

# PATH (zsh-native array to avoid duplicates)
path=(
  /opt/homebrew/bin
  /usr/local/bin
  $HOME/.local/bin
  $path
)
export PATH

# Language
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Colima settings (if used instead of Docker Desktop)
export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock" 2>/dev/null
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE="/var/run/docker.sock" 2>/dev/null

# =======================
# 🧠 17. COMPLETION
# =======================
autoload -U compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# =======================
# 📚 18. FINAL SETTINGS
# =======================
export LESS='-R'
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'

# =======================
# 🎪 19. WELCOME MESSAGE & FOLDER DETECTOR
# =======================
# Runs after every command — reminds you when you're in a Phoebe folder
phoebe_folder_check() {
    [[ "$PWD" != *"phoebe"* ]] && return
    [[ -n "$PHOEBE_HINT_SHOWN" ]] && return
    PHOEBE_HINT_SHOWN=1
    echo ""
    echo "📁 Phoebe folder detected!"
    echo "💡 Type 'phi' for available commands"
    echo ""
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd phoebe_folder_check

# Initial welcome (only for primary login shell)
if [[ -o login && -o interactive && -z "$TERMINAL_WELCOME_SHOWN" ]]; then
    export TERMINAL_WELCOME_SHOWN=1

    clear
    echo ""
    echo "══════════════════════════════════════════════════════════"
    echo "            🚀 Terminal Ready for Action!"
    echo "══════════════════════════════════════════════════════════"
    echo "📁 Phoebe: p, pbe, gw, mk, pbd"
    echo "🐙 Git: gs, gl, gp, gps"
    echo "🐳 Docker: dclean-step, docker-stop/start"
    echo "🛠️  Monitor: pstatus, plogs, ports"
    echo "🚀 Quick: pdev (Full Phoebe restart)"
    echo "══════════════════════════════════════════════════════════"
    echo ""
fi

# Function to show Phoebe info
phoebe-info() {
    if [[ "$PWD" == *"phoebe"* ]]; then
        echo ""
        echo "📁 Phoebe Project Commands:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "🚀  pdev      - Full restart"
        echo "📊  pstatus   - System status"
        echo "🔨  gw build  - Build project"
        echo "🐳  pbd-up    - Start Docker containers"
        echo "📝  plogs     - View application logs"
        echo "🛑  pbd-down  - Stop Docker containers"
        echo "🧹  pclean-docker - Clean Docker"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
    else
        echo "❌ Not in Phoebe project folder"
        echo "💡 Use 'p' or 'pbe' to navigate there"
    fi
}
alias phi='phoebe-info'

# =======================
# 🗃️ 20. DOTFILES MANAGEMENT (WITH BACKUPS)
# =======================
# Sync dotfiles with confirmation prompt
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

# Quick sync without confirmation
quick-dots-sync() {
    cd ~/dev/dotfiles || return
    cp ~/.zshrc .
    git add .
    git commit -m "Quick update: $(date +'%Y-%m-%d %H:%M')" 2>/dev/null
    git push 2>/dev/null
    echo "✅ Quick sync completed"
}

# Preview changes before syncing
dots-check() {
    cd ~/dev/dotfiles || return
    cp ~/.zshrc .
    echo "📋 Changes to be synced:"
    git diff .zshrc
    echo ""
    echo "Run 'ds' to commit these changes"
}

# Restore config from repository (with automatic backup)
dots-restore() {
    cd ~/dev/dotfiles || return
    cp ~/.zshrc "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null
    cp .zshrc ~/.zshrc
    source ~/.zshrc
    echo "✅ Configuration restored from repository (old version backed up)"
}

# Show repository status
dots-status() {
    cd ~/dev/dotfiles || return
    echo "📊 Dotfiles repository status:"
    git status
}

# Show recent commit history
dots-log() {
    cd ~/dev/dotfiles || return
    echo "📜 Recent commits:"
    git log --oneline -10
}

# Compare local and repository versions
dots-diff() {
    cd ~/dev/dotfiles || return
    echo "🔍 Comparing local vs repository:"
    git diff .zshrc
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

# Dotfiles aliases
alias dots='cd ~/dev/dotfiles'
alias ds='sync-dotfiles'
alias dots-quick='quick-dots-sync'
alias dotc='dots-check'
alias dr='dots-restore'
alias dos='dots-status'
alias dl='dots-log'
alias dd='dots-diff'
alias dotsu='dots-update'
alias dots-help='echo "📚 Dotfiles: dots, ds, dotc, dr, dos, dl, dd, dotsu, dots-quick"'

# =======================
# 💬 21. INTERACTIVE COMMENTS
# =======================
setopt INTERACTIVE_COMMENTS

# =======================
# 🔐 22. SECRETS (SAFE LOAD)
# =======================
# Load personal secrets (tokens, passwords) if the file exists.
# This file is in .gitignore and will never be pushed to GitHub.
[[ -f ~/.secrets.zsh ]] && source ~/.secrets.zsh

# ====================================================
# 🎯 23. QUICK USAGE GUIDE (cheat sheet)
# ====================================================
# ESSENTIAL:
#   phi              - Show this cheat sheet (context-aware)
#   pdev             - Full Phoebe restart
#   pstatus          - Check system status (backend + Docker + ports)
#   pclean-docker    - Clean Phoebe Docker environment
#   pfull            - Clean + build + test backend
#   pdebug           - Run backend with remote debugger (port 5005)
#
# NAVIGATION:
#   p / pbe / pfe    - project / backend / frontends
#   pconf            - backend src/main/resources
#   nx / ng / rn     - Next.js / Angular / React
#   vue              - Vue frontend
#
# BUILD:
#   gw clean build   - clean + build backend
#   gw bootRun       - run Spring Boot
#   gw test          - run tests
#   mk reset         - reset Phoebe environment
#   mk run-hybrid    - run in hybrid mode
#
# DOCKER:
#   pbd-up / pbd-down    - start / stop Phoebe containers
#   pbd-logs / pbd-ps    - logs / status
#   dps                  - list all Docker containers
#   dclean-step          - safe step-by-step cleanup (asks)
#   dclean-all           - aggressive cleanup (removes everything)
#   pclean-docker        - clean only Phoebe Docker resources
#   docker-start / stop  - control Docker Desktop app
#
# GIT:
#   gs / gl / gd     - status / pretty log / diff
#   gcm "msg"        - commit with message
#   gp / gps         - pull / push
#   gco / gb         - checkout / branch
#
# MONITORING:
#   pstatus          - full stack health check
#   plogs            - tail Spring Boot logs
#   pstats           - Docker container stats
#   ports            - list all listening ports
#
# DOTFILES:
#   dots             - navigate to dotfiles repo
#   ds               - sync to GitHub (with confirmation)
#   dotc             - preview changes before syncing
#   dr               - restore from repo (with backup)
#   dotsu            - pull latest (with backup)
#   dots-help        - list all dotfiles commands
# ====================================================