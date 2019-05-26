#!/bin/bash

CONFIG_PATH="${HOME}/.bootstrap";
DOTFILES_URL="${DOTFILES_URL:-git@github.com:cjvirtucio87/dotfiles.git}";
DOTFILES_PLATFORM="${DOTFILES_PLATFORM:-ubuntu}";
LOG_LEVEL="${LOG_LEVEL:-INFO}";
MNT_USER_PATH="${MNT_USER_PATH:-/mnt/c/Users/cjv28}";


log_debug() {
  if [ $(echo $LOG_LEVEL | awk '{print tolower($0)}') == "debug" ]; then
    echo "${1}";
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
  if [ ! -d "${CONFIG_PATH}" ]; then
    log_debug "initializing config folder at ${CONFIG_PATH}";

    mkdir "${CONFIG_PATH}";
  fi

  local staging_dir
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
