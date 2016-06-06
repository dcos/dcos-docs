---
post_title: Uninstalling Services
nav_title: Uninstalling
---
<!-- This source repo for this topic is https://github.com/dcos/dcos-docs -->
## Uninstall a service with the CLI

1.  Uninstall a datacenter service with this command:

    ```bash
    $ dcos package uninstall <servicename>
    ```

    For example, to uninstall Chronos:

    ```bash
    $ dcos package uninstall chronos
    ```

## Uninstall a service with the web UI

1.  Navigate to the Universe page in the DC/OS UI:

    ![Universe](../img/webui-universe-install.png)

2.  Click on the Installed tab:

    ![Universe](../img/webui-universe-installed-packages.png)

3.  Hover your cursor over the name of the package you wish to uninstall and you will see a red "Uninstall" link to the right. Click this link to uninstall the package.
