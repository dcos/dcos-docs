---
post_title: Connecting to Multiple Clusters
nav_title: Multiple Clusters  
menu_order: 3.1
---

You can connect the CLI to multiple DC/OS clusters at the same time by using the `DCOS_CONFIG` environment variable. With this variable you can specify a terminal-specific CLI configurations. 

This variable only affects the terminal you are currently connected to. After you end the terminal session, the configuration is removed and your default configuration remains.

**Recommendation:** Make a back up of your default CLI configuration file (`dcos.toml`) before connecting to multiple clusters. By default, this file is located in `/<home-directory>/.dcos/dcos.toml`. You can use this file as a template for additional configurations.

1.  Create a cluster configuration file and save to a unique location (e.g., `/dcos-config/dcos-alice.toml`). The file type must be `.toml`.

    **Tip:** You can use the default configuration file (`dcos.toml`) as a template.

1.  Open a terminal and run this command to connect a cluster, with the path to your cluster configuration specified (`path/to/dcos/config`):

    ```bash
    $ export DCOS_CONFIG=path/to/dcos/config
    ```
    
    For example, to connect to a cluster config located in `/<home-directory>/dcos-config/dcos-alice.toml` run this command:
    
    ```bash
    export DCOS_CONFIG=~./dcos-config/dcos-alice.toml
    ```

1.  To disconnect from a cluster, close the terminal session or run this command:

    ```bash
    $ unset DCOS_CONFIG
    ```