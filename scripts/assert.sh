#!/usr/bin/env bash

# shellcheck source=./scripts/log.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/log.sh"
# shellcheck source=./scripts/os.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/os.sh"

# Check that the given binary is available on the PATH. If it's not, exit with an error.
function assert_is_installed {
  local -r name="$1"

  if ! os_command_is_installed "$name"; then
    log_error "The command '$name' is required by this script but is not installed or in the system's PATH."
    exit 1
  fi
}
