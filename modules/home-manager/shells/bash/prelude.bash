#!/usr/bin/env bash

# # BASH_SOURCE will be consistent, even when sourced
# THIS_DIR=$(dirname $BASH_SOURCE)

# run once
[[ -n $_PRELUDE ]] && [[ $_PRELUDE == 1 ]] && { return 0 2>/dev/null || exit 0; }

export _PRELUDE=1
export LOG_LEVEL=${LOG_LEVEL:-debug}
export ROOT_DIR=${ROOT_DIR:-${DEVENV_ROOT:-$(dirname $0)}}
export ROOT_DIR=$(realpath -s "$ROOT_DIR")
export CACHE_DIR=${CACHE_DIR:-$ROOT_DIR/package-cache}
export TRANSFER_DIR=${TRANSFER_DIR:-$ROOT_DIR/transfer/Transfer WIP}

source /etc/os-release
source $ROOT_DIR/libs.bash
source $ROOT_DIR/logging.bash
# source $ROOT_DIR/image-list.bash
source $ROOT_DIR/what.bash
source $ROOT_DIR/where.bash

# Optional: Create symlink to external cache if WSL_CACHE_PATH is set
if [[ -n "${WSL_CACHE_PATH:-}" ]] && [[ ! -d $CACHE_DIR ]] && [[ -d "$WSL_CACHE_PATH" ]]; then
  ln -sf "$WSL_CACHE_PATH" "$CACHE_DIR"
fi

timestamp=$(date -I seconds &>/dev/null || date -I)
timestamp=${timestamp//:/-}
export timestamp

# Set up logging to capture all command output
export LOG_DIR=${LOG_DIR:-$ROOT_DIR/logs}
mkdir -p "$LOG_DIR"

# Function to enable logging for a task
setup_task_logging() {
  local task_name="${1:-task}"
  
  if [[ -z "${_LOG_SETUP:-}" ]]; then
    export _LOG_SETUP=1
    export LOG_FILE="$LOG_DIR/${task_name}-${timestamp}.log"
    
    info "Logging to: ./logs/${task_name}-${timestamp}.log"

    # Log all command output (stdout and stderr) to file
    # Keep our info/success/error messages on console
    # exec > >(tee -a "$LOG_FILE") 2>&1
  fi
}
