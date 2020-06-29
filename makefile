.PHONY: install install_home install_config install_local_applications

HERE:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

define link
	$(if $(filter "$(shell test -e "$(1)" && echo "file-exists")", "file-exists"),
		$(if $(filter $(shell readlink -f "$(1)"), $(shell readlink -f "$(2)")),
		    @echo "$(1) is already linked to $(2).",
		    @echo "Linking $(1) to $(2)."; ln -i -s -T "$(1)" "$(2)"
		),
		@echo "Skipping $(1)."
	)
endef

install: install_home install_config install_local_applications

install_home:
	# Link files to the home directory
	$(call link,"${HERE}/Rprofile","${HOME}/.Rprofile")
	$(call link,"${HERE}/Xresources","${HOME}/.Xresources")
	$(call link,"${HERE}/clang-format","${HOME}/.clang-format")
	$(call link,"${HERE}/gitconfig","${HOME}/.gitconfig")
	$(call link,"${HERE}/mailcap","${HOME}/.mailcap")
	$(call link,"${HERE}/msmtprc","${HOME}/.msmtprc")
	$(call link,"${HERE}/muttrc","${HOME}/.muttrc")
	$(call link,"${HERE}/sqliterc","${HOME}/.sqliterc")
	$(call link,"${HERE}/tmux.conf","${HOME}/.tmux.conf")
	$(call link,"${HERE}/vimrc","${HOME}/.vimrc")
	$(call link,"${HERE}/xinitrc","${HOME}/.xinitrc")
	$(call link,"${HERE}/zshrc","${HOME}/.zshrc")
	$(call link,"${HERE}/notmuch-config","${HOME}/.notmuch-config")
	## emacs
	mkdir -p "${HOME}/.emacs.d"
	$(call link,"${HERE}/emacs.d/init.el","${HOME}/.emacs.d/init.el")
	$(call link,"${HERE}/emacs.d/notmuch-config.el","${HOME}/.emacs.d/notmuch-config.el")
	## w3m
	mkdir -p "${HOME}/.w3m"
	$(call link,"${HERE}/w3m/config","${HOME}/.w3m/config")

install_config:
	# Link files to the xdg config home.
	$(call link,"${HERE}/mimeapps.list","${XDG_CONFIG_HOME}/mimeapps.list")
	$(call link,"${HERE}/user-dirs.dirs","${XDG_CONFIG_HOME}/user-dirs.dirs")
	## getmail
	mkdir -p "${XDG_CONFIG_HOME}/getmail"
	$(call link,"${HERE}/getmail/rc_gmail","${XDG_CONFIG_HOME}/getmail/rc_gmail")
	$(call link,"${HERE}/getmail/rc_gmx","${XDG_CONFIG_HOME}/getmail/rc_gmx")
	$(call link,"${HERE}/getmail/rc_runbox","${XDG_CONFIG_HOME}/getmail/rc_runbox")
	$(call link,"${HERE}/getmail/rc_yahoo","${XDG_CONFIG_HOME}/getmail/rc_yahoo")
	## neovim
	mkdir -p "${XDG_CONFIG_HOME}/nvim"
	$(call link,"${HERE}/nvim/init.vim","${XDG_CONFIG_HOME}/nvim/init.vim")
	## mpv
	mkdir -p "${XDG_CONFIG_HOME}/mpv"
	$(call link,"${HERE}/mpv/mpv.conf","${XDG_CONFIG_HOME}/mpv/mpv.conf")
	$(call link,"${HERE}/mpv/input.conf","${XDG_CONFIG_HOME}/mpv/input.conf")

install_local_applications:
	# Link files to the .local.
	$(call link,"${HERE}/null.desktop","${HOME}/.local/share/applications/null.desktop")
