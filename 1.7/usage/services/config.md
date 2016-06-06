---
post_title: Configuring
---
<!-- This source repo for this topic is https://github.com/dcos/dcos-docs -->
You can customize your DC/OS service during installation with a JSON configuration file. Otherwise, the services are installed by using default values.

The general process is as follows:

1.  View the available configuration options with the `dcos package describe --config <package-name>` command:

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

3.  Use the `properties` objects from step one to build your JSON options file. For example, to change the number of Marathon CPU shares to 3 and memory allocation to 2048:

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

For more information, see the [dcos package][1] documentation.

 [1]: /docs/1.7/usage/cli/command-reference/
