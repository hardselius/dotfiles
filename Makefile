HOSTNAME = thor
MAX_AGE  = 14

NIX_CONF = $(HOME)/.dotfiles
NIXPATH  = $(NIX_PATH):localconfig=$(NIX_CONF)/config/$(HOSTNAME).nix
PRENIX   = NIX_PATH=$(NIXPATH)

NIX	   = $(PRENIX) nix
NIX_BUILD  = $(PRENIX) nix-build
NIX_ENV	   = $(PRENIX) nix-env
NIX_STORE  = $(PRENIX) nix-store
NIX_GC	   = $(PRENIX) nix-collect-garbage

DARWIN_REBUILD = $(PRENIX) darwin-rebuild
HOME_MANAGER   = $(PRENIX) home-manager

.PHONY: default
default: help

# ------------------------------------------------------------------------------
# Build and switch
# ------------------------------------------------------------------------------

.PHONY: darwin-switch
## darwin-switch: Switches the nix-darwin condfiguration
darwin-switch:
	darwin-rebuild switch -Q
	@echo "Darwin generation: $$($(DARWIN_REBUILD) --list-generations | tail -1)"

.PHONY: home-switch
## home-switch: Switches the home-manager configuration
home-switch:
	home-manager switch
	@echo "Home generation: $$($(HOME_MANAGER) generations | head -1)"

.PHONY: home-manager-news
# home-manager-news: Shows home-manager news
home-manager-news:
	$(HOME_MANAGER) news

.PHONY: switch
## switch: Switches nix-darwin and home-manager configurations
switch: darwin-switch home-switch

# ------------------------------------------------------------------------------
# Collect garbage
# ------------------------------------------------------------------------------

define delete-generations
	$(NIX_ENV) $(1) --delete-generations			\
	    $(shell $(NIX_ENV) $(1)				\
		--list-generations | field 1 | head -n -$(2))
endef

define delete-generations-all
	$(call delete-generations,,$(1))
	$(call delete-generations,-p /nix/var/nix/profiles/system,$(1))
endef

# .PHONY: clean
# clean: gc check

# .PHONY: fullclean
# fullclean: gc-old check

.PHONY: gc
## gc: Runs garbage collection
gc:
	$(call delete-generations-all,$(MAX_AGE))
	$(NIX_GC) --delete-older-than $(MAX_AGE)d

# .PHONY: gc-old
# gc-old: remove-build-products
# 	$(call delete-generations-all,1)
# 	$(NIX_GC) --delete-old

# ------------------------------------------------------------------------------
# Debugging
# ------------------------------------------------------------------------------

.PHONY: sizes
## sizes: Prints the size of the nix store
sizes:
	df -H /nix

.PHONY: tools
## tools: Prints information
tools:
	@echo ""
	@echo export NIXOPTS=$(NIXOPTS)
	@echo export NIX_PATH=$(NIXPATH)
	@echo ""
	@PATH=$(BUILD_PATH)/sw/bin:$(PATH)	\
	    which				\
		find				\
		git				\
		head				\
		make				\
		nix-build			\
		nix-env				\
		sort				\
		sudo				\
		uniq
	@echo ""

# ------------------------------------------------------------------------------
# Other stuff
# ------------------------------------------------------------------------------

.PHONY: stow
## stow: stows relevant directories
stow:
	stow -t $(HOME) vim

.PHONY: init-submodules
## init-submodules: Inits submodules
init-submodules:
	git submodule update --init --recursive

.PHONY: pull-submodules
## pull-submodules: Pulls submodules
pull-submodules:
	git submodule update --remote --merge

.PHONY: update-submodules
## update-submodules: Updates submodules to latest tips of remote branches
update-submodules:
	git submodule update --recursive --remote


.PHONY: help
## help: Prints this help message
help:
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'
