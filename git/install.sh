#! /usr/bin/env bash

# Copyright (c) 2019 Martin Hardselius
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

# Set magic variables for current file and dir
__dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" ; pwd )"
__file="${__dir}/$( basename "${BASH_SOURCE[0]}" )"
__base="$( basename ${__file} .sh )"
__root="$( cd "$( dirname "${__dir}" )/.." ; pwd )"

arg1="${1:-}"

# ------------------------------------------------------------------------------
# INSTALL GIT CONFIGURATION
# ------------------------------------------------------------------------------

# Don't ask for ssh password all the time
if [ "$(uname -s)" = "Darwin" ]; then
	git config --global credential.helper osxkeychain
else
	git config --global credential.helper cache
fi

# Better diffs
if command -v diff-so-fancy >/dev/null 2>&1; then
	git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
fi

# Link .gitignore_global
ln -sf "${__dir}"/gitignore.symlink ~/.gitignore_global