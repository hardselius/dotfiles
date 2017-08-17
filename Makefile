
all: install

install:
	cp vimrc ../.vimrc
	cp zshrc ../.zshrc

update:
	cp ~/.vimrc vimrc
	cp ~/.zshrc zshrc
