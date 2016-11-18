---
nav_title: Access by Proxy and VPN
post_title: Access by Proxy and VPN using DC/OS Tunnel
menu_order: 10
---

When developing services on DC/OS, you may find it helpful to access your cluster from your local machine via SOCKS proxy, HTTP proxy, or VPN. For instance, you can work from your own development environment and immediately test against your DC/OS cluster.

**Warning:** DC/OS Tunnel is appropriate for development, debugging, and testing only. Do not use DC/OS Tunnel in production.

# SOCKS
DC/OS Tunnel can run a SOCKS proxy over SSH to the cluster. SOCKS proxies work for any protocol, but your client must be configured to use the proxy, which runs on port 1080 by default.

# HTTP

The HTTP proxy can run in two modes: transparent and standard.

##  Transparent Mode
In transparent mode, the HTTP proxy runs as superuser on port 80 and does not require modification to your application. Access URLs by appending the `mydcos.directory` domain. You can also [use DNS SRV records as if they were URLs](#srv). The HTTP proxy cannot currently access HTTPS in transparent mode.

## Standard Mode
Though you must configure your client to use the HTTP proxy in standard mode, it does not have any of the limitations of transparent mode. As in transparent mode, you can use [DNS SRV](#srv) records as URLs.

<a name="srv"></a>
### SRV Records
A SRV DNS record is a mapping from a name to a IP/port pair. DC/OS creates SRV records in the form `_<port-name>._<service-name>._tcp.marathon.mesos`. The HTTP proxy exposes these as URLs. This feature can be useful for communicating with DC/OS services.

# VPN
DC/OS Tunnel provides you with full access to the DNS, masters, and agents from within the cluster. OpenVPN requires root privileges to configure these routes.

# DC/OS Tunnel Options at a Glance

<table class="table">
  <tr>
    <th>&nbsp;</th>
    <th>Pros</th>
    <th>Cons</th>
  </tr>
  <tr>
    <th>SOCKS</th>
    <td>
    <ul>
        <li>Specify ports</li>
        <li>All protocols</li>
    </ul>
    </td>
    <td>
        <ul>
            <li>Requires application configuration</li>
        </ul>
        </td>
  </tr>
  
  <tr>
      <th>HTTP (transparent)</th>
      <td>
      <ul>
          <li>SRV as URL</li>
          <li>No application configuration</li>
      </ul>
      </td>
      <td>
          <ul>
              <li>Cannot specify ports (except through SRV)</li>
              <li>Only supports HTTP</li>
              <li>Runs as superuser</li>
          </ul>
          </td>
    </tr>
    
    <tr>
          <th>HTTP (standard)</th>
          <td>
          <ul>
              <li>SRV as URL</li>
              <li>Specify ports</li>
          </ul>
          </td>
          <td>
              <ul>
                  <li>Requires application configuration</li>
                  <li>Only supports HTTP/HTTPS</li>
              </ul>
              </td>
     </tr>
     
     <tr>
               <th>VPN</th>
               <td>
               <ul>
                   <li>No application configuration</li>
                   <li>Full and direct access to cluster</li>
                   <li>Specify ports</li>
                   <li>All protocols</li>
               </ul>
               </td>
               <td>
                   <ul>
                       <li>More prerequisites</li>
                       <li>Runs as superuser</li>
                       <li><i>May</i> need to manually reconfigure DNS</li>
                       <li>Relatively heavyweight</li>
                   </ul>
                   </td>
      </tr>
    
</table>

# Using DC/OS Tunnel

## Prerequisites
* Only Linux and macOS are currently supported.
* The [DC/OS CLI](/docs/1.8/usage/cli/install/).
* The DC/OS Tunnel package. Run `dcos package install tunnel-cli --cli`.
* [SSH access](/docs/1.8/administration/access-node/sshcluster/) (key authentication only).
* [The OpenVPN client](https://openvpn.net/index.php/open-source/downloads.html) for VPN functionality.

## Example Application

All examples will refer to this sample application:
* Service Name: `myapp`
* Group: `mygroup`
* Port: `555`
 * Port Name: `myport`
 * Load-balanced
* Running on virtual network

`myapp` is a web server listening on port `555`. We'll be using `curl`
as our client application. Each successful example will result in the HTML
served by `myapp` to be output output as text.

##  Using DC/OS Tunnel to run a SOCKS Proxy
1. Run the following command from the DC/OS CLI:

    ```
    $ dcos tunnel socks

    ## Example
    $ curl --proxy socks5://127.0.0.1:1080 mygroupmyapp.marathon.l4lb.thisdcos.directory:555
    $ curl --proxy socks5://127.0.0.1:1080 _myport._myapp.mygroup._tcp.marathon.mesos
    ```

1. Configure your application to use the proxy on port 1080.

##  Using DC/OS Tunnel to run a HTTP Proxy
### Transparent Mode

1. Run the following command from the DC/OS CLI:

    ```
    $ sudo dcos tunnel http

    ## Example
    $ curl _myport._myapp.mygroup._tcp.marathon.mesos.mydcos.directory

    ### Watch out!
    ## This won't work because you can't specify a port in transparent mode
    $ curl mygroupmyapp.marathon.l4lb.thisdcos.directory.mydcos.directory:555
    ```

1. In transparent mode, the HTTP proxy works by port forwarding. Append `.mydcos.directory` to the end of your domain when you enter commands. For instance, `http://example.com/?query=hello` becomes `http://example.com.mydcos.directory/?query=hello`. **Note:** In transparent mode, you cannot specify a port in a URL.

### Standard mode
1. To run the HTTP proxy in standard mode, without root privileges, use the `--port` flag to configure it to use another port:

    ```
    $ dcos tunnel http --port 8000

    ## Example
    $ curl --proxy 127.0.0.1:8000 mygroupmyapp.marathon.l4lb.thisdcos.directory:555
    $ curl --proxy 127.0.0.1:8000 _myport._myapp.mygroup._tcp.marathon.mesos
    ```

1. Configure your application to use the proxy on the port you specified above.

### SRV Records
The HTTP proxy exposes DC/OS SRV records as URLs in the form `_<port-name>._<service-name>._tcp.marathon.mesos.mydcos.directory` (transparent mode) or `_<port-name>._<service-name>._tcp.marathon.mesos` (standard mode).

#### Find your Service Name
The `<service-name>` is the entry in the **ID** field of a service you create from the DC/OS web interface or the value of the `id` field in your Marathon application definition.

#### Add a Named Port from the DC/OS Web Interface
To name a port from the DC/OS web interface, go to the **Services** tab, click the name of your service, and then click **Edit**. Enter a name for your port on the **Network** tab.

#### Add a Named Port in a Marathon Application Definition
Alternatively, you can add `name` to the `portMappings` or `portDefinitions` field of a Marathon application definition. Whether you use `portMappings` or `portDefinitions` depends on whether you are using `BRIDGE` or `HOST` networking. [Learn more about networking and ports in Marathon](https://mesosphere.github.io/marathon/docs/ports.html).

```json
"portMappings": [
    {
        "name": "<my-port-name>",
        "containerPort": 3000,
        "hostPort": 0,
        "servicePort": 10000,
        "labels": {
             "VIP_0": "1.1.1.1:30000"
        }
    }
]
```

```json
"portDefinitions": [
    {
      "name": "<my-port-name>",
      "protocol": "tcp",
      "port": 0,    
    }
  ]
```

##  Using DC/OS Tunnel to run a VPN
Run the following command from the DC/OS CLI

```
$ sudo dcos tunnel vpn

## Example
$ curl mygroupmyapp.marathon.l4lb.thisdcos.directory:555
$ curl _myport._myapp.mygroup._tcp.marathon.mesos
```

The VPN client attempts to auto-configure DNS, but this functionality does not work on macOS. To use the VPN client on macOS, [add the DNS servers](https://support.apple.com/kb/PH18499?locale=en_US) that DC/OS Tunnel instructs you to use.

When you use the VPN, you are virtually within your cluster. You can access
your master and agent nodes directly:

```
$ ping master.mesos
$ ping slave.mesos
```

### macOS OpenVPN Client Installation
* If using [homebrew](http://brew.sh/) then install with:
    ```
    $ brew install openvpn
    ```
    Then to use it:

    Either add `/usr/local/sbin` to your `$PATH`,

    or add the flag `--client=/usr/local/sbin/openvpn` like so:
    ```
    $ sudo dcos tunnel vpn --client=/usr/local/sbin/openvpn
    ```

* Another option is to install [TunnelBlick](https://tunnelblick.net/)
    (_don't run it_, we are only installing it for the `openvpn` executable)
    and add the flag `--client=/Applications/Tunnelblick.app/Contents/Resources/openvpn/openvpn-*/openvpn` like so:
    ```
    $ sudo dcos tunnel vpn --client=/Applications/Tunnelblick.app/Contents/Resources/openvpn/openvpn-*/openvpn
    ```


### Linux OpenVPN Client Installation
`openvpn` should be available via your distribution's package manager.

For example:
* Ubuntu: `apt-get update && apt-get install openvpn`
* ArchLinux: `pacman -S openvpn`
