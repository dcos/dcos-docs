---
post_title: Uninstalling the CLI
nav_title: Uninstalling
menu_order: 4
---

You can uninstall the CLI with these commands for your operating system.

- [Unix, Linux, and OS X](#unixlinuxosx)
- [Windows](#windows)

## <a name="unixlinuxosx"></a>Unix, Linux, and OS X

1.  Delete the hidden `.dcos` directory. This will delete the configuration files for your DC/OS services.

    ```bash
    $ rm -rf ~/.dcos
    ```
    
1.  Delete the `dcos` executable.  By default, this file is located in `/usr/local/bin/dcos`.

    ```bash
    $ rm -rf /usr/local/bin/dcos
    ```

## <a name="windows"></a>Windows

1.  Delete the hidden `.dcos` directory. This will delete the configuration files for your DC/OS services. 
1.  Delete the `dcos` executable.  
