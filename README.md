# Configuration Files

The configuration files are organised by their link locations: for example, the
files in "xdg_config" directory are linked to `XDG_CONFIG_HOME` directory.

## Installation

```sh
make install
```

The above command will create symbolic links at various places. To see what will
be linked without actually creating links, run the following command:

```sh
make dryrun
```

## License

GPL v3.0
