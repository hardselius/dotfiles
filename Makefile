
all: install

install:
	cp -rf vim/ ../.vim
	cp vimrc ~/.vimrc
	cp zshrc ~/.zshrc

update:
	cp ~/.vimrc vimrc
	cp ~/.zshrc zshrc
