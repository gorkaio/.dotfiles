# Dotfiles

This repository is **heavily** based on [Alex de Sousa's Dotfiles](https://github.com/alexdesousa/dotfiles) and configures my development machine using Ansible:

```sh
# ./bin/bootstrap.sh
```

Requires the following environment variables set into the file .envrc at the root of this project.

```sh
# .envrc file
export DOTFILES_HOSTNAME="<Host name>"
export DOTFILES_USER="<OS username>"
export DOTFILES_GIT_NAME="<Git name>"
export DOTFILES_GIT_EMAIL="<Git email>"
export DOTFILES_SMTP_APP_KEY="<Gmail SMTP app authorization key>"
export DOTFILES_SMTP_RELAY_HOST="<SMTP relay host (ie: [smtp.gmail.com]:587)>"
```

> **NOTE**: The reason for not having defaults for these variables is to avoid
> commiting personal data to the repository.

When `./bin/bootstrap.sh` is executed with a tag, will install all roles
necessary for that tag. This is useful for specific updates e.g:

```
# ./bin/bootstrap.sh -t erlang
```

> For more information just run `./bin/bootstrap.sh -h`

## Overriding Variables

All predefined variables can be overriden by creating the file `vars/custom.yml`
with the overrides inside e.g:

```yaml
---

docker_compose_version: 1.25.3
fzf_bat_version: 0.12.0
asdf_version: 0.7.4
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

### jq

[jq](https://stedolan.github.io/jq/) is a command line json processor.

