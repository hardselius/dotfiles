.PHONY: default
default: help

.PHONY: update-submodules
## update-submodules: Update submodules to latest tips of remote branches
update-submodules:
	git submodule update --recursive --remote


.PHONY: help
## help: Prints this help message
help:
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'
