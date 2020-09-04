#!/usr/bin/env python3
"""Install the configuration files, by creating symbolic links.
"""

from argparse import ArgumentParser
from argparse import Namespace
from pathlib import Path
from os import getenv
import logging

HERE = Path(__file__).resolve().parent


def main() -> None:
    args = _parse_args()

    logging.basicConfig()
    logging.getLogger().setLevel(logging.INFO)
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)

    _link_files_to_home(args.is_dryrun)
    _link_files_to_config(args.is_dryrun)
    _link_files_to_local_applications(args.is_dryrun)
    _link_files_to_local_bin(args.is_dryrun)


def _parse_args() -> Namespace:
    parser = ArgumentParser(description=main.__doc__)
    parser.add_argument(
        "--dry-run", dest="is_dryrun", action="store_const", default=False, const=True
    )
    parser.add_argument(
        "--verbose", dest="verbose", action="store_const", default=False, const=True
    )

    return parser.parse_args()


def _link_files_to_home(is_dryrun: bool) -> None:
    src = HERE.joinpath("home")
    dest = Path.home()
    for path in src.iterdir():
        if path.is_file():
            _symlink(path, dest.joinpath(f".{path.name}"), is_dryrun)
        elif path.is_dir() and "notmuch" not in path.name:
            for subpath in path.iterdir():
                _symlink(
                    subpath, dest.joinpath(f".{path.name}", subpath.name), is_dryrun
                )

    # notmuch configurations
    maildir = getenv("MAILDIR", None)
    if maildir is None:
        return
    for hook_path in src.joinpath("notmuch", "hooks").iterdir():
        _symlink(
            hook_path, maildir.joinpath(".notmuch", "hooks", hook_path.name), is_dryrun
        )


def _link_files_to_config(is_dryrun: bool) -> None:
    dest = Path(getenv("XDG_CONFIG_HOME", Path.home().joinpath(".config").as_posix()))

    for path in HERE.joinpath("xdg_config").iterdir():
        if path.is_file():
            _symlink(path, dest.joinpath(path.name), is_dryrun)
        elif path.is_dir():
            for subpath in path.iterdir():
                _symlink(subpath, dest.joinpath(path.name, subpath.name), is_dryrun)


def _link_files_to_local_applications(is_dryrun: bool) -> None:
    dest = Path.home().joinpath(".local", "share", "applications")
    for path in HERE.joinpath("local_applications").iterdir():
        _symlink(path, dest.joinpath(path.name), is_dryrun)


def _link_files_to_local_bin(is_dryrun: bool) -> None:
    dest = Path(getenv("LOCAL_BIN", Path.home().joinpath(".local", "bin").as_posix()))
    for path in HERE.joinpath("local_bin").iterdir():
        dest_path = dest.joinpath(path.name)
        _symlink(path, dest_path, is_dryrun)

        logging.info("Setting 700 permission %s.", dest_path.as_posix())
        if not is_dryrun:
            dest_path.chmod(0o700)


def _symlink(source: Path, destination: Path, is_dryrun: bool) -> bool:
    if not source.exists():
        logging.debug("%s does not exist.", source.as_posix())
        return False

    if destination.is_symlink() and destination.resolve() == source:
        logging.debug(
            "%s is already linked to %s", source.as_posix(), destination.as_posix()
        )
        return False

    if destination.is_symlink() and not destination.resolve().exists():
        logging.warning(
            "%s is linked to a non-existent file. Deleting this symlink...",
            destination.as_posix(),
        )
        if not is_dryrun:
            destination.unlink()

    if destination.exists():
        logging.warning(
            "Found %s. Please delete this file. Skipping for now.",
            destination.as_posix(),
        )
        return False

    if not destination.parent.exists():
        if not is_dryrun:
            destination.parent.mkdir(parents=True)
        logging.info("%s is created.", destination.parent.as_posix())

    if not is_dryrun:
        destination.symlink_to(source)
    logging.info("%s is now linked to %s", source.as_posix(), destination.as_posix())
    return True


if __name__ == "__main__":
    main()
