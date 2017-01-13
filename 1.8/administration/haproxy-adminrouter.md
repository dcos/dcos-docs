---
post_title: Configuring HAProxy in Front of Admin Router
nav_title: HAProxy in Front of Admin Router
menu_order: 3.3
---

You can use HAProxy to set up an HTTP proxy in front of the DC/OS [Admin Router](/docs/1.8/overview/concepts/#adminrouter).
 
The HTTP Proxy must perform on-the-fly HTTP request and response header modification because DC/OS is not aware of the custom hostname and port that is being used by user agents to address the HTTP proxy.

These instructions provide a tested [HAProxy](http://www.haproxy.org/) configuration example that handles the named request/response rewriting. This example ensures that the communication between HAProxy and DC/OS Admin Router is TLS-encrypted.

1.  Install HAProxy [1.6.9](http://www.haproxy.org/#down).

1.  Create an HAProxy configuration for DC/OS. This example is for a DC/OS cluster on AWS. For more information on HAProxy configuration parameters, see the [documentation](https://cbonte.github.io/haproxy-dconv/configuration-1.6.html#3).

    **Tip:** You can find your task IP by using the agent IP address DNS entry.
    
    ```
    <taskname>.<framework_name>.agentip.dcos.thisdcos.directory
    ```
    
    Where:
    
    * `taskname`: The name of the task.
    * `framework_name`: The name of the framework, if you are unsure, it is likely `marathon`.

    ```
    global
      daemon
      log 127.0.0.1 local0
      log 127.0.0.1 local1 notice
      maxconn 20000
      pidfile /var/run/haproxy.pid
    defaults
      log            global
      option         dontlog-normal
      mode		 http
      retries             3
      maxconn          20000
      timeout connect  5000
      timeout client  50000
      timeout server  50000
    
    frontend http
      # Bind on port 9090. HAProxy will listen on port 9090 on each 
      # available network for new HTTP connections.
      bind 0.0.0.0:9090
      # Specify your own server certificate chain and associated private key.
      # See https://cbonte.github.io/haproxy-dconv/configuration-1.6.html#5.1-crt
      # bind *:9091 ssl crt /path/to/browser-trusted.crt
      #
      # Name of backend configuration for DC/OS.
      default_backend dcos
    
      # Store request Host header temporarily in transaction scope
      # so that its value is accessible during response processing.
      # Note: RFC 7230 requires clients to send the Host header and
      # specifies it to contain both, host and port information.
      http-request set-var(txn.request_host_header) req.hdr(Host)
    
      # Overwrite Host header to 'dcoshost'. This makes the Location
      # header in DC/OS Admin Router upstream responses contain a
      # predictable hostname (NGINX uses this header value when
      # constructing absolute redirect URLs). That value is used
      # in the response Location header rewrite logic (see regular
      # expression-based rewrite in the backend section below).
      http-request set-header Host dcoshost
    
    backend dcos
      # Option 1: use TLS-encrypted communication with DC/OS Admin Router and
      # perform server certificate verification (including hostname verification).
      # If you are using the community-supported version of DC/OS, you must 
      # configure Admin Router with a custom TLS server certificate, see 
      # https://dcos.io/docs/1.8/administration/securing-your-cluster/. This step 
      # is not required for Enterprise DC/OS.
      #
      # Explanation for the parameters in the following `server` definition line:
      # 
      # 1.2.3.4:443
      #
      #   IP address and port that HAProxy uses to connect to DC/OS Admin
      #   Router. This needs to be adjusted to your setup.
      #   
      #
      # ssl verify required
      #
      #   Instruct HAProxy to use TLS, and to error out if server certificate
      #   verification fails.
      #
      # ca-file dcos-ca.crt
      #
      #   The local file `dcos-ca.crt` is expected to contain the CA certificate
      #   that Admin Router's certificate will be verified against. It must be
      #   retrieved out-of-band (on Mesosphere Enterprise DC/OS this can be
      #   obtained via https://dcoshost/ca/dcos-ca.crt)
      #
      # verifyhost frontend-xxx.eu-central-1.elb.amazonaws.com
      #
      #   When verifying the TLS certificate presented by DC/OS Admin Router,
      #   perform hostname verification using the hostname specified here
      #   (expect the server certificate to contain a DNSName SAN that is
      #   equivalent to the hostname defined here). The hostname shown here is
      #   just an example and needs to be adjusted to your setup.
    
      server dcos-1 1.2.3.4:443 ssl verify required ca-file dcos-ca.crt verifyhost frontend-xxx.eu-central-1.elb.amazonaws.com
    
      # Option 2: use TLS-encrypted communication with DC/OS Admin Router, but do
      # not perform server certificate verification (warning: this is insecure, and
      # we hope that you know what you are doing).
      # server dcos-1 1.2.3.4:443 ssl verify none
      #
      # Rewrite response Location header if it contains an absolute URL
      # pointing to the 'dcoshost' host: replace 'dcoshost' with original
      # request Host header (containing hostname and port).
      http-response replace-header Location https?://dcoshost((/.*)?) "http://%[var(txn.request_host_header)]\1"
    ```

1.  Start HAProxy with these settings. 
