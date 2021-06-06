# Dotfiles

This repository is **heavily** based on [Alex de Sousa's Dotfiles](https://github.com/alexdesousa/dotfiles) and configures my development machine using Ansible:

```sh
# ./bin/bootstrap.sh
```

Requires the following environment variables set into the file .envrc at the root of this project.

```sh
# .envrc file
export DOTFILES_BOOTSTRAP_USER="<OS username>"
export DOTFILES_BOOTSTRAP_GIT_NAME="<Git name>"
export DOTFILES_BOOTSTRAP_GIT_EMAIL="<Git email>"
```

## Candy included

### OhMyZSH - Hab

[Hab](https://github.com/alexdesousa/hab) is an Oh My ZSH plugin that loads/unloads OS enviroment variables and functions automatically when:

    Changing directories
    After editing .envrc files.
    Opening new shells.

### fzf

[fzf](https://github.com/junegunn/fzf) is a general-porpouse command line fuzzy-finder.

### fd-find

[fd-find](https://github.com/sharkdp/fd) is a fast and user-friendly alternative to `find`.

### bat

[bat](https://github.com/sharkdp/bat) is a `cat` clone with syntax highlight and git integration.


## To-Do

### Auto stow config files

Right now, you need to execute `stow -vSt ~ *` inside `config` directory to actually apply config changes.

### Cleanup zsh scripts added from other roles

If we look at ASDF, it generates a `.zsh` file that needs to be sourced by Zsh. IT generates that file in its own directory and links it from the Zsh directory, with a hardcoded path. The reasoning for letting each role generate its own `.zsh` files should be clear, and having a look at Zsh we are trying to load each of these files
without needing to specify each name using `/**/*.zsh`. This is maybe a little bit too magical, weak and coupled.