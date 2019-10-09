#!/bin/sh
if command -v hub >/dev/null 2>&1; then
	alias git='hub'
fi

gi() {
	curl -s "https://www.gitignore.io./api/$*";
}
