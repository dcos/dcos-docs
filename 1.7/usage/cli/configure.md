---
post_title: Configuring the CLI
nav_title: Configuration
menu_order: 2
---

The DC/OS CLI configuration can be seen using the following command:

    $ dcos config show
    core.dcos_url=http://dcos.example.com
    core.email=jdoe@example.com
    core.reporting=False
    core.ssl_verify=false
    core.timeout=5
    

This configuration is stored in the `~/./dcos/dcos.toml` configuration file.

# Configure DC/OS URL

If you are using multiple DC/OS installations (e.g. dev, test, prod), it may be necessary to reconfigure the CLI to point to a new cluster. This can be done by changing the value of the `dcos_url` configuration field.

*   See the current value of `dcos_url`:
    
        $ dcos config show core.dcos_url
        http://example.com
        

*   Update the value of `dcos_url`:
    
        $ dcos config set core.dcos_url http://example.com
        
    
    Once changed, subsequent commands will be issued to the new URL.

# Configure HTTP Proxy

If you use a proxy server to connect to the Internet, you can configure the CLI to use your proxy server.

**Prerequisites**

*   pip version 7.1.0 or greater
*   The `http_proxy` and `https_proxy` environment variables are defined to use pip.

To configure a proxy for the CLI:

*   From the CLI terminal, define the environment variables `http_proxy` and `https_proxy`:
    
        $ export http_proxy=’<http://your/proxy/here/>’
        $ export https_proxy=’<http://your/proxy/here/>’
        

*   Define `no_proxy` for domains that you don’t want to use the proxy for:
    
        $ export no_proxy="127.0.0.1, localhost”
