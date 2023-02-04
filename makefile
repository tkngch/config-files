.PHONEY: install

install:
	ln -f -s $(CURDIR)/vim/vimrc ~/.vimrc
	ln -f -s $(CURDIR)/zsh/zshrc ~/.zshrc
	ln -f -s $(CURDIR)/tmux/tmux.conf ~/.tmux.conf
