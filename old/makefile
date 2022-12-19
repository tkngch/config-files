.PHONY: install dryrun check

dryrun:
	python install.py --dry-run

install:
	python install.py
	update-desktop-database ~/.local/share/applications

check:
	mypy install.py
	pylint install.py
