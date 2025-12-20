#!/bin/zsh
# ====================================================
# 🎨 Ultimate Terminal Configuration for macOS
# Version 4.1 | Phoebe Project 
# ====================================================
# 
# Description: This configuration file enhances your terminal experience on macOS
# with custom prompts, useful aliases, and project-specific commands for the
# Phoebe Java project. It includes Git integration, Docker management, and
# development workflow optimizations.
#
# Location: ~/.zshrc (Home directory)
# To apply: source ~/.zshrc or restart terminal
#
# Created for: Phoebe Project Developer
# Last updated: 2024
# ====================================================

# =======================
# 🎯 1. INITIALIZATION
# =======================
# Enable colors in terminal
autoload -U colors && colors

# =======================
# 🐙 2. GIT FUNCTIONS (FIXED - NO PROMPT ESCAPES)
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
        echo "✗"  # Plain text cross
    else
        echo "✔"  # Plain text checkmark (U+2714)
    fi
}

setopt PROMPT_SUBST

# =======================
# 💻 3. CUSTOM PROMPT (FIXED)
# =======================
# Multi-line prompt - prompt escapes ONLY here
PROMPT=$'%F{blue}┌─[%f%F{cyan}%n%f%F{blue}@%f%F{yellow}%m%f%F{blue}]─[%f%F{white}%B%(4~|…/|)%3~%b%f%F{blue}]%f\n%F{blue}└─%f%F{red}❯%f '

# Right side: use %F{} here, not in functions
RPROMPT='%F{red}$(parse_git_status)%f%F{green}$(parse_git_branch)%f %F{yellow}%D{%H:%M}%f'

# =======================
# 📁 4. FILE LISTING
# =======================
# Colors in terminal
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

# Enhanced ls with icons (if exa is installed)
if command -v exa &> /dev/null; then
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
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# Project aliases (Phoebe)
alias p="cd ~/dev/java/phoebe"
alias pbe="cd ~/dev/java/phoebe/backend"
alias pfe="cd ~/dev/java/phoebe/frontend"
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
# Smart Gradle wrapper function - always works from backend folder
gw() {
    if [[ -f "./gradlew" ]]; then
        ./gradlew "$@"
    elif [[ -f "../gradlew" ]]; then
        cd .. && ./gradlew "$@" && cd -
    elif [[ -d "$HOME/dev/java/phoebe/backend" ]]; then
        cd "$HOME/dev/java/phoebe/backend" && ./gradlew "$@"
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

# Make commands for Phoebe
make() {
    local makefile_path=""
    
    # Look for Makefile in current or parent directories
    if [[ -f "./Makefile" ]]; then
        makefile_path="./Makefile"
    elif [[ -f "../Makefile" ]]; then
        cd .. && command make "$@" && cd -
        return
    elif [[ -f "$HOME/dev/java/phoebe/backend/Makefile" ]]; then
        cd "$HOME/dev/java/phoebe/backend" && command make "$@"
        return
    else
        echo "❌ Makefile not found!"
        return 1
    fi
    
    command make -f "$makefile_path" "$@"
}

# Specific Make commands for Phoebe
alias mreset='cd ~/dev/java/phoebe/backend && make reset'
alias mrun='cd ~/dev/java/phoebe/backend && make run'
alias mrun-hybrid='cd ~/dev/java/phoebe/backend && make run-hybrid'
alias mclean='cd ~/dev/java/phoebe/backend && make clean'
alias mbuild='cd ~/dev/java/phoebe/backend && make build'

# Full development cycles for Phoebe
alias pdev='cd ~/dev/java/phoebe/backend && make reset && make run-hybrid'
alias pfull='cd ~/dev/java/phoebe/backend && make clean && make build && make test'
alias pdebug='cd ~/dev/java/phoebe/backend && SPRING_PROFILES_ACTIVE=debug gw bootRun --debug-jvm'

# Monitoring
alias plogs='cd ~/dev/java/phoebe/backend && tail -f logs/application.log'
alias pstats='cd ~/dev/java/phoebe/backend && docker stats'

# =======================
# 🐋 8. DOCKER MANAGEMENT (FROM ANYWHERE)
# =======================
# Docker Compose for Phoebe
alias pbd='cd ~/dev/java/phoebe/backend && docker-compose'
alias pbd-up='cd ~/dev/java/phoebe/backend && docker-compose up -d'
alias pbd-down='cd ~/dev/java/phoebe/backend && docker-compose down'
alias pbd-logs='cd ~/dev/java/phoebe/backend && docker-compose logs -f'
alias pbd-restart='cd ~/dev/java/phoebe/backend && docker-compose restart'
alias pbd-stop='cd ~/dev/java/phoebe/backend && docker-compose stop'
alias pbd-start='cd ~/dev/java/phoebe/backend && docker-compose start'

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

# =======================
# 🧹 9. DOCKER CLEANUP COMMANDS
# =======================
# 1. Stop all running containers
alias dstop-all='docker stop $(docker ps -aq)'

# 2. Remove all containers (running and stopped)
alias drm-all='docker rm $(docker ps -aq)'

# 3. Remove all unused Docker resources (images, networks, build cache)
alias dprune='docker system prune'

# 4. Remove all unused volumes (CAUTION: will remove data!)
alias dvol-prune='docker volume prune'

# 5. Remove all Docker images (CAUTION: will delete all images!)
alias drmi-all='docker rmi -f $(docker images -aq)'

# 6. Complete Docker cleanup (aggressive - removes everything unused)
alias dclean-all='docker stop $(docker ps -aq) 2>/dev/null; docker rm $(docker ps -aq) 2>/dev/null; docker system prune -a -f --volumes'

# 7. Step-by-step Docker cleanup
dclean-step() {
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

# 8. Phoebe-specific Docker cleanup
pclean-docker() {
    echo "🧹 Cleaning Phoebe Docker environment..."
    cd ~/dev/java/phoebe/backend
    docker-compose down
    docker system prune -f
    echo "✅ Phoebe Docker cleanup complete!"
}

# =======================
# ⚡ 10. GIT ALIASES
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
# 🛠️  11. DEVELOPMENT TOOLS
# =======================
# NPM/Yarn
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
    cd ~/dev/java/phoebe/backend && docker-compose ps
    
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

# Function to start Docker Desktop from terminal
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

# =======================
# 🧠 18. COMPLETION
# =======================
# Autocompletion
autoload -U compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# =======================
# 📚 19. FINAL SETTINGS
# =======================
# Syntax highlighting in less
export LESS='-R'
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'

# =======================
# 🎪 20. WELCOME MESSAGE WITH PHOEBE CHECK
# =======================
# =======================
# 🛠️  PHOEBE FOLDER DETECTOR
# =======================
# This runs after every command
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

# Hook into precmd (runs before each prompt)
autoload -Uz add-zsh-hook
add-zsh-hook precmd phoebe_folder_check

# =======================
# 🎪 20.1 INITIAL WELCOME
# =======================
# Show welcome only for primary login shell
if [[ -o login && -o interactive && -z "$TERMINAL_WELCOME_SHOWN" ]]; then
    export TERMINAL_WELCOME_SHOWN=1
    
    clear
    
    echo ""
    echo "══════════════════════════════════════════════════════════"
    echo "            🚀 Terminal Ready for Action!"
    echo "══════════════════════════════════════════════════════════"
    echo ""
    echo "📁 Phoebe Project:"
    echo "   p, pbe, gw, make, pbd"
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
# ====================================================
# 🎯 QUICK USAGE GUIDE
# ====================================================
# 
# ESSENTIAL COMMANDS:
# -------------------
# pdev                    # Full Phoebe restart: make reset && make run-hybrid
# pstatus                 # Check Phoebe system status
# pclean-docker           # Clean Phoebe Docker environment
# 
# DOCKER MANAGEMENT:
# ------------------
# docker-start           # Start Docker Desktop
# docker-stop            # Stop Docker Desktop  
# dclean-step            # Step-by-step Docker cleanup
# dclean-all             # Aggressive Docker cleanup (removes everything)
# pbd-up                 # Start Phoebe Docker containers
# pbd-down               # Stop Phoebe Docker containers
# 
# DEVELOPMENT:
# ------------
# gw clean build         # Clean and build Phoebe
# make reset             # Reset Phoebe environment
# make run-hybrid        # Run Phoebe in hybrid mode
# 
# MONITORING:
# -----------
# plogs                  # View Phoebe application logs
# ports                  # Check listening ports
# dps                    # List Docker containers
# 
# ====================================================
# 💾 Save this file to GitHub:
#   git add ~/.zshrc
#   git commit -m "Add terminal configuration for Phoebe project"
#   git push
# ====================================================