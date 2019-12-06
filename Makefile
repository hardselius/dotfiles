# Make will use bash instead of sh
SHELL := /usr/bin/env bash

.PHONY: check-scripts
check-scripts:
	shellcheck --shell=bash **/*.*sh functions/*

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
