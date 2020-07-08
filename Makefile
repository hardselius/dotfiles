.PHONY: default
default: help

.PHONY: stow
## stow: stows relevant directories
stow:
	stow -t $(HOME) vim

.PHONY: update-submodules
## update-submodules: Updates submodules to latest tips of remote branches
update-submodules:
	git submodule update --recursive --remote


.PHONY: help
## help: Prints this help message
help:
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'
