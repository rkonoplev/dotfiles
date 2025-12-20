# Dotfiles

My terminal configuration optimized for Phoebe (Java/Spring Boot) development.

## Features
- Custom zsh prompt with git integration
- Phoebe project navigation aliases (`p`, `pbe`, `pfe`)
- Smart Gradle wrapper (`gw`) and Make commands
- Docker management shortcuts
- Git aliases and productivity tools
- Development workflow optimizations
- Colorful prompt with time and git status

## Installation

### Quick install (one command):
```bash
curl -s https://raw.githubusercontent.com/rkonoplev/dotfiles/main/install.sh | bash
```
Manual installation:
```bash
git clone https://github.com/rkonoplev/dotfiles.git ~/dotfiles
cd ~/dotfiles
cp .zshrc ~/.zshrc
source ~/.zshrc
```
## Usage

### After installation:

Project Navigation
```bash
p      # Go to Phoebe project root
pbe    # Go to Phoebe backend
pfe    # Go to Phoebe frontend
pstatus # Check system status
pdev   # Full Phoebe restart (make reset && make run-hybrid)
```
### Build Commands

```bash
gw           # Smart Gradle wrapper (auto-finds backend)
gw build     # Build project
gw bootRun   # Run Spring Boot application
make         # Make commands (auto-finds Makefile)
make reset   # Reset Phoebe environment
```
### Docker Management
```bash
pbd-up      # Start Phoebe Docker containers
pbd-down    # Stop Phoebe Docker containers
pbd-logs    # View Docker logs
dclean-step # Step-by-step Docker cleanup
docker-stop # Stop Docker Desktop
docker-start # Start Docker Desktop
```
### Git Shortcuts
```bash
gs   # git status
gl   # git log --oneline --graph --decorate
gp   # git pull
gps  # git push
gcm  # git commit -m
```
### Monitoring
```bash
plogs  # Tail application logs
ports  # Check listening ports
pstats # Docker container statistics
phi    # Show all Phoebe commands
```
## Quick Reference

| Command | Description |
|---------|-------------|
| `p` | Go to Phoebe project |
| `pbe` | Go to Phoebe backend |
| `pdev` | Full Phoebe restart |
| `pstatus` | Check system status |
| `gw build` | Build project |
| `make reset` | Reset environment |
| `pbd-up` | Start Docker |
| `dclean-step` | Clean Docker |
| `phi` | Show all commands |

## Project Structure

This configuration is optimized for the following project structure:

```text
~/dev/java/phoebe/
├── backend/     # Spring Boot application
├── frontend/    # Frontend application
└── database/    # Database scripts
```



## Requirements

- macOS (tested on macOS Ventura+)
- zsh (default on macOS Catalina+)
- Docker (optional, for container commands)
- Java/Spring Boot (for Phoebe project)

## Updating

To update your local configuration from the repository:

```bash
cd ~/dotfiles
git pull
cp .zshrc ~/.zshrc
source ~/.zshrc
```

##License
MIT License. See [LICENSE](LICENSE) file for details.