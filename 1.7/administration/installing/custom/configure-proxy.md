---
post_title: Configure DC/OS for Proxy
nav_title: Configure Proxy
menu_order: 9
---

By default the DC/OS [Universe](https://github.com/mesosphere/universe) repository is hosted on the internet. The DC/OS [OAuth Service](https://github.com/dcos/dcos-oauth) must have access to `dcos.auth0.com` to fetch the required public key via HTTPS to validate access tokens. If your DC/OS cluster is behind a corporate proxy, you must update your configuration post-installation to fetch the Universe packages and OAuth service to work. 

## Configure DC/OS Master node

1.  Create `/var/lib/dcos/` directory if it doesn't exist and add the following variables in the file `/var/lib/dcos/environment.proxy`:

    ```
    http_proxy=http://user:pass@host:port
    https_proxy=http://user:pass@host:port
    no_proxy="*.mesos,127.0.0.1,localhost"
    ```
    
    If you are not sure about the values for `http_proxy` and `https_proxy` variables for your environment, Please contact your system administrator.
    
    If you have any hosts or domains you would like to bypass the proxy you can add them to the `no_proxy` variable like this: `no_proxy="*.mesos,127.0.0.1,localhost,localaddress,.localdomain.com"`
    
1.  Restart the Cosmos service for the changes to take effect.

    ```
    sudo systemctl restart dcos-cosmos
    ```

1.  Edit the unit file `/opt/mesosphere/active/dcos-oauth/dcos.target.wants_master/dcos-oauth.service` to add a line `EnvironmentFile=-/var/lib/dcos/environment.proxy` just after `EnvironmentFile=/opt/mesosphere/environment`.

1.  Do a daemon-reload so that changes in the util file are registered. 

    ```
    sudo systemctl daemon-reload
    ```

1.  Restart the Oauth service for the changes to take effect.

    ```
    sudo systemctl restart dcos-oauth
    ```

## Configure DC/OS Private Agent Node

1.  Create `/var/lib/dcos/` directory if it doesn't exist and add `http_proxy`, `https_proxy`, and `no_proxy` lines from above in the file `/var/lib/dcos/mesos-slave-common`.


1.  Restart the Mesos Agent service for the changes to take effect.

    ```
    sudo systemctl restart dcos-mesos-slave
    ```

## Configure DC/OS Public Agent Node

1.  Create `/var/lib/dcos/` directory if it doesn't exist and add `http_proxy, `https_proxy` and `no_proxy` lines from above in the file `/var/lib/dcos/mesos-slave-common`.


1.  Restart the Mesos Agent service for the changes to take effect.

    ```
    sudo systemctl restart dcos-mesos-slave-public
    ```

