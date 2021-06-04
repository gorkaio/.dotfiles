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

