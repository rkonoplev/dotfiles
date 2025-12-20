# Dotfiles

My terminal configuration optimized for Phoebe (Java/Spring Boot) development.

## Features
- Custom zsh prompt with git integration
- Phoebe project navigation aliases (p, pbe, pfe)
- Smart Gradle wrapper (gw) and Make commands
- Docker management shortcuts
- Git aliases and productivity tools

## Installation

### Quick install:
```bash
curl -s https://raw.githubusercontent.com/rkonoplev/dotfiles/main/install.sh | bash
```### Manual:
```bash
git clone https://github.com/rkonoplev/dotfiles.git ~/dotfiles
cp ~/dotfiles/.zshrc ~/.zshrc
source ~/.zshrc
```
Usage
After installation:

p, pbe - Navigate to Phoebe project

phi - Show all Phoebe commands

dclean-step - Clean Docker environment

gw, make - Build commands

License
MIT License
