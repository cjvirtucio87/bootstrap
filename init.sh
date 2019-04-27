#!/bin/bash

CONFIG_PATH="${HOME}/.bootstrap";
DOTFILES_URL="${DOTFILES_URL:-git@github.com:cjvirtucio87/dotfiles.git}";
LOG_LEVEL="${LOG_LEVEL:-INFO}";


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

  if [ -f "${CONFIG_PATH}/staging_dir" ]; then
    staging_dir="$(cat $CONFIG_PATH/staging_dir)";
    log_debug "${CONFIG_PATH}/staging_dir file already exists; skipping creation";
  else
    staging_dir=$(mktemp -d);
    log_debug "created staging directory ${staging_dir}";

    echo "${staging_dir}" > "${CONFIG_PATH}/staging_dir";
    log_debug "created staging_dir file with staging_dir, ${staging_dir}";
  fi

  if [ -d "${staging_dir}/git/dotfiles" ]; then
    log_debug "${CONFIG_PATH}/git/dotfiles already exists; skipping cloning";
  else 
    git clone "${DOTFILES_URL}" "${staging_dir}/git/dotfiles";
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
