# bymoxb's dotfiles

Personal configuration files for my development environment.

## Files

- `.gitconfig` — Global Git configuration (user info, aliases, settings).  
- `.zshrc` — Zsh shell configuration (aliases, environment variables, prompt, plugins).  
- `.vimrc` — Vim editor configuration (settings, key mappings, plugins).

## Installation

Clone the repository:

```
git clone https://github.com/bymoxb/dotfiles.git dotfiles
```

Create symbolic links to your home directory:

```
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.vimrc ~/.vimrc
```

Reload your shell configuration:

```
source ~/.zshrc
```

## Notes

- These files store personal preferences and shell/editor configuration.
- Modify them according to your workflow and needs.
- Do not commit sensitive information such as API keys or private credentials.
