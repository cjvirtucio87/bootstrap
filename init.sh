#!/bin/bash

CONFIG_PATH="${HOME}/.bootstrap";
DOTFILES_URL="${DOTFILES_URL:-git@github.com:cjvirtucio87/dotfiles.git}";
DOTFILES_PLATFORM="${DOTFILES_PLATFORM:-ubuntu}";
LOG_LEVEL="${LOG_LEVEL:-INFO}";
MNT_USER_PATH="${MNT_USER_PATH:-/mnt/c/Users/cjv28}";


log_debug() {
  if [[ $(echo $LOG_LEVEL | awk '{print tolower($0)}') =~ ^(debug|error)$ ]]; then
    echo "[DEBUG] ${1}";
  fi
}

log_error() {
  if [[ $(echo $LOG_LEVEL | awk '{print tolower($0)}') =~ ^(info|debug|error)$ ]]; then
    echo "[ERROR] ${1}";
  fi
}

log_warn() {
  if [[ $(echo $LOG_LEVEL | awk '{print tolower($0)}') =~ ^(info|warn|debug|error)$ ]]; then
    echo "[WARN] ${1}";
  fi
}

symlink_to_src() {
  local src_dir=$1;
  local dest_dir=$2;

  find $src_dir \
    -maxdepth 1 \
    -mindepth 1 \
    -name '.*' \
    -exec bash -c "symlink_name=\"${dest_dir}/\$(basename {})\"; if [ ! -L \"\${symlink_name}\" ]; then ln -s {} \"\${symlink_name}\"; fi" \;
}

deploy_dotfiles() {
  local src_dir=$1;
  local dest_dir=$2;  

  rsync -av $src_dir/.[^.]* "${dest_dir}";
}

install() {
  log_debug "validating required variables";

  if [ ! -d "${HOME}" ]; then
    log-error "HOME, ${HOME}, does not exist";
    exit 1;
  fi

  if [ ! -d "${MNT_USER_PATH}" ]; then
    log_error "MNT_USER_PATH, ${MNT_USER_PATH}, does not exist";
    exit 1;
  fi

  local clean_post
  local clean_pre

  while (( "$#" )); do
    case "$1" in
      '-d' | '--clean-post')
        clean_post=1;
        shift;
        ;;
      '-c' | '--clean-pre')
        clean_pre=1;
        shift;
        ;;
      *)
    esac
  done

  local staging_dir

  if [ -n "${clean_pre}" ]; then
    if [ -d "${CONFIG_PATH}" ]; then
      log_debug "cleaning prior to install";

      if [ -f "${CONFIG_PATH}/staging_dir" ]; then
        staging_dir="$(cat $CONFIG_PATH/staging_dir)";

        if [ -d "${staging_dir}" ]; then
          log_debug "cleaning staging_dir, ${staging_dir}";

          rm -rf "${staging_dir}";
        else
          log_warn "staging_dir, ${staging_dir}, does not exist; skipping removal";
        fi
      else
        log_warn "staging_dir file at ${CONFIG_PATH}/staging_dir does not exist; skipping removal";
      fi

      log_debug "cleaning config directory, ${CONFIG_PATH}";
      rm -rf "${CONFIG_PATH}";
    else
      log_warn "used --clean-pre flag when directory ${CONFIG_PATH} does not exist; skipping removal";
    fi
  fi

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

  local src_dir="${staging_dir}/git/dotfiles/${DOTFILES_PLATFORM}";

  log_debug "deploying dotfiles from ${src_dir} to ${MNT_USER_PATH}";

  deploy_dotfiles "${src_dir}" "${MNT_USER_PATH}";

  log_debug "creating symlinks in ${HOME} to dotfiles in ${MNT_USER_PATH}";

  symlink_to_src "${MNT_USER_PATH}" "${HOME}";

  if [[ -n "${clean_post}" ]]; then
    echo 'clean post flag is active';
  fi
}

main() {
  local subcommand=$1;
  shift

  case "${subcommand}" in
    'install')
      install "$@";
      ;;
    *)
      echo "unsupported subcommand ${subcommand}";
      exit 1;
  esac

  echo "done"; 
}

main "$@";
