---
post_title: Updating the CLI
nav_title: Updating
menu_order: 3
---

You can update the DC/OS CLI to the latest version or downgrade to an older version.

# <a name="upgrade"></a>Upgrade the CLI

You can upgrade an existing DC/OS CLI installation to the latest build.

1.  From your DC/OS CLI installation directory, enter this command to update the DC/OS CLI:
    
    ```bash
    source bin/activate
    pip install -U dcoscli
    ```

# <a name="downgrade"></a>Downgrade the CLI

You can downgrade an existing DC/OS CLI installation to an older version.

**Tip:** Downgrading is necessary if you are using DC/OS 1.6.0 or earlier.

1.  Delete your DC/OS CLI installation directories:
    
    ```bash
    sudo rm -rf dcos && rm -rf ~/.dcos
    ```

2.  Install the legacy version of the DC/OS CLI, where <public-master-ip> is the public IP of your master node:
    
    ```bash
    mkdir -p dcos && cd dcos && 
      curl -O https://downloads.dcos.io/dcos-cli/install-legacy.sh && 
      bash ./install-legacy.sh . <public-master-ip> && 
      source ./bin/env-setup
    ```