#!/usr/bin/env bash
set -eo pipefail

# Set branch to master unless sepcified by the user
declare -r IV_BRANCH="${IV_BRANCH:-"main"}"
declare -r IV_REMOTE="${IV_REMOTE:-"InfernoVim/InfernoVim.git"}"
declare -r INSTALL_PREFIX="${INSTALL_PREFIX:-"$HOME/.local"}"

declare -r XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
declare -r XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"
declare -r XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

declare -r INFERNOVIM_RUNTIME_DIR="${INFERNOVIM_RUNTIME_DIR:-"$XDG_DATA_HOME/infernovim"}"
declare -r INFERNOVIM_CACHE_DIR="${INFERNOVIM_CACHE_DIR:-"$XDG_CACHE_HOME/ivim"}"
declare -r INFERNOVIM_BASE_DIR="${INFERNOVIM_BASE_DIR:-"$INFERNOVIM_RUNTIME_DIR/ivim"}"

# Arguments
declare ARGS_OVERWRITE=1
declare ARGS_SKIP_PROMPTS=1

# Warnings
declare USER_WARNINGS=""

declare -a ivim_dirs=(
  "$INFERNOVIM_RUNTIME_DIR"
  "$INFERNOVIM_CONFIG_DIR"
)

function usage() {
  echo "Usage: install.sh [<options>]"
  echo ""
  echo "Options:"
  echo "    -h, --help                            Print this help message"
  echo "    -y, --yes                             Disable confirmation prompts (answer yes to all questions)"
  echo "    --overwrite                           Overwrite previous InfernoVim installation"
}

function parse_arguments() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      -h | --help)
        usage
        exit 0
        ;;
      -y | --yes)
        ARGS_SKIP_PROMPTS=0
        ;;
      --overwrite)
        ARGS_OVERWRITE=0
        ;;
    esac
    shift
  done
}

function confirm() {
  local question="$1"
  while true; do
    msg "$question"
    read -p "[y]es or [n]o (default: no) : " -r answer
    case "$answer" in
      y | Y | YES | Yes)
        return 0
        ;;
      n | N | no | NO | No | *[[:blank:]]* | "")
        return 1
        ;;
      *)
        msg "Please answer [y]es or [n]o"
        ;;
    esac
  done
}

function main() {
  parse_arguments "$@"

  print_logo

  echo "Checking installed neovim version."
  check_neovim_ver

  echo "Checking system dependencies."
  check_dependencies

  echo "Detecting platform for managing any additional external dependencies."
  detect_platform

  if [ "$ARGS_SKIP_PROMPTS" -eq 1 ]; then
    echo "Currently no dependencies can be installed."
  else
    echo "Currently no dependencies can be installed."
  fi

  backup_old_config

  if [ "$ARGS_OVERWRITE" -eq 0 ]; then
    echo "Removing previous install."
    remove_prev_install
  fi

  echo "Creating InfernoVim file structure."
  create_base_dirs

  echo "Installing InfernoVim."
  clone_infernovim
  setup_infernovim

  msg "$USER_WARNINGS"
  echo "Thank you for install InfernoViM!"
  echo "You can start it by running: $INSTALL_PREFIX/bin/ivim"
}

function check_dependencies() {
  if ! command -v git &>/dev/null; then
    print_missing_dep "git"
    exit 1
  fi
  if ! command -v nvim &>/dev/null; then
    print_missing_dep "neovim"
    exit 1
  fi
}

function print_missing_dep() {
  echo "[ERROR]: Unable to find dependency [$1]"
  echo "Please install it first and re-run the installer. Try: $RECOMMEND_INSTALL $1"
}

function create_base_dirs() {
  for dir in "${ivim_dirs[@]}"; do
    mkdir -p "dir"
  done
}

function remove_prev_install() {
  for dir in "${ivim_dirs[@]}"; do
    [ -d "$dir" ] && rm -rf "dir"
  done
}

function detect_platform() {
  OS="$(uname -s)"
  case "$OS" in
    Linux)
      if [ -f "/etc/arch-release" ] || [ -f "/etc/artix-release" ]; then
        RECOMMEND_INSTALL="sudo pacman -S"
      elif [ -f "/etc/fedora-release" ]  || [ -f "/etc/redhat-releas" ]; then
        RECOMMEND_INSTALL="sudo dnf install -y"
      elif [ -f "/etc/gentoo-release" ]; then
        RECOMMEND_INSTALL="emerge -tv"
      else # Assume debian based
        RECOMMEND_INSTALL="sudo apt install -y"
      fi
      ;;
    FreeBSD)
      RECOMMEND_INSTALL="sudo pkg install -y"
      ;;
    NetBSD)
      RECOMMEND_INSTALL="sudo pkgin install"
      ;;
    OpenBSD)
      RECOMMEND_INSTALL="doas pkg_add"
      ;;
    Darwin)
      RECOMMEND_INSTALL="brew install"
      ;;
    *)
      echo "OS $OS is not currently supported"
      exit 1
      ;;
  esac
}

function create_bin_files() {
  cp "$INFERNOVIM_BASE_DIR/utils/bin/ivim" "$INSTALL_PREFIX/bin/ivim"
}

function create_config_files() {
  cp "$INFERNOVIM_BASE_DIR/utils/examples/config.example.lua" "$INFERNOVIM_CONFIG_DIR/config.lua"
}

function setup_infernovim() {
  remove_old_cache

  create_bin_files

  echo "Preparing Packer"
  "$INSTALL_PREFIX/bin/lvim" --headless \
    -c 'autocmd User PackerComplete quitall' \
    -c 'PackerSync'
}

function remove_old_cache() {
  local packer_cache="$INFERNOVIM_CONFIG_DIR/plugin/packer_compiled.lua"
  if [ -e "$packer_cache" ]; then
    echo "Removing old packer cache file"
    rm -f "$packer_cache"
  fi
}

# Backup ivim/ to ivim.old/
function backup_old_config() {
  local src="$INFERNOVIM_CONFIG_DIR"
  if [ ! -d "$src" ]; then
    return
  fi
  mkdir -p "$src.old"
  echo "Backup old $src to $src.old"
  OS=$(uname -s)
  case "$OS" in
    Linux | *BSD)
      cp -r "$src/"* "$src.old/."
      ;;
    Darwin)
      cp -R "$src/"* "$src.old/."
      ;;
    *)
      echo "OS $OS is not currently supported."
    ;;
  esac
  echo "Backup operation complete."
}

function check_neovim_ver() {
  local version_result=$( nvim --version )
  read -ra version_arr <<<"$version_result"
  local version=${version_arr[1]}
}

# Clone infernovim to $HOME/.local/share/infernovim/ivim
function clone_infernovim() {
  echo "https://github.com/${IV_REMOTE}"
  if ! git clone --branch "$IV_BRANCH" \
    --depth 1 "https://github.com/${IV_REMOTE}" "$INFERNOVIM_BASE_DIR"; then
    echo "Failed to clone repository. Installation failed."
    exit 1
  fi
}

function print_logo() {
  cat <<'EOF'
                                                           
           (                                             
 (         )\ )    (   (                 )   (      )    
 )\   (   (()/(   ))\  )(    (      (   /((  )\    (     
((_)  )\ ) /(_)) /((_)(()\   )\ )   )\ (_))\((_)   )\  ' 
 (_) _(_/((_) _|(_))   ((_) _(_/(  ((_)_)((_)(_) _((_))  
 | || ' \))|  _|/ -_) | '_|| ' \))/ _ \\ V / | || '  \() 
 |_||_||_| |_|  \___| |_|  |_||_| \___/ \_/  |_||_|_|_|  

EOF
}

main "$@"
