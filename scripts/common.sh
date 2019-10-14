#! /usr/env/bin bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Set magic variables for current file and dir
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" ; pwd )"
__file="${__dir}/$( basename "${BASH_SOURCE[0]}" )"
__base="$( basename ${__file} .sh )"
__root="$( cd "$( dirname "${__dir}" )" ; pwd )"

arg1="${1:-}"

function log {
  local readonly level="$1"
  local readonly message="$2"
  local readonly timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  local readonly scriptname="$(basename "$0")"

    >&2 echo -e "${timestamp} [${level}] [$scriptname] ${message}"
}

function log_info {
  local readonly message="$1"
  log "INFO" "$message"
}

function log_warn {
  local readonly message="$1"
  log "WARN" "$message"
}

function log_error {
  local readonly message="$1"
  log "ERROR" "$message"
}

