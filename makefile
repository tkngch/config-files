.PHONY: install dryrun check

dryrun:
	python install.py --dry-run

install:
	python install.py

check:
	mypy install.py
	pylint install.py
