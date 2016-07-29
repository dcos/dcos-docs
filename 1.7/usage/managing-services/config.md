---
post_title: Advanced Configuration
nav_title: Configuring
menu_order: 001
---

Each service installs with a set of default parameters. You can discover the default parameters and change them as desired.

1. View the available configuration options for the service with the `dcos package describe --config <package-name>` command.

    ```bash
    $ dcos package describe --config marathon
    {
     "properties": {
        "application": {
          "cpus": {
            "default": 2.0,
            "description": "CPU shares to allocate to each Marathon instance.",
            "minimum": 0.0,
            "type": "number"
         },
        ...
        "mem": {
          "default": 1024.0,
          "description": "Memory (MB) to allocate to each Marathon task.",
          "minimum": 512.0,
          "type": "number"
         },
         ...
    }
    ```

2.  Create a JSON configuration file. You can choose an arbitrary name, but you might want to choose a pattern like `<package-name>-config.json`. For example, `marathon-config.json`.

    ```bash
    $ nano marathon-config.json
    ```

3.  Use the `properties` objects (see [Discovering the default parameters](#discover-defaults)) to build your JSON options file. For example, to change the number of Marathon CPU shares to 3 and memory allocation to 2048:

    ```json
    {
      "application": {
        "cpus": 3.0, "mem": 2048.0
       }
    }
    ```

4.  From the DC/OS CLI, install the DC/OS service with the custom options file specified:

    ```bash
    $ dcos package install --options=marathon-config.json marathon
    ```

For more information, see the [dcos package](/docs/1.7/usage/cli/command-reference/#dcospackage) documentation.
