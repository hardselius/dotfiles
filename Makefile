
all: install

install:
	git submodule update --recursive --remote
	cp -rf vim/ ../.vim
	cp vimrc ~/.vimrc
	cp zshrc ~/.zshrc

update:
	cp ~/.vimrc vimrc
	cp ~/.zshrc zshrc
