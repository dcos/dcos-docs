---
post_title: dcos experimental service start
menu_order: 2
---
    
# Description
Start a service from a non-native DC/OS package. See `dcos experimental package add` for information on how to add a package to DC/OS.

# Usage

```bash
dcos experimental service start <package-name> [OPTION]
```

# Options

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `--json`   |             |  JSON-formatted data. |
| `--options=<options-file>`   |             | Path to a JSON file that contains customized package execution options. |
| `--package-version=<package-version>`   |             | The package version. |
    
# Positional arguments

| Name, shorthand | Default | Description |
|---------|-------------|-------------|
| `<package-name>`   |             |  Name of the DC/OS package. |    

# Parent command

| Command | Description |
|---------|-------------|
| [dcos experimental](/docs/1.10/cli/command-reference/dcos-experimental/)   |  Manage commands that under development and subject to change. |  