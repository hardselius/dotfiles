# Make will use bash instead of sh
SHELL := /usr/bin/env bash

# ------------------------------------------------------------------------------
# BOOSTRAP
# ------------------------------------------------------------------------------

.PHONY: bootstrap
bootstrap: dotfiles zsh

.PHONY: dotfiles
dotfiles:
	@source scripts/make.sh && bootstrap_dotfiles

.PHONY: bootstrap_zsh
zsh:
	@source scripts/make.sh && bootstrap_zsh

.PHONY: antibody
antibody:
	@source scripts/make.sh && run_antibody
