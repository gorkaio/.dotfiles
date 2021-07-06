#!/usr/bin/env bash

set -e

##################
# Global variables

ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
CONFIG_DIR="$ROOTDIR/config"
DOTFILES_VARS="$ROOTDIR/.envrc"
ANSIBLE_ROOTDIR="$ROOTDIR/ansible"
DOTFILES_HOSTS="$ANSIBLE_ROOTDIR/hosts"
DOTFILES_PLAYBOOK="$ANSIBLE_ROOTDIR/dotfiles.yml"
DOTFILES_CUSTOM_CONFIG="$ANSIBLE_ROOTDIR/vars/custom.yml"

###########
# Functions

# Prints an error.
function __bootstrap_error {
  local message="$1"

  (>&2 echo -e "\033[1;91m[ERROR]    $message\033[0;0m")
}

# Prints bootstrap usage.
function __bootstrap_usage {
  if [ -n "$2" ]
  then
    __bootstrap_error "$2"
  fi

  echo "
  Installs new system given some environment variables.

  Usage:
    # $0 [-t <TAG> -h]

  Arguments:
    -h       - Shows this help.
    -t <TAG> - Role tag

  Environment variables:
    DOTFILES_HOST_NAME       - Host name.
    DOTFILES_USER_NAME_SHORT - System user name (ie: gorka).
    DOTFILES_USER_NAME_FULL  - Full user name (ie: Gorka López de Torre)
    DOTFILES_USER_EMAIL      - User e-mail.

  Tags:
    $(ls "$ANSIBLE_ROOTDIR/roles" | tr "\n" " ")
  "

  exit "$1"
}

###########
# Arguments

while getopts :t:h option
do
  case "$option" in
    h)
      __bootstrap_usage 0
      ;;
    t)
      TAG="${OPTARG}"
      ;;
    *)
      ;;
  esac
done

if [ ! -f "$DOTFILES_VARS" ]; then
  __bootstrap_usage 1 "Required .envrc file not found. Check README file."
  exit 1
fi

source "$DOTFILES_VARS" 2> /dev/null

if [ -z "$TAG" ]
then
  TAG="all"
fi

if [ -z "$DOTFILES_HOST_NAME" ]
then
  __bootstrap_usage 1 "Cannot find variable DOTFILES_HOST_NAME"
fi

if [ -z "$DOTFILES_USER_NAME_SHORT" ]
then
  __bootstrap_usage 1 "Cannot find variable DOTFILES_USER_NAME_SHORT"
fi

if [ "$TAG" = "all" ] || [ "$TAG" = "git" ]
then
  if [ -z "$DOTFILES_USER_NAME_FULL" ]
  then
    __bootstrap_usage 1 "Cannot find variable DOTFILES_USER_NAME_FULL"
  fi

  if [ -z "$DOTFILES_USER_EMAIL" ]
  then
    __bootstrap_usage 1 "Cannot find variable DOTFILES_USER_EMAIL"
  fi
fi

DOTFILES_ROOT="$ROOTDIR"
DOTFILES_USER_HOME=$(
  getent passwd "$DOTFILES_USER_NAME_SHORT" |
  cut -d: -f6
)

###########
# Bootstrap

apt update && apt install -y sudo ansible

apt autoremove

export PATH="$PATH:/usr/sbin"

adduser "$DOTFILES_USER_NAME_SHORT" sudo

if [ ! -f "$DOTFILES_CUSTOM_CONFIG" ]
then
  sudo -u "$DOTFILES_USER_NAME_SHORT" \
    echo "---" > "$DOTFILES_CUSTOM_CONFIG"
fi

sudo -u "$DOTFILES_USER_NAME_SHORT" \
  DOTFILES_ROOT="$DOTFILES_ROOT" \
  DOTFILES_HOST_NAME="$DOTFILES_HOST_NAME" \
  DOTFILES_USER_HOME="$DOTFILES_USER_HOME" \
  DOTFILES_USER_NAME_SHORT="$DOTFILES_USER_NAME_SHORT" \
  DOTFILES_USER_NAME_FULL="$DOTFILES_USER_NAME_FULL" \
  DOTFILES_USER_EMAIL="$DOTFILES_USER_EMAIL" \
  DOTFILES_SMTP_APP_KEY="$DOTFILES_SMTP_APP_KEY" \
  DOTFILES_SMTP_RELAY_HOST="$DOTFILES_SMTP_RELAY_HOST" \
  ansible-playbook -i "$DOTFILES_HOSTS" "$DOTFILES_PLAYBOOK" \
  --ask-become-pass \
  --tags "$TAG"

su -c "cd \"$CONFIG_DIR\" && stow -vSt ~ *" "$DOTFILES_USER_NAME_SHORT"

exit 0