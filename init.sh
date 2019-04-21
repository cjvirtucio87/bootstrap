#!/bin/bash

CONFIG_PATH="${HOME}/.bootstrap";
LOG_LEVEL="${LOG_LEVEL:-INFO}";
DOTFILES_URL="${DOTFILES_URL:-git@github.com:cjvirtucio87/dotfiles.git}";


log_debug() {
  if [ $(echo $LOG_LEVEL | awk '{print tolower($0)}') == "debug" ]; then
    echo "${1}";
  fi
}

install() {
  if [ ! -d "${CONFIG_PATH}" ]; then
    log_debug "initializing config folder at ${CONFIG_PATH}";

    mkdir "${CONFIG_PATH}";
  fi

  local staging_dir=$(mktemp -d);
  log_debug "created staging directory ${staging_dir}";

  echo "${staging_dir}" > "${CONFIG_PATH}/staging_dir";

  log_debug "creating staging_dir file with staging_dir, ${staging_dir}";
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
