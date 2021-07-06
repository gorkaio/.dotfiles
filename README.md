# Dotfiles

This repository is **heavily** based on [Alex de Sousa's Dotfiles](https://github.com/alexdesousa/dotfiles) and configures my development machine using Ansible:

```sh
# ./bin/bootstrap.sh
```

Requires the following environment variables set into the file `.envrc` at the root of this project.

```sh
# .envrc file
export DOTFILES_HOST_NAME="<Host name>"
export DOTFILES_USER_NAME_SHORT="<OS username>"
export DOTFILES_USER_NAME_FULL="<Full user name>"
export DOTFILES_USER_EMAIL="<User email address>"
```

The reason for not having defaults for these variables is to avoid
commiting personal data to the repository.

When `./bin/bootstrap.sh` is executed with a tag, will install all roles
necessary for that tag. This is useful for specific updates e.g:

```
# ./bin/bootstrap.sh -t erlang
```

For more information just run `./bin/bootstrap.sh -h`

> **NOTE**: You might need to add more environment variables to your `.envrc` file
>  depending on the roles you use. The ones specified here are the bare minimum ones. 

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

### mail

The [mail role](ansible/roles/mail/README.md) allows you to send and receive mail from the command line.

## To-Do

- Improve how environment vars are handed over to ansible in `bootstrap.sh`