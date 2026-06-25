#!/usr/bin/env bash

command -v log &>/dev/null &&  { return 0 2>/dev/null || exit 0; }

export ROOT_DIR=${ROOT_DIR:-${DEVENV_ROOT:-$(dirname $0)}}
source $ROOT_DIR/colors.bash

log_level=${LOG_LEVEL:-warn}
prefix=

export log_level
export prefix

log() {
  declare -A levels=(
    [fatal]=0
    [critical]=1
    [error]=2
    [warn]=3
    [warning]=3
    [info]=4
    [debug]=5
    [trace]=6
  )

  declare -A colors=(
    [fatal]=black
    [critical]=black
    [error]=red
    [warn]=yellow
    [warning]=yellow
    [info]=green
    [debug]=purple
    [trace]=blue
  )
  local colors
  local levels

  local level=$1
  shift
  local n=${levels[$level]}
  local lln=${levels[$log_level]}

  # lt over le forces fatal to always log
  if [[ $lln -lt $n ]]; then
    return 0
  fi

  prompt=$level
  [[ -n $prefix ]] && prompt="$prefix $level"

  ${colors[$level]} "[$prompt]: $@"
}

fatal() {
  log fatal "$@"
  exit 1
}

critical() {
  log critical "$@"
}

error() {
  log error "$@"
}

warn() {
  log warn "$@"
}

info() {
  log info "$@"
}

debug() {
  log debug "$@"
}

trace() {
  log trace "$@"
}

success() {
  green "✓ $@"
}

log_with_timestamp() {
  local level=$1
  shift
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  log "$level" "[$timestamp] $@"
}

log_section() {
  local title="$1"
  local width=60
  local padding=$(( (width - ${#title} - 2) / 2 ))
  echo
  green "$(printf '=%.0s' $(seq 1 $width))"
  green "$(printf '=%.0s' $(seq 1 $padding)) $title $(printf '=%.0s' $(seq 1 $padding))"
  green "$(printf '=%.0s' $(seq 1 $width))"
  echo
}

log_step() {
  local step=$1
  shift
  info "→ $step: $@"
}

export -f log
export -f fatal
export -f critical
export -f error
export -f warn
export -f info
export -f debug
export -f trace
export -f success
export -f log_with_timestamp
export -f log_section
export -f log_step
