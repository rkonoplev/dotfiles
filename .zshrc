#!/bin/zsh
# ====================================================
# 🎨 Ultimate Terminal Configuration for macOS
# Version 4.4 | Phoebe Project
# ====================================================
#
# Description:
#   This configuration enhances your terminal experience
#   on macOS with git-aware prompt, project aliases,
#   safe Docker cleanup, and dotfiles sync helpers.
#
# Sections:
#   1.  Colors
#   2.  Git functions
#   3.  Custom prompt
#   4.  File listing (eza/exa/ls)
#   5.  Navigation
#   6.  Gradle wrappers
#   7.  Make wrappers
#   8.  Docker management
#   9.  Docker cleanup (safe + aggressive)
#   10. Git aliases
#   11. Development tools
#   12. System & macOS
#   13. Utilities
#   14. Productivity
#   15. Package managers
#   16. Custom functions
#   17. Environment
#   18. Completion
#   19. Final settings
#   20. Welcome + Phoebe detector
#   21. Dotfiles management
#   22. Interactive comments
# ====================================================

autoload -U colors && colors

# =======================
# 🐙 2. GIT FUNCTIONS
# =======================
# Function for git branch (returns plain text)
parse_git_branch() {
    local git_branch
    git_branch=$(git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/\1/p')
    if [[ -n "$git_branch" ]]; then
        echo " $git_branch"
    fi
}

# Function for git status (returns plain text symbols)
parse_git_status() {
    local git_state
    git_state=$(git status --porcelain 2> /dev/null)
    if [[ -n "$git_state" ]]; then
        echo "●"
    else
        echo "○"
    fi
}

setopt PROMPT_SUBST

# =======================
# 💻 3. CUSTOM PROMPT
# =======================
# Multi-line prompt - prompt escapes ONLY here
PROMPT=$'%F{blue}┌─[%f%F{cyan}%n%f%F{blue}@%f%F{yellow}%m%f%F{blue}]─[%f%F{white}%B%(4~|…/|)%3~%b%f%F{blue}]%f\n%F{blue}└─%f%F{red}❯%f '
RPROMPT='%F{red}$(parse_git_status)%f%F{green}$(parse_git_branch)%f %F{yellow}%D{%H:%M}%f'

# =======================
# 📁 4. FILE LISTING
# =======================
# Colors in terminal
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

# Enhanced ls with icons (if eza is installed)
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -la --icons --group-directories-first --git --time-style=long-iso'
    alias la='eza -a --icons --group-directories-first'
    alias lt='eza --tree --icons --group-directories-first -L 3'
elif command -v exa &> /dev/null; then
    alias ls='exa --icons --group-directories-first'
    alias ll='exa -la --icons --group-directories-first --git --time-style=long-iso'
    alias la='exa -a --icons --group-directories-first'
    alias lt='exa --tree --icons --group-directories-first -L 3'
else
    # Standard colored ls
    alias ls='ls -G'
    alias ll='ls -laGh'
    alias la='ls -AGh'
    alias l='ls -CFG'
fi

# =======================
# 🗺️  5. NAVIGATION
# =======================
# Basic navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# Project aliases (Phoebe)
alias p="cd ~/dev/java/phoebe"
alias pbe="cd ~/dev/java/phoebe/backend"
alias pfe="cd ~/dev/java/phoebe/frontend"
alias pconf="cd ~/dev/java/phoebe/backend/src/main/resources"

# Frontend projects
alias pf="cd ~/dev/frontends"
alias nx="cd ~/dev/frontends/nextjs"
alias ng="cd ~/dev/frontends/angular"
alias rn="cd ~/dev/frontends/react"

# =======================
# 🏗️  6. GRADLE WRAPPERS
# =======================
# Smart Gradle wrapper: finds gradlew in current, parent, or backend dir
gw() {
    if [[ -f "./gradlew" ]]; then
        ./gradlew "$@"
    elif [[ -f "../gradlew" ]]; then
        cd .. && ./gradlew "$@" && cd - >/dev/null
    elif [[ -d "$HOME/dev/java/phoebe/backend" ]]; then
        (cd "$HOME/dev/java/phoebe/backend" && ./gradlew "$@")
    else
        echo "❌ gradlew not found!"
        return 1
    fi
}

# Quick Gradle commands (automatically find backend)
alias grad='gw'
alias gwb='cd ~/dev/java/phoebe/backend && ./gradlew'
alias gclean='gw clean'
alias gbuild='gw build'
alias gtest='gw test'
alias grun='gw run'
alias gboot='gw bootRun'
alias gdeps='gw dependencies'

# =======================
# 🛠️  7. MAKE WRAPPERS
# =======================
# Smart Make wrapper: finds Makefile in current, parent, or backend dir
mk() {
    if [[ -f "./Makefile" ]]; then
        command make "$@"
    elif [[ -f "../Makefile" ]]; then
        (cd .. && command make "$@")
    elif [[ -f "$HOME/dev/java/phoebe/backend/Makefile" ]]; then
        (cd "$HOME/dev/java/phoebe/backend" && command make "$@")
    else
        echo "❌ Makefile not found!"
        return 1
    fi
}

# Specific Make commands for Phoebe
alias mreset='cd ~/dev/java/phoebe/backend && make reset'
alias mrun='cd ~/dev/java/phoebe/backend && make run'
alias mrun-hybrid='cd ~/dev/java/phoebe/backend && make run-hybrid'

# =======================
# 🐋 8. DOCKER MANAGEMENT (FROM ANYWHERE)
# =======================
# Docker Compose for Phoebe
alias pbd='cd ~/dev/java/phoebe/backend && docker-compose'
alias pbd-up='cd ~/dev/java/phoebe/backend && docker compose up -d'
alias pbd-down='cd ~/dev/java/phoebe/backend && docker compose down'
alias pbd-logs='cd ~/dev/java/phoebe/backend && docker compose logs -f'
alias pbd-ps='cd ~/dev/java/phoebe/backend && docker compose ps'
alias pbd-restart='pbd-down && pbd-up'

# Docker basics
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dlogs='docker logs'
alias dex='docker exec -it'

# Docker Desktop (macOS)
alias docker-start='open -a Docker'
alias docker-stop='osascript -e "quit app \"Docker\""'

# =======================
# 🧹 9. DOCKER CLEANUP COMMANDS
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

# 7. Step-by-step Docker cleanup (SAFE — asks before each step)
dclean-step() {
    echo "🧹 Docker Step-by-Step Cleanup"
    echo "------------------------------"

    echo "🛑 Step 1: Stopping all containers..."
    docker stop $(docker ps -aq) 2>/dev/null || echo "   No containers to stop"

    echo "🗑️  Step 2: Removing all containers..."
    docker rm $(docker ps -aq) 2>/dev/null || echo "   No containers to remove"

    echo "🧼 Step 3: Pruning unused images, networks and build cache..."
    docker system prune -a -f

    echo "💾 Step 4: Pruning unused volumes (data loss possible!)..."
    docker volume prune -f

    echo "✅ Docker cleanup complete!"
}

# 8. Phoebe-specific Docker cleanup
#    Only touches containers/images/volumes belonging to Phoebe.
pclean-docker() {
    echo "🧹 Cleaning Phoebe Docker environment..."
    (cd ~/dev/java/phoebe/backend && docker-compose down)
    docker system prune -f
    echo "✅ Phoebe Docker cleanup complete!"
}

# =======================
# ⚡ 10. GIT ALIASES
# =======================
alias g='git'
alias gs='git status'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git pull'
alias gps='git push'
alias gco='git checkout'
alias gb='git branch'
alias gst='git stash'

# =======================
# 🛠️  11. DEVELOPMENT TOOLS
# =======================
# NPM / Yarn
alias nr="npm run"
alias nd="npm run dev"
alias ns="npm start"
alias nt="npm test"
alias nb="npm run build"
alias ni="npm install"

# Yarn
alias y="yarn"
alias yd="yarn dev"
alias ys="yarn start"

# Angular CLI
alias ngs="ng serve"
alias ngb="ng build"
alias nggc="ng generate component"

# Next.js
alias nxd="next dev"
alias nxs="next start"

# TypeScript
alias tscw="tsc --watch"
alias tsn="ts-node"

# =======================
# 🖥️  12. SYSTEM & MACOS
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
# 🔧 13. UTILITIES
# =======================
# Safety
alias rm='rm -i'
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
alias weather='curl -s "wttr.in/Moscow?format=3"'

# Python
alias python='python3'
alias pip='pip3'

# =======================
# 🚀 14. PRODUCTIVITY
# =======================
alias please='sudo !!'
alias sl='ls'  # for typos :)

# Open applications
alias chrome='open -a "Google Chrome"'
alias vscode='code'

# =======================
# 📦 15. PACKAGE MANAGERS
# =======================
# Homebrew
alias brewup='brew update && brew upgrade && brew cleanup'
alias brewi='brew install'

# =======================
# 🛠️  16. CUSTOM FUNCTIONS
# =======================
# Function to check Phoebe status
pstatus() {
    echo "📊 Phoebe Backend Status:"
    echo "========================="

    # Check Docker
    echo "🐳 Docker containers:"
    (cd ~/dev/java/phoebe/backend && docker-compose ps)
    echo ""

    # Check ports
    echo "🔌 Listening ports:"
    lsof -i :8080 2>/dev/null | grep LISTEN || echo "❌ Port 8080 not listening"
    lsof -i :5432 2>/dev/null | grep LISTEN || echo "❌ Port 5432 (PostgreSQL) not listening"
    echo ""

    # Check application health
    echo "🏥 Health check:"
    if command -v jq &> /dev/null; then
        curl -s http://localhost:8080/actuator/health 2>/dev/null | jq .status 2>/dev/null || echo "❌ Application not responding"
    else
        curl -s http://localhost:8080/actuator/health 2>/dev/null || echo "❌ Application not responding"
    fi
}

# Function to restart application
prestart() {
    cd ~/dev/java/phoebe/backend
    echo "🧹 Cleaning..."
    gw clean
    echo "🏗️  Building..."
    gw build
    echo "🐳 Restarting Docker..."
    docker-compose down 2>/dev/null
    docker-compose up -d 2>/dev/null
    echo "🚀 Starting application..."
    gw bootRun
}

# Function to run a single test
ptest-one() {
    cd ~/dev/java/phoebe/backend
    gw test --tests "*$1*"
}

# Docker Desktop controls from terminal
docker-start() {
    echo "🚀 Starting Docker Desktop..."
    open -a Docker
    echo "✅ Docker Desktop is starting."
    echo "ℹ️  Wait for Docker icon to show in menu bar."
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
# ⚙️  17. ENVIRONMENT
# =======================
# Command history
export HISTSIZE=100000
export SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# Default editor
export EDITOR='nano'

# Paths
export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Language
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Load personal secrets if present (never commit these!)
[[ -f ~/.secrets.zsh ]] && source ~/.secrets.zsh

# =======================
# 🧠 18. COMPLETION
# =======================
autoload -U compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# =======================
# 📚 19. FINAL SETTINGS
# =======================
export LESS='-R'
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'

# =======================
# 🎪 20. WELCOME MESSAGE + PHOEBE CHECK
# =======================
# Runs after every command — reminds you when you're in a Phoebe folder
phoebe_folder_check() {
    if [[ -z "$LAST_PHOEBE_CHECK" ]] || [[ "$LAST_PHOEBE_CHECK" != "$PWD" ]]; then
        LAST_PHOEBE_CHECK="$PWD"

        if [[ "$PWD" == *"phoebe"* ]]; then
            echo ""
            echo "📁 Phoebe folder detected!"
            echo "💡 Type 'phi' for available commands"
            echo ""
        fi
    fi
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
    echo ""
    echo "📁 Phoebe Project:"
    echo "   p, pbe, gw, mk, pbd"
    echo ""
    echo "🐙 Git Commands:"
    echo "   gs, gl, gp, gps"
    echo ""
    echo "🐳 Docker Control:"
    echo "   dclean-step, docker-stop/start"
    echo ""
    echo "🛠️  Monitoring:"
    echo "   pstatus, plogs, ports"
    echo ""
    echo "🚀 Quick Start:"
    echo "   pdev - Full Phoebe restart"
    echo ""
    echo "══════════════════════════════════════════════════════════"
    echo ""
fi

# Function to show Phoebe info
phoebe-info() {
    if [[ "$PWD" == *"phoebe"* ]]; then
        echo ""
        echo "📁 You are inside the Phoebe project"
        echo "   pbe       - backend"
        echo "   pfe       - frontend"
        echo "   gw        - Gradle wrapper"
        echo "   mk        - Make wrapper"
        echo "   pdev      - full restart"
        echo "   pstatus   - system status"
        echo ""
    else
        echo ""
        echo "📁 Not inside Phoebe"
        echo "💡 Use 'p' or 'pbe' to navigate there"
        echo ""
    fi
}
alias phi='phoebe-info'

# =======================
# 🚀 FULL PHOEBE RESTART
# =======================
alias pdev='cd ~/dev/java/phoebe/backend && make reset && make run-hybrid'

# ====================================================
# 🎯 QUICK USAGE GUIDE
# ====================================================
# ESSENTIAL COMMANDS:
#   pdev           - Full Phoebe restart
#   pstatus        - Check Phoebe system status
#   pclean-docker  - Clean Phoebe Docker environment
#
# DOCKER MANAGEMENT:
#   docker-start   - Start Docker Desktop
#   docker-stop    - Stop Docker Desktop
#   dclean-step    - Step-by-step Docker cleanup
#   dclean-all     - Aggressive cleanup (removes everything)
#   pbd-up / pbd-down - Start / stop Phoebe containers
#
# DEVELOPMENT:
#   gw clean build - Clean and build Phoebe
#   make reset     - Reset Phoebe environment
#   make run-hybrid- Run Phoebe in hybrid mode
#
# MONITORING:
#   plogs          - View Phoebe application logs
#   ports          - Check listening ports
#   dps            - List Docker containers
# ====================================================

# ====================================================
# 🗃️ 21. DOTFILES MANAGEMENT
# ====================================================
# Sync dotfiles with confirmation prompt
sync-dotfiles() {
    echo "🔄 Syncing dotfiles..."
    cd ~/dev/dotfiles
    cp ~/.zshrc .

    if git diff --quiet; then
        echo "✅ No changes to sync"
    else
        echo "📝 Changes detected:"
        git diff --stat
        echo ""
        read -q "REPLY?Commit and push? (y/n) "
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git add .
            git commit -m "Update dotfiles: $(date +'%Y-%m-%d %H:%M')"
            git push
            echo "✅ Dotfiles synced to GitHub"
        else
            echo "❌ Sync cancelled"
        fi
    fi
}

# Quick sync without confirmation
quick-dots-sync() {
    cd ~/dev/dotfiles
    cp ~/.zshrc .
    git add .
    git commit -m "Quick update: $(date +'%Y-%m-%d %H:%M')" 2>/dev/null
    git push 2>/dev/null
    echo "✅ Quick sync completed"
}

# Show changes before syncing
dots-check() {
    cd ~/dev/dotfiles
    cp ~/.zshrc .
    echo "📋 Changes to be synced:"
    git diff .zshrc
    echo ""
    echo "Run 'dots-sync' to commit these changes"
}

# Restore configuration from repository (with backup)
dots-restore() {
    cp ~/.zshrc ~/.zshrc.bak.$(date +%s)
    cd ~/dev/dotfiles
    cp .zshrc ~/.zshrc
    source ~/.zshrc
    echo "✅ Configuration restored from repository (backup created)"
}

# Check repository status
dots-status() {
    cd ~/dev/dotfiles
    echo "📊 Dotfiles repository status:"
    git status
}

# Show recent commit history
dots-log() {
    cd ~/dev/dotfiles
    echo "📜 Recent commits:"
    git log --oneline -10
}

# Compare local and repository versions
dots-diff() {
    cd ~/dev/dotfiles
    echo "🔍 Comparing local vs repository:"
    git diff .zshrc
}

# Pull latest changes from repository (with backup)
dots-update() {
    cp ~/.zshrc ~/.zshrc.bak.$(date +%s)
    cd ~/dev/dotfiles
    git pull
    cp .zshrc ~/.zshrc
    source ~/.zshrc
    echo "✅ Updated from repository (backup created)"
}

# Dotfiles aliases
alias dots='cd ~/dev/dotfiles'
alias dots-sync='sync-dotfiles'
alias dots-quick='quick-dots-sync'
alias dots-check='dots-check'
alias dots-restore='dots-restore'
alias dots-status='dots-status'
alias dots-log='dots-log'
alias dots-diff='dots-diff'
alias dots-update='dots-update'
alias dots-help='echo "📚 Dotfiles: dots, dots-sync, dots-quick, dots-check, dots-restore, dots-status, dots-log, dots-diff, dots-update"'

# Short aliases (per README)
alias ds='sync-dotfiles'
alias dotsu='dots-update'
alias dr='dots-restore'
alias dotc='dots-check'

# ====================================================
# 💬 22. INTERACTIVE COMMENTS
# ====================================================
# Allows using # for comments after commands
# Example: ls -la # list all files with details
setopt INTERACTIVE_COMMENTS

# ====================================================
# 💾 Save this file to GitHub:
#   git add ~/.zshrc
#   git commit -m "Update terminal configuration"
#   git push
# ====================================================