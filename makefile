.PHONY: install dryrun

dryrun:
	python install.py --dry-run --verbose

install:
	python install.py
