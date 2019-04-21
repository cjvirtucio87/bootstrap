#!/bin/bash

CONFIG_PATH="${HOME}/.bootstrap";
LOG_LEVEL="${LOG_LEVEL:-INFO}";
DOTFILES_URL="${DOTFILES_URL:-git@github.com:cjvirtucio87/dotfiles.git}";


install() {
  if [ ! -d "${CONFIG_PATH}" ]; then
    if [ $(echo $LOG_LEVEL | awk '{print tolower($0)}') == "debug" ]; then
      echo "initializing config folder at ${CONFIG_PATH}";
    fi

    mkdir "${CONFIG_PATH}";
  fi
}

main() {
  local subcommand=$1;

  case "${subcommand}" in
    'install')
      install;
      ;;
    *)
      echo "unsupported subcommand ${subcommand}";
      exit 1;
  esac

  echo "done"; 
}

main "$@";
