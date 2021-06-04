#!/usr/bin/env bash

set -e

##################
# Global variables

ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
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
    DOTFILES_USER      - Linux user.
    DOTFILES_GIT_NAME  - Git user name.
    DOTFILES_GIT_EMAIL - Git user e-mail.

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

source "$DOTFILES_VARS" 2> /dev/null

if [ -z "$TAG" ]
then
  TAG="all"
fi

if [ -z "$DOTFILES_USER" ]
then
  __bootstrap_usage 1 "Cannot find variable DOTFILES_USER"
fi

if [ "$TAG" = "all" ] || [ "$TAG" = "git" ]
then
  if [ -z "$DOTFILES_GIT_NAME" ]
  then
    __bootstrap_usage 1 "Cannot find variable DOTFILES_GIT_NAME"
  fi

  if [ -z "$DOTFILES_GIT_EMAIL" ]
  then
    __bootstrap_usage 1 "Cannot find variable DOTFILES_GIT_EMAIL"
  fi
fi

DOTFILES_ROOT="$ANSIBLE_ROOTDIR"
DOTFILES_USER_HOME=$(
  getent passwd "$DOTFILES_USER" |
  cut -d: -f6
)

###########
# Bootstrap

apt update && apt install -y sudo ansible

apt upgrade

apt autoremove

export PATH="$PATH:/usr/sbin"

adduser "$DOTFILES_USER" sudo

if [ ! -f "$DOTFILES_CUSTOM_CONFIG" ]
then
  sudo -u "$DOTFILES_USER" \
    echo "---" > "$DOTFILES_CUSTOM_CONFIG"
fi

sudo -u "$DOTFILES_USER" \
  DOTFILES_ROOT="$DOTFILES_ROOT" \
  DOTFILES_USER="$DOTFILES_USER" \
  DOTFILES_USER_HOME="$DOTFILES_USER_HOME" \
  DOTFILES_GIT_NAME="$DOTFILES_GIT_NAME" \
  DOTFILES_GIT_EMAIL="$DOTFILES_GIT_EMAIL" \
  ansible-playbook -i "$DOTFILES_HOSTS" "$DOTFILES_PLAYBOOK" \
  --ask-become-pass \
  --tags "$TAG"

exit 0
