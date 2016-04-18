---
post_title: Updating the CLI
nav_title: Updates
menu_order: 3
---

You can update the DC/OS CLI to the latest version or downgrade to an older version.

# Upgrade the CLI

You can upgrade an existing DC/OS CLI installation to the latest build. Before running this command, make sure you've run `source bin/env-setup` in your environment.

1.  From your DC/OS CLI installation directory, enter this command to update the DC/OS CLI:

    ```bash
    $ sudo pip install -U dcoscli
    ```


# Downgrade the CLI

You can downgrade an existing DC/OS CLI installation to an older version.

**Tip:** Downgrading is necessary if you are running an older version of DC/OS and want to reinstall the DC/OS CLI.

1.  Delete your DC/OS CLI installation directories:

    ```bash
    $ sudo rm -rf dcos && rm -rf ~/.dcos
    ```

2.  Install the legacy version of the DC/OS CLI, where <public-master-ip> is the public IP of your master node:

        mkdir -p dcos && cd dcos &&
          curl -O https://downloads.mesosphere.com/dcos-cli/install-legacy.sh &&
          bash ./install-legacy.sh . <public-master-ip> &&
          source ./bin/env-setup
