
all: install

update:
	git submodule update --recursive --remote
	curl -LSso vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

install:
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
