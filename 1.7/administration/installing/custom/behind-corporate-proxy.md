---
post_title: DC/OS behind a corporate proxy
nav_title: Behind a proxy
menu_order: 9
---

If your DC/OS cluster is behind a corporate proxy, you will not have access to Internet and thus won't be able to login or use the Universe official repository. For now the DC/OS CLI installer does not feature nor support proxy options so all following steps must be manually performed on your nodes.

Placeholders must be replaced with the values which match your network:

*    `proxy-protocol`, `proxy-ip`, `proxy-port` are self-explanatory
*    `no-proxy-list` is a comma-separated list of addresses for which you want to bypass the proxy (basically `localhost`, `127.0.0.1`, your cluster and internal services addresses)
*    `no-proxy-list-java` is the same list of exceptions but for Java-based software and thus elements are separated by a vertical bar (`|`), wildcards are supported
*    `cacert-file` is the location of the PEM certificate of your corporate proxy

# Disclaimer
Proxy support is not official in DC/OS meaning this documentation has been put together by trial and error. It might not be complete or up-to-date and some steps are not necessarily required.

# Proxy configuration
## Yum

Append the proxy configuration to `/etc/yum.conf`.

```
proxy=<proxy-protocol>://<proxy-ip>:<proxy-port>
```

## Docker
These settings only allows Docker to pull images from Docker Hub. Containers must be separately configured.

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

Detailed steps can be found in the Docker official documentation: [Control and configure Docker with systemd](https://docs.docker.com/engine/admin/systemd/).

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

**Warning:** those environment variables canno't be placed in `/opt/mesosphere/environment` nor `/opt/mesosphere/environment.export` because 3DT (dcos-ddt.service) does actually read `http_proxy` environment variable but not `no_proxy` which completely breaks the web UI.

## Cosmos

1. Open `/opt/mesosphere/packages/cosmos-[...]/dcos.target.wants_master/dcos-cosmos.service` or `/etc/systemd/system/dcos-cosmos.service`

2. Locate the last `ExecStart` command

3. Add before `-classpath` :

    ```
    -Dhttp.proxyHost=<proxy-ip> -Dhttp.proxyPort=<proxy-port> -Dhttp.nonProxyHosts=<no-proxy-list-java> -Dhttps.proxyHost=<proxy-ip> -Dhttps.proxyPort=<proxy-port> -Dhttps.nonProxyHosts=<no-proxy-list-java>
    ```

4. It should look like:

    ```
    ExecStart=/opt/mesosphere/bin/java -Xmx2G -Dhttp.proxyHost=<proxy-ip> -Dhttp.proxyPort=<proxy-port> -Dhttp.nonProxyHosts=<no-proxy-list-java> -Dhttps.proxyHost=<proxy-ip> -Dhttps.proxyPort=<proxy-port> -Dhttps.nonProxyHosts=<no-proxy-list-java> -classpath /opt/mesosphere/packages/cosmos--25d98ad8c31c73550a40c8e1022c08f2e53976c4/lib/:/opt/mesosphere/packages/cosmos--25d98ad8c31c73550a40c8e1022c08f2e53976c4/usr/cosmos.jar com.simontuffs.onejar.Boot
    ```

# Self-signed certificate configuration
Most of the corporate proxies also decrypt SSL connections via a man-in-the-middle mechanism and a SSL certificate pre-installed on the company computers. DC/OS includes a few different trust stores to which we need to add the proxy certificate.

## CA bundle

```
$ sudo yum install ca-certificates
$ sudo update-ca-trust enable
$ sudo cp <cacert-file> /usr/share/pki/ca-trust-source/anchors/corporate_proxy.crt
$ sudo update-ca-trust extract
```

## DC/OS packages
### Java

1. Locate `keytool`, it should be in:

    ```
    /opt/mesosphere/packages/java-[...]/usr/java/bin/keytool
    ```

2. Locate Java keystore (default password is `changeit`):

    ```
    /opt/mesosphere/packages/java-[...]/usr/java/jre/lib/security/cacerts
    ```

3. Add certificate to keystore:

    ```
    keytool -keystore cacerts -importcert -alias corporate_proxy -file <cacert-file>
    ```

### Other packages
Append your certificate to the following list of CA bundles with

```
$ sudo su -c "cat <cacert-file> >> cacert.pem"
```

*   `/opt/mesosphere/packages/python--[...]/lib/python3.4/site-packages/pip/_vendor/requests/cacert.pem`
*   `/opt/mesosphere/packages/python-requests-[...]/lib/python3.4/site-packages/requests/cacert.pem`
*   `/opt/mesosphere/packages/dcos-image-deps-[...]/lib/python3.4/site-packages/websocket/cacert.pem`
*   `/opt/mesosphere/packages/boto-[...]/lib/python3.4/site-packages/botocore/vendored/requests/cacert.pem`

