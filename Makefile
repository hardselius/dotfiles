# Make will use bash instead of sh
SHELL := /usr/bin/env bash

# ------------------------------------------------------------------------------
# BOOSTRAP
# ------------------------------------------------------------------------------

.PHONY: bootstrap
bootstrap: bootstrap_dotfiles bootstrap_zsh

.PHONY: bootstrap_dotfiles
bootstrap_dotfiles:
	@source scripts/make.sh && bootstrap_dotfiles

.PHONY: bootstrap_zsh
bootstrap_zsh:
	@source scripts/make.sh && bootstrap_zsh
