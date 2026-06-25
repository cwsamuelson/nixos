#!/usr/bin/env bash

contains() {
  local name=$1[@]
  local filter=("${!name}")
  local needle=$2

  for item in ${filter[@]}; do
    if [[ $item == $needle ]]; then
      return 0
      break
    fi
  done

  return 1
}

join_by() {
  local d=${1-} f=${2-}
  if shift 2; then
    printf %s "$f" "${@/#/$d}"
  fi
}

unimplemented() {
  fatal "Not implemented!" $@
}

run_in_container() {
  local image="$1"
  local task_script="$2"
  shift 2
  local args=("$@")

  local container_log="$LOGS_DIR/$(echo $image | tr '/:' '__')-$(date -Iseconds | tr ':' '-').log"

  local alpine_prologue=""
  local alpine_epilogue=""

  [[ $image == alpine* ]] && {
    alpine_prologue="sh -c 'apk add bash &&"
    alpine_epilogue="'"
  }

  docker pull "$image" 2>&1 | tee -a "$container_log"

  docker run --rm \
    -v "$ROOT_DIR:/workspace" \
    -v "$CACHE_DIR:/cache" \
    -e ROOT_DIR=/workspace \
    -e CACHE_DIR=/cache \
    -e ARTIFACTORY_USER="${ARTIFACTORY_USER:-}" \
    -e ARTIFACTORY_TOKEN="${ARTIFACTORY_TOKEN:-}" \
    -w /workspace \
    "$image" \
    $alpine_prologue bash -c "source /etc/os-release 2>/dev/null || true; bash $task_script ${args[*]}" $alpine_epilogue \
    2>&1 | tee -a "$container_log"

  local exit_code=${PIPESTATUS[0]}

  if [[ $exit_code -eq 0 ]]; then
    success "Container completed: $image"
  else
    error "Container failed with exit code $exit_code: $image"
    error "See log: $container_log"
  fi

  return $exit_code
}
