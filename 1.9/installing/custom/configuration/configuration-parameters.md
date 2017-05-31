---
post_title: Configuration Reference
menu_order: 600
---

This topic provides all available configuration parameters. Except where explicitly indicated, the configuration parameters apply to both [DC/OS](https://dcos.io/) and [Enterprise DC/OS](https://mesosphere.com/product/).

# Cluster Setup

| Parameter                              | Description                                                                                                                                               |
|----------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| [agent_list](#agent_list)                             | This parameter specifies a YAML nested list (`-`) of IPv4 addresses to your [private agent](/1.9/overview/concepts/#private) host names.                  |
| [aws_template_storage_bucket](#aws_template_storage_bucket)            | This parameter specifies the name of your S3 bucket.                                                                                                      |
| [aws_template_storage_bucket_path](#aws_template_storage_bucket_path)       | This parameter specifies the S3 bucket storage path.                                                                                                      |
| [aws_template_upload](#aws_template_upload)                    | This parameter specifies whether to automatically upload the customized advanced templates to your S3 bucket.                                             |
| [aws_template_storage_access_key_id](#aws_template_storage_access_key_id)     | This parameters specifies the AWS [Access Key ID](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html).    |
| [aws_template_storage_secret_access_key](#aws_template_storage_secret_access_key) | This parameter specifies the AWS [Secret Access Key](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html). |
| [bootstrap_url](#bootstrap_url)                          | This required parameter specifies the URI path for the DC/OS installer to store the customized DC/OS build files.                                         |
| [cluster_docker_credentials](#cluster_docker_credentials)             | This parameter specifies a dictionary of Docker credentials to pass.                                                                                      |
| [cluster_docker_registry_url](#cluster_docker_registry_url)            | This parameter specifies a custom URL that Mesos uses to pull Docker images from.                                                                         |
| [cluster_name](#cluster_name)                           | This parameter specifies the name of your cluster.                                                                                                        |
| [cosmos_config](#cosmos_config)                          | This parameter specifies a dictionary of packaging configuration to pass to the [DC/OS Package Manager (Cosmos)](https://github.com/dcos/cosmos).         |
| [exhibitor_storage_backend](#exhibitor_storage_backend)                          | This parameter specifies the type of storage backend to use for Exhibitor.          |
| [master_discovery](#master_discovery)                          | This required parameter specifies the Mesos master discovery method.         |
| [public_agent_list](#public_agent_list)                          | This parameter specifies a YAML nested list (-) of IPv4 addresses to your [public agent](/docs/1.9/overview/concepts/#public-agent-node) host names.        |
| [public_agent_list](#public_agent_list)                          | This parameter specifies a YAML nested list (-) of IPv4 addresses to your [public agent](/docs/1.9/overview/concepts/#public-agent-node) host names.        |
| [platform](#platform)                          | This parameter specifies the infrastructure platform.      |
| [rexray_config](#rexray_config)                          | This parameter specifies the [REX-Ray](https://rexray.readthedocs.org/en/v0.3.2/user-guide/config/) configuration method for enabling external persistent volumes in Marathon.    |

# Networking

| Parameter                    | Description                                                                                                                                                       |
|------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [dcos_overlay_enable](#dcos_overlay_enable)          | This block of parameters specifies whether to enable DC/OS virtual networks.                                                                                      |
| [dns_search](#dns_search)                   | This parameter specifies a space-separated list of domains that are tried when an unqualified domain is entered.                                                  |
| [resolvers](#resolvers)                    | This required parameter specifies a block of YAML nested list (`-`) of DNS resolvers for your DC/OS cluster nodes.                                                |
| [master_dns_bindall](#master_dns_bindall)                    | This parameter specifies whether the master DNS port is open.                                               |
| [use_proxy](#use_proxy)                    | This parameter specifies whether to enable the DC/OS proxy.                                                                                                       |

# Performance and Tuning

| Parameter           | Description                                                                                                                                                                                                                                                        |
|---------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [check_time](#check_time)          | This parameter specifies whether to check if Network Time Protocol (NTP) is enabled during DC/OS startup.                                                                                                                                                          |
| [docker_remove_delay](#docker_remove_delay) | This parameter specifies the amount of time to wait before removing stale Docker images stored on the agent nodes and the Docker image generated by the installer.                                                                                                 |
| [dcos_audit_logging](#dcos_audit_logging)      | (Enterprise DC/OS Only) This parameter specifies whether security decisions (authentication, authorization) are logged for Mesos, Marathon, and Jobs.                  |
| [enable_docker_gc](#enable_docker_gc)    | This parameter specifies whether to run the [docker-gc](https://github.com/spotify/docker-gc#excluding-images-from-garbage-collection) script, a simple Docker container and image garbage collection script, once every hour to clean up stray Docker containers. |
| [gc_delay](#gc_delay)            | This parameter specifies the maximum amount of time to wait before cleaning up the executor directories.                                                                                                                                                           |
| [log_directory](#log_directory)       | This parameter specifies the path to the installer host logs from the SSH processes.                                                                                                                                                                               |
| [process_timeout](#process_timeout)     | This parameter specifies the allowable amount of time, in seconds, for an action to begin after the process forks.                                                                                                                                                 |

# Security and Authentication

| Parameter                          | Description                                                                                                                                                |
|------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [auth_cookie_secure_flag](#auth_cookie_secure_flag)            | (Enterprise DC/OS Only) This parameter specifies whether to allow web browsers to send the DC/OS authentication cookie through a non-HTTPS connection. |
| [bouncer_expiration_auth_token_days](#bouncer_expiration_auth_token_days) | (Enterprise DC/OS Only) This parameter sets the auth token time-to-live (TTL) for Identity and Access Management.                                      |
| [customer_key](#customer_key)                       | (Enterprise DC/OS Only) This parameter specifies the Enterprise DC/OS customer key.                                                                     |
| [oauth_enabled](#oauth_enabled)                      | (DC/OS Only) This parameter specifies whether to enable authentication for your cluster.                                                               |
| [security](#security)                           | (Enterprise DC/OS Only) This parameter specifies the security mode: disabled, permissive, strict.                                                      |
| [ssh_key_path](#ssh_key_path)                       | This parameter specifies the path to the installer uses to log into the target nodes.                                                                      |
| [ssh_port](#ssh_port)                           | This parameter specifies the port to SSH to, for example 22.                                                                                               |
| [ssh_user](#ssh_user)                           | This parameter specifies the SSH username, for example `centos`.                                                                                           |
| [superuser_password_hash](#superuser_password_hash)            | (Enterprise DC/OS Only) This required parameter specifies the hashed superuser password.                                                               |
| [superuser_username](#superuser_username)                 | (Enterprise DC/OS Only) This required parameter specifies the user name of the superuser.                                                              |
| [telemetry_enabled](#telemetry_enabled)                  | This parameter specifies whether to enable sharing of anonymous data for your cluster.                                                                     |
| [zk_super_credentials](#zk_super_credentials)               | (Enterprise DC/OS Only) This parameter specifies the ZooKeeper superuser credentials.                                                                  |
| [zk_master_credentials](#zk_master_credentials)              | (Enterprise DC/OS Only) This parameter specifies the ZooKeeper master credentials.                                                                     |
| [zk_agent_credentials](#zk_agent_credentials)               | (Enterprise DC/OS Only) This parameter specifies the ZooKeeper agent credentials.                                                                      |

### agent_list
This parameter specifies a YAML nested list (`-`) of IPv4 addresses to your [private agent](/docs/1.9/overview/concepts/#private) host names.

### <a name="auth-cookie"></a>auth_cookie_secure_flag

This parameter specifies whether to allow web browsers to send the DC/OS authentication cookie through a non-HTTPS connection. Because the DC/OS authentication cookie allows access to the DC/OS cluster, it should be sent over an encrypted connection.

*   `auth_cookie_secure_flag: false` (default) Browsers will send the DC/OS authentication cookie through either an unencrypted HTTP connection or an encrypted HTTPS connection.

*   `auth_cookie_secure_flag: true` The authentication cookie set by DC/OS will contain the [`Secure` flag](https://www.owasp.org/index.php/SecureFlag), which instructs the browser to not send the cookie over unencrypted HTTP connections. This could cause authentication to fail under the following circumstances.

    - If the security mode is `disabled`.
    - If the security mode is `permissive`, the URL specifies HTTP, and the URL includes a target different from the root path (e.g., http://cluster-url.com/path/).
    - There are proxies in between the browser and DC/OS that terminate TLS.

### bootstrap_url
This required parameter specifies the URI path for the DC/OS installer to store the customized DC/OS build files. If you are using the automated DC/OS installer, you should specify `bootstrap_url: file:///opt/dcos_install_tmp` unless you have moved the installer assets. By default the automated DC/OS installer places the build files in `file:///opt/dcos_install_tmp`.

### <a name="auth-token-expiry"></a>bouncer_expiration_auth_token_days (Enterprise DC/OS Only)

This parameter sets the auth token time-to-live (TTL) for Identity and Access Management. You must specify the value in Python float syntax wrapped in a YAML string. By default the token expires after 5 days. For example, to set the token lifetime to half a day:

```json
bouncer_expiration_auth_token_days: '0.5'
```

### <a name="check-time"></a>check_time
This parameter specifies whether to check if Network Time Protocol (NTP) is enabled during DC/OS startup. It recommended that NTP is enabled for a production environment.

*  `check_time: 'true'` Check if NTP is enabled during startup. You will receive an error if this is not enabled. This is the default value.
*  `check_time: 'false'` Do not check if NTP is enabled during startup.

### cluster_docker_credentials
This parameter specifies a dictionary of Docker credentials to pass. 

- If unset, a default empty credentials file is created at `/etc/mesosphere/docker_credentials` during DC/OS install. A sysadmin can change credentials as needed. A `systemctl restart dcos-mesos-slave` or `systemctl restart dcos-mesos-slave-public` is required for changes to take effect.
- You can also specify by using the `--docker_config` JSON [format](http://mesos.apache.org/documentation/latest/configuration/). You can write as YAML in the `config.yaml` file and it will automatically be mapped to the JSON format for you. This will store the Docker credentials in the same location as the DC/OS internal configuration (`/opt/mesosphere`). If you need to update or change the configuration, you will have to create a new DC/OS internal configuration.

You can use the following options to further configure the Docker credentials:

*  **cluster_docker_credentials_dcos_owned** This parameter specifies whether to store the credentials file in `/opt/mesosphere` or `/etc/mesosphere/docker_credentials`. A sysadmin cannot edit `/opt/mesosphere` directly.

    *  `cluster_docker_credentials_dcos_owned: 'true'` The credentials file is stored in `/opt/mesosphere`.
    
        *  **cluster_docker_credentials_write_to_etc** This parameter specifies whether to write a cluster credentials file.
        
            *  `cluster_docker_credentials_write_to_etc: 'true'` Write a credentials file. This can be useful if overwriting your credentials file will cause problems (e.g. if it is part of a machine image or AMI). This is the default value.
            *  `cluster_docker_credentials_write_to_etc: 'false'` Do not write a credentials file.
            
    *  `cluster_docker_credentials_dcos_owned: 'false'` The credentials file is stored in `/etc/mesosphere/docker_credentials`.

*  **cluster_docker_credentials_enabled** This parameter specifies whether to pass the Mesos `--docker_config` option to Mesos. 

    *  `cluster_docker_credentials_enabled: 'true'` Pass the Mesos `--docker_config` option to Mesos. It will point to a file that contains the provided `cluster_docker_credentials` data.
    *  `cluster_docker_credentials_enabled: 'false'` Do not pass the Mesos `--docker_config` option to Mesos. 
    
For more information, see the [examples](#docker-credentials).

### cluster_docker_registry_url
This parameter specifies a custom URL that Mesos uses to pull Docker images from. If set, it will configure the Mesos' `--docker_registry` flag to the specified URL. This changes the default URL Mesos uses for pulling Docker images. By default `https://registry-1.docker.io` is used.

### cluster_name
This parameter specifies the name of your cluster.

### cosmos_config
This parameter specifies a dictionary of packaging configuration to pass to the [DC/OS package manager](https://github.com/dcos/cosmos). If set, the following options must also be
specified.

* **package_storage_uri**
  This parameter specifies where to permanently store DC/OS packages. The value must be a file URL,
  for example, `file:///var/lib/dcos/cosmos/packages`.
* **staged_package_storage_uri**
    This parameter specifies where to temporarily store DC/OS packages while they are being added.
    The value must be a file URL, for example, `file:///var/lib/dcos/cosmos/staged-packages`.

### customer_key (Enterprise DC/OS Only)
This parameter specifies the Enterprise DC/OS customer key. Customer keys are delivered via email to the Authorized Support Contact.

This key is a 128-bit hyphen-delimited hexadecimal identifier used to distinguish an individual cluster. The customer key serves as the Universally Unique Identifier (UUID) for a given installation.

Customer keys look like this:

```
ab1c23de-45f6-7g8h-9012-i345j6k7lm8n
```
  
### <a name="dcos-audit-logging"></a>dcos_audit_logging (Enterprise DC/OS Only)

This parameter specifies whether security decisions (authentication, authorization) are logged for Mesos, Marathon, and Jobs.

* `'dcos_audit_logging': 'true'` Mesos, Marathon, and Jobs are logged. This is the default value.
* `'dcos_audit_logging': 'false'` Mesos, Marathon, and Jobs are not logged.

### <a name="dcos-overlay-enable"></a>dcos_overlay_enable

This parameter specifies whether to enable DC/OS virtual networks.

**Important:** Virtual networks require minimum Docker version 1.11. If you are using Docker 1.10 or earlier, you must specify `dcos_overlay_enable: 'false'`. For more information, see the [system requirements](/docs/1.9/installing/custom/system-requirements/).

*  `dcos_overlay_enable: 'false'` Do not enable the DC/OS virtual network.
*  `dcos_overlay_enable: 'true'` Enable the DC/OS virtual network. This is the default value. When the virtual network is enabled you can also specify the following parameters:

    *  `dcos_overlay_config_attempts` This parameter specifies how many failed configuration attempts are allowed before the overlay configuration modules stop trying to configure an virtual network.

        __Tip:__ The failures might be related to a malfunctioning Docker daemon.

    *  `dcos_overlay_mtu` This parameter specifies the maximum transmission unit (MTU) of the Virtual Ethernet (vEth) on the containers that are launched on the overlay.

    *  `dcos_overlay_network` This group of parameters define an virtual network for DC/OS.  The default configuration of DC/OS provides an virtual network named `dcos` whose YAML configuration is as follows:

        ```
        dcos_overlay_network:
            vtep_subnet: 44.128.0.0/20
            vtep_mac_oui: 70:B3:D5:00:00:00
            overlays:
              - name: dcos
                subnet: 9.0.0.0/8
                prefix: 26
        ```

        *  `vtep_subnet` This parameter specifies a dedicated address space that is used for the VxLAN backend for the virtual network. This address space should not be routeable from outside the agents or master.
        *  `vtep_mac_oui` This parameter specifies the MAC address of the interface connecting to it in the public node.
            
            **Important:** The last 3 bytes must be `00`.
        *  __overlays__
            *  `name` This parameter specifies the canonical name (see [limitations](/docs/1.9/networking/virtual-networks/) for constraints on naming virtual networks).
            *  `subnet` This parameter specifies the subnet that is allocated to the virtual network.
            *  `prefix` This parameter specifies the size of the subnet that is allocated to each agent and thus defines the number of agents on which the overlay can run. The size of the subnet is carved from the overlay subnet.

 For more information see the [example](#overlay) and [documentation](/docs/1.9/networking/virtual-networks/).
 
### <a name="dns-search"></a>dns_search
This parameter specifies a space-separated list of domains that are tried when an unqualified domain is entered (e.g. domain searches that do not contain &#8216;.&#8217;). The Linux implementation of `/etc/resolv.conf` restricts the maximum number of domains to 6 and the maximum number of characters the setting can have to 256. For more information, see <a href="http://man7.org/linux/man-pages/man5/resolv.conf.5.html">man /etc/resolv.conf</a>.

A `search` line with the specified contents is added to the `/etc/resolv.conf` file of every cluster host. `search` can do the same things as `domain` and is more extensible because multiple domains can be specified.

In this example, `example.com` has public website `www.example.com` and all of the hosts in the datacenter have fully qualified domain names that end with `dc1.example.com`. One of the hosts in your datacenter has the hostname `foo.dc1.example.com`. If `dns_search` is set to &#8216;dc1.example.com example.com&#8217;, then every DC/OS host which does a name lookup of foo will get the A record for `foo.dc1.example.com`. If a machine looks up `www`, first `www.dc1.example.com` would be checked, but it does not exist, so the search would try the next domain, lookup `www.example.com`, find an A record, and then return it.

```yaml
dns_search: dc1.example.com dc1.example.com example.com dc1.example.com dc2.example.com example.com
```

### <a name="docker-remove"></a>docker_remove_delay
This parameter specifies the amount of time to wait before removing stale Docker images stored on the agent nodes and the Docker image generated by the installer. It is recommended that you accept the default value 1 hour. 

### <a name="enable-docker-gc"></a>enable_docker_gc
This parameter specifies whether to run the [docker-gc](https://github.com/spotify/docker-gc#excluding-images-from-garbage-collection) script, a simple Docker container and image garbage collection script, once every hour to clean up stray Docker containers. You can configure the runtime behavior by using the `/etc/` config. For more information, see the [documentation](https://github.com/spotify/docker-gc#excluding-images-from-garbage-collection)

*  `enable_docker_gc: 'true'` Run the docker-gc scripts once every hour. This is the default value for [cloud](/docs/1.9/installing/cloud/) template installations.
*  `enable_docker_gc: 'false'` Do not run the docker-gc scripts once every hour. This is the default value for [custom](/docs/1.9/installing/custom/) installations.

### exhibitor_storage_backend
This parameter specifies the type of storage backend to use for Exhibitor. You can use internal DC/OS storage (`static`) or specify an external storage system (`zookeeper`, `aws_s3`, and `azure`) for configuring and orchestrating ZooKeeper with Exhibitor on the master nodes. Exhibitor automatically configures your ZooKeeper installation on the master nodes during your DC/OS installation.

*   `exhibitor_storage_backend: static`
    This option specifies that the Exhibitor storage backend is managed internally within your cluster.
*   `exhibitor_storage_backend: zookeeper`
    This option specifies a ZooKeeper instance for shared storage. If you use a ZooKeeper instance to bootstrap Exhibitor, this ZooKeeper instance must be separate from your DC/OS cluster. You must have at least 3 ZooKeeper instances running at all times for high availability. If you specify `zookeeper`, you must also specify these parameters.
    *   **exhibitor_zk_hosts**
        This parameter specifies a comma-separated list (`<ZK_IP>:<ZK_PORT>, <ZK_IP>:<ZK_PORT>, <ZK_IP:ZK_PORT>`) of one or more ZooKeeper node IP and port addresses to use for configuring the internal Exhibitor instances. Exhibitor uses this ZooKeeper cluster to orchestrate it's configuration. Multiple ZooKeeper instances are recommended for failover in production environments.
    *   **exhibitor_zk_path**
        This parameter specifies the filepath that Exhibitor uses to store data.
*   `exhibitor_storage_backend: aws_s3`
    This option specifies an Amazon Simple Storage Service (S3) bucket for shared storage. If you specify `aws_s3`, you must also specify these parameters:
    *  **aws_access_key_id**
       This parameter specifies AWS key ID.
    *  **aws_region**
       This parameter specifies AWS region for your S3 bucket.
    *  **aws_secret_access_key**
       This parameter specifies AWS secret access key.
    *  **exhibitor_explicit_keys**
       This parameter specifies whether you are using AWS API keys to grant Exhibitor access to S3.
        *  `exhibitor_explicit_keys: 'true'`
           If you're  using AWS API keys to manually grant Exhibitor access.
        *  `exhibitor_explicit_keys: 'false'`
           If you're using AWS Identity and Access Management (IAM) to grant Exhibitor access to s3.
    *  **s3_bucket**
       This parameter specifies name of your S3 bucket.
    *  **s3_prefix**
       This parameter specifies S3 prefix to be used within your S3 bucket to be used by Exhibitor.

       **Tip:** AWS EC2 Classic is not supported.
*   `exhibitor_storage_backend: azure`
   This option specifies an Azure Storage Account for shared storage. The data will be stored under the container named `dcos-exhibitor`. If you specify `azure`, you must also specify these parameters:
    *  **exhibitor_azure_account_name**
       This parameter specifies the Azure Storage Account Name.
    *  **exhibitor_azure_account_key**
       This parameter specifies a secret key to access the Azure Storage Account.
    *  **exhibitor_azure_prefix**
       This parameter specifies the blob prefix to be used within your Storage Account to be used by Exhibitor.

### <a name="gc-delay"></a>gc_delay
This parameter specifies the maximum amount of time to wait before cleaning up the executor directories. It is recommended that you accept the default value of 2 days.

### <a name="log_directory"></a>log_directory
This parameter specifies the path to the installer host logs from the SSH processes. By default this is set to `/genconf/logs`. In most cases this should not be changed because `/genconf` is local to the container that is running the installer, and is a mounted volume.

### <a name="master"></a>master_discovery
This required parameter specifies the Mesos master discovery method. The available options are `static` or `master_http_loadbalancer`.

*  `master_discovery: static`
This option specifies that Mesos agents are used to discover the masters by giving each agent a static list of master IPs. The masters must not change IP addresses, and if a master is replaced, the new master must take the old master's IP address. If you specify `static`, you must also specify this parameter:

    *  **master_list**
       This required parameter specifies a list of your static master IP addresses as a YAML nested series (`-`).

*   `master_discovery: master_http_loadbalancer` This option specifies that the set of masters has an HTTP load balancer in front of them. The agent nodes will know the address of the load balancer. They use the load balancer to access Exhibitor on the masters to get the full list of master IPs. If you specify `master_http_load_balancer`, you must also specify these parameters:

    *  **exhibitor_address** 
       This required parameter specifies the address (preferably an IP address) of the load balancer in front of the masters. If you need to replace your masters, this address becomes the static address that agents can use to find the new master. For Enterprise DC/OS, this address is included in [DC/OS certificates](https://docs.mesosphere.com/1.9/networking/tls-ssl/). 
    
       The load balancer must accept traffic on ports 80, 443, 2181, 5050, 8080, 8181. The traffic must also be forwarded to the same ports on the master. For example, Mesos port 5050 on the load balancer should forward to port 5050 on the master. The master should forward any new connections via round robin, and should avoid machines that do not respond to requests on Mesos port 5050 to ensure the master is up.
    *  **num_masters**
       This required parameter specifies the number of Mesos masters in your DC/OS cluster. It cannot be changed later. The number of masters behind the load balancer must never be greater than this number, though it can be fewer during failures.

*Note*: On platforms like AWS where internal IPs are allocated dynamically, you should not use a static master list. If a master instance were to terminate for any reason, it could lead to cluster instability.

### master_dns_bindall
This parameter specifies whether the master DNS port is open. An open master DNS port listens publicly on the masters. If you are upgrading, set this parameter to `true`.

*  `'master_dns_bindall': 'true'` The master DNS port is open. This is the default value.
*  `'master_dns_bindall': 'false'` The master DNS port is closed.

### oauth_enabled (DC/OS Only)
This parameter specifies whether to enable authentication for your cluster. <!-- DC/OS auth -->

- `oauth_enabled: 'true'` Enable authentication for your cluster. This is the default value.
- `oauth_enabled: 'false'` Disable authentication for your cluster.

If you’ve already installed your cluster and would like to disable this in-place, you can go through an upgrade with the same parameter set.

### <a name="public-agent"></a>public_agent_list
This parameter specifies a YAML nested list (`-`) of IPv4 addresses to your [public agent](/docs/1.9/overview/concepts/#public-agent-node) host names.

### <a name="platform"></a>platform
This parameter specifies the infrastructure platform. The value is optional, free-form with no content validation, and used for telemetry only. Please supply an appropriate value to help inform DC/OS platform prioritization decisions. Example values: `aws`, `azure`, `oneview`, `openstack`, `vsphere`, `vagrant-virtualbox`, `onprem` (default).

### <a name="process_timeout"></a>process_timeout
This parameter specifies the allowable amount of time, in seconds, for an action to begin after the process forks. This parameter is not the complete process time. The default value is 120 seconds.

**Tip:** If have a slower network environment, consider changing to `process_timeout: 600`.

### <a name="#resolvers"></a>resolvers
This required parameter specifies a YAML nested list (`-`) of DNS resolvers for your DC/OS cluster nodes. You can specify a maximum of 3 resolvers. Set this parameter to the most authoritative nameservers that you have.

-  If you want to resolve internal hostnames, set it to a nameserver that can resolve them.
-  If you do not have internal hostnames to resolve, you can set this to a public nameserver like Google or AWS. For example, you can specify the [Google Public DNS IP addresses (IPv4)](https://developers.google.com/speed/public-dns/docs/using):

    ```bash
    resolvers:
    - 8.8.4.4
    - 8.8.8.8
    ```
-  If you do not have a DNS infrastructure and do not have access to internet DNS servers, you can specify `resolvers: []`. By specifying this setting, all requests to non-`.mesos` will return an error. For more information, see the Mesos-DNS [documentation](/docs/1.9/networking/mesos-dns/).

**Caution:** If you set the `resolvers` parameter incorrectly, you will permanently damage your configuration and have to reinstall DC/OS.

### <a name="rexray-config"></a>rexray_config
This parameter specifies the <a href="https://rexray.readthedocs.org/en/v0.3.2/user-guide/config/" target="_blank">REX-Ray</a> configuration method for enabling external persistent volumes in Marathon. REX-Ray is a storage orchestration engine. The following is an example configuration.

    rexray_config:
      rexray:
        loglevel: info
        modules:
          default-admin:
            host: tcp://127.0.0.1:61003
        storageDrivers:
        - ec2
        volume:
          unmount:
            ignoreusedcount: true

See the external persistent volumes [documentation](/docs/1.9/storage/external-storage/) for information on how to create your configuration.

### <a name="security"></a>security (Enterprise DC/OS Only)
Use this parameter to specify a security mode other than `security: permissive` (the default). The possible values follow.

- `security: disabled`
- `security: permissive`
- `security: strict`

Refer to the [Security modes](/1.9/security/#security-modes) section for a detailed discussion of each parameter. 

### ssh_key_path
This parameter specifies the path to the installer uses to log into the target nodes. By default this is set to `/genconf/ssh_key`. This parameter should not be changed because `/genconf` is local to the container that is running the installer, and is a mounted volume.

### ssh_port
This parameter specifies the port to SSH to, for example `22`.

### ssh_user
This parameter specifies the SSH username, for example `centos`.

### superuser_password_hash (Enterprise DC/OS Only)
This required parameter specifies the hashed superuser password. The `superuser_password_hash` is generated by using the installer `--hash-password` flag. For more information, see the [Security documentation](/1.9/security/).

### superuser_username (Enterprise DC/OS Only)
This required parameter specifies the user name of the superuser. For more information, see [Identity and Access Management](/1.9/security/).

### telemetry_enabled
This parameter specifies whether to enable sharing of anonymous data for your cluster. <!-- DC/OS auth -->

- `telemetry_enabled: 'true'` Enable anonymous data sharing. This is the default value.
- `telemetry_enabled: 'false'` Disable anonymous data sharing.

If you’ve already installed your cluster and would like to disable this in-place, you can go through an [upgrade][3] with the same parameter set.

### use_proxy

This parameter specifies whether to enable the DC/OS proxy. 

*  `use_proxy: 'false'` Do not configure DC/OS [components](/docs/1.9/overview/architecture/components/) to use a custom proxy. This is the default value.
*  `use_proxy: 'true'` Configure DC/OS [components](/docs/1.9/overview/architecture/components/) to use a custom proxy. If you specify `use_proxy: 'true'`, you can also specify these parameters:
    **Important:** The specified proxies must be resolvable from the provided list of [resolvers](#resolvers).
    *  `http_proxy: http://<user>:<pass>@<proxy_host>:<http_proxy_port>` This parameter specifies the HTTP proxy.
    *  `https_proxy: https://<user>:<pass>@<proxy_host>:<https_proxy_port>` This parameter specifies the HTTPS proxy.
    *  `no_proxy: - .<(sub)domain>` This parameter specifies YAML nested list (-) of addresses to exclude from the proxy.

For more information, see the [examples](#http-proxy).

**Important:** You should also configure an HTTP proxy for [Docker](https://docs.docker.com/engine/admin/systemd/#/http-proxy). 

