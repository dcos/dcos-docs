---
post_title: Advanced Configuration
nav_title: Configuring
menu_order: 001
---

Each Universe service installs with a set of default parameters. You can discover the default parameters and change them as desired.

This topic describes how to use the DC/OS CLI to configure services. You can also customize services by using the [**Services**](/docs/1.8/usage/webinterface/#services) tab in the DC/OS UI. 

1.  From the DC/OS CLI, view the available configuration options for a service with the `dcos package describe --config <package-name>` command. This command displays the config.json file for a specified [Universe](https://github.com/mesosphere/universe) package.

    For example, to view the Marathon config.json file:

    ```bash
    $ dcos package describe --config marathon
    ```
    
    The output should look similar to this:
    
    ```json
    {
      "additionalProperties": false,
      "description": "Marathon DCOS Service properties",
      "properties": {
        "jvm": {
          "additionalProperties": false,
          "description": "JVM configuration properties",
          "properties": {
            "heap-max": {
              "default": 768,
              "description": "Memory (MB) max size for the JVM heap. This number should be less than the memory allocated to the Marathon instance (General rule: 50%).",
              "minimum": 0,
              "type": "integer"
            },
            "heap-min": {
              "default": 256,
              "description": "Memory (MB) start size for the JVM heap. This number should be be less or equals than the heap-max.",
              "minimum": 0,
              "type": "integer"
            }
          },
    ...      
    ```

2.  Create a JSON configuration file with your customizations. You can choose an arbitrary name, but you might want to choose a pattern like `<package-name>-config.json`. For example, `marathon-config.json`.

    ```bash
    $ nano marathon-config.json
    ```

    For example, to change the number of Marathon CPU shares to 3 and memory allocation to 2048:

    ```json
    {
      "marathon": {
        "cpus": 3.0, "mem": 2048.0
       }
    }
    ```

4.  From the DC/OS CLI, install the DC/OS service with your custom options file specified. For example, to install Marathon with the custom options:

    ```bash
    $ dcos package install --options=marathon-config.json marathon
    ```

For more information, see the [dcos package](/docs/1.8/usage/cli/command-reference/#dcospackage) documentation.
