
all: install

update:
	git submodule update --recursive --remote

install:
	git submodule update --recursive --remote
	cp -rf vim/ ../.vim
	cp vimrc ~/.vimrc
	cp zshrc ~/.zshrc
	cp tmux.conf ~/.tmux.conf
	cp profile ~/.profile && source ~/.profile

#update:
#	cp ~/.vimrc vimrc
#	cp ~/.zshrc zshrc
#	cp ~/.tmux.conf tmux.conf
#	cp ~/.profile profile

apply:
	source ~/.zshrc
