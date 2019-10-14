#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Set magic variables for current file and dir
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" ; pwd )"
__file="${__dir}/$( basename "${BASH_SOURCE[0]}" )"
__base="$( basename ${__file} .sh )"
__root="$( cd "$( dirname "${__dir}" )" ; pwd )"

if command -v brew >/dev/null 2>&1; then
	brew tap | grep -q 'getantibody/tap' || brew tap getantibody/tap
	brew install antibody
else
	curl -sL https://git.io/antibody | sh -s
fi

antibody bundle <"$__root/antibody/bundles.txt" >~/.zsh_plugins.sh
antibody update
