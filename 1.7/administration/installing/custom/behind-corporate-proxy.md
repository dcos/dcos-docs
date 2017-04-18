---
post_title: DC/OS behind a corporate proxy
nav_title: Behind a proxy
menu_order: 9
---

If your DC/OS cluster is behind a corporate proxy and you do not have access to the internet, you won't be able to login or use the [DC/OS Universe repository](/1.7/usage/services/repo/). The current DC/OS CLI installer does not support proxy options so all of these steps must be manually performed on your nodes.

You must replace these variables with the values that match your network:

*    `proxy-protocol`, `proxy-ip`, `proxy-port` is your proxy protocol, IP, and port.
*    `no-proxy-list` is a comma-separated list of addresses that will bypass the proxy (basically `localhost`, `127.0.0.1`, your cluster and internal services addresses).
*    `no-proxy-list-java` is a vertical bar (`|`) separated list of addresses that will bypass the proxy for Java-based software. Wildcards are supported.
*    `cacert-file` is the location of the PEM certificate of your corporate proxy.

# Disclaimer
Proxy support is not officially supported in DC/OS and this documentation was put together by trial and error. It might not be complete or up-to-date and some steps might not be required.

# Proxy configuration
## Yum

Append the proxy configuration to `/etc/yum.conf`.

```
proxy=<proxy-protocol>://<proxy-ip>:<proxy-port>
```

## Docker
These settings only allow Docker to pull images from Docker Hub. Your containers must be separately configured.

1. Create Docker systemd directory.

    ```
    $ sudo mkdir /etc/systemd/system/docker.service.d
    ```

2. Create configuration file: `/etc/systemd/system/docker.service.d/http-proxy.conf`

    ```
    [Service]
    Environment="HTTP_PROXY=<proxy-protocol>://<proxy-ip>:<proxy-port>"
    Environment="NO_PROXY=<no-proxy-list>"
    ```

3. Reload systemd and restart Docker

    ```
    $ sudo systemctl systemctl daemon-reload
    $ sudo systemctl restart docker
    ```

You can find more detailed steps in the official Docker documentation: [Control and configure Docker with systemd](https://docs.docker.com/engine/admin/systemd/).

## Environment variables

Add to `/etc/environment` :

```
http_proxy="<proxy-protocol>://<proxy-ip>:<proxy-port>"
https_proxy="<proxy-protocol>://<proxy-ip>:<proxy-port>"
no_proxy="<no-proxy-list>"

HTTP_PROXY="<proxy-protocol>://<proxy-ip>:<proxy-port>"
HTTPS_PROXY="<proxy-protocol>://<proxy-ip>:<proxy-port>"
NO_PROXY="<no-proxy-list>"
```

**Warning:** Do not place these environment variables in `/opt/mesosphere/environment` or `/opt/mesosphere/environment.export` because 3DT (`dcos-ddt.service`) will read `http_proxy` environment variable, but not `no_proxy`. This will completely break the DC/OS web UI.

## Cosmos

1. Open `/opt/mesosphere/packages/cosmos-[...]/dcos.target.wants_master/dcos-cosmos.service` or `/etc/systemd/system/dcos-cosmos.service`.

2. Locate the last `ExecStart` command.

3. Add this string before `-classpath`:

    ```
    -Dhttp.proxyHost=<proxy-ip> -Dhttp.proxyPort=<proxy-port> -Dhttp.nonProxyHosts=<no-proxy-list-java> -Dhttps.proxyHost=<proxy-ip> -Dhttps.proxyPort=<proxy-port> -Dhttps.nonProxyHosts=<no-proxy-list-java>
    ```
    It should look like:

    ```
    ExecStart=/opt/mesosphere/bin/java -Xmx2G -Dhttp.proxyHost=<proxy-ip> -Dhttp.proxyPort=<proxy-port> -Dhttp.nonProxyHosts=<no-proxy-list-java> -Dhttps.proxyHost=<proxy-ip> -Dhttps.proxyPort=<proxy-port> -Dhttps.nonProxyHosts=<no-proxy-list-java> -classpath /opt/mesosphere/packages/cosmos--25d98ad8c31c73550a40c8e1022c08f2e53976c4/lib/:/opt/mesosphere/packages/cosmos--25d98ad8c31c73550a40c8e1022c08f2e53976c4/usr/cosmos.jar com.simontuffs.onejar.Boot
    ```

# Self-signed certificate configuration
Most corporate proxies also decrypt SSL connections via a man-in-the-middle mechanism and a SSL certificate pre-installed on the company computers. You must add the proxy certificate to the various DC/OS trust stores.

## CA bundle

```
$ sudo yum install ca-certificates
$ sudo update-ca-trust enable
$ sudo cp <cacert-file> /usr/share/pki/ca-trust-source/anchors/corporate_proxy.crt
$ sudo update-ca-trust extract
```

## DC/OS packages
### Java

1. Locate `keytool`:

    ```
    /opt/mesosphere/packages/java-[...]/usr/java/bin/keytool
    ```

2. Locate Java keystore (default password is `changeit`):

    ```
    /opt/mesosphere/packages/java-[...]/usr/java/jre/lib/security/cacerts
    ```

3. Add the certificate to keystore:

    ```
    keytool -keystore cacerts -importcert -alias corporate_proxy -file <cacert-file>
    ```

### Other packages
Append your certificate to the following list of CA bundles with this command:

```
$ sudo su -c "cat <cacert-file> >> cacert.pem"
```

*   `/opt/mesosphere/packages/python--[...]/lib/python3.4/site-packages/pip/_vendor/requests/cacert.pem`
*   `/opt/mesosphere/packages/python-requests-[...]/lib/python3.4/site-packages/requests/cacert.pem`
*   `/opt/mesosphere/packages/dcos-image-deps-[...]/lib/python3.4/site-packages/websocket/cacert.pem`
*   `/opt/mesosphere/packages/boto-[...]/lib/python3.4/site-packages/botocore/vendored/requests/cacert.pem`

