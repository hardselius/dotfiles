
all: install

install:
	git submodule update --recursive --remote
	cp -rf vim/ ../.vim
	cp vimrc ~/.vimrc
	cp zshrc ~/.zshrc
	cp tmux.conf ~/.tmux.conf

update:
	cp ~/.vimrc vimrc
	cp ~/.zshrc zshrc
	cp ~/.tmux.conf tmux.conf

apply:
	source ~/.zshrc
