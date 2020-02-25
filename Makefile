
.PHONY: default
default: help

.PHONY: lsrc
## lsrc: Run lsrc
lsrc:
	RCRC="$(CURDIR)/rcrc" lsrc

.PHONY: rcup
## rcup: Run rcup
rcup:
	RCRC="$(CURDIR)/rcrc" rcup

.PHONY: help
## help: Prints this help message
help:
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'
