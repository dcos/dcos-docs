---
post_title: Install Configuration Parameters
nav_title: Config
menu_order: 7
---

These configuration parameters are specified in [YAML][1] format in your config.yaml file. During DC/OS installation the configuration file is used to generate a customized DC/OS build. <!-- A config.yaml template file is available [here][2]. -->

# Cluster Setup

### agent_list
This parameter specifies a YAML nested list (`-`) of IPv4 addresses to your agent host names.

### bootstrap_url
This required parameter specifies the URI path for the DC/OS installer to store the customized DC/OS build files. If you are using the automated DC/OS installer, you should specify `bootstrap_url: file:///opt/dcos_install_tmp` unless you have moved the installer assets. By default the automated DC/OS installer places the build files in `file:///opt/dcos_install_tmp`.

### cluster_name
This parameter specifies the name of your cluster.

### exhibitor_storage_backend
This parameter specifies the type of storage backend to use for Exhibitor. You can use internal DC/OS storage (`static`) or specify an external storage system (`zookeeper`, `aws_s3`, and `shared_filesystem`) for configuring and orchestrating Zookeeper with Exhibitor on the master nodes. Exhibitor automatically configures your Zookeeper installation on the master nodes during your DC/OS installation.

*   `exhibitor_storage_backend: static`
    This option specifies that the Exhibitor storage backend is managed internally within your cluster.
*   `exhibitor_storage_backend: zookeeper`
    This option specifies a ZooKeeper instance for shared storage. If you use a ZooKeeper instance to bootstrap Exhibitor, this ZooKeeper instance must be separate from your DC/OS cluster. You must have at least 3 ZooKeeper instances running at all times for high availability. If you specify `zookeeper`, you must also specify these parameters.
    *   **exhibitor_zk_hosts**
        This parameter specifies a comma-separated list of one or more ZooKeeper node IP addresses to use for configuring the internal Exhibitor instances. Exhibitor uses this ZooKeeper cluster to orchestrate it's configuration. Multiple ZooKeeper instances are recommended for failover in production environments.
    *   **exhibitor_zk_path**
        This parameter specifies the filepath that Exhibitor uses to store data, including the `zoo.cfg` file.
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
        *  `exhibitor_explicit_keys: true`
           If you're  using AWS API keys to manually grant Exhibitor access.
        *  `exhibitor_explicit_keys: false`
           If you're using AWS Identity and Access Management (IAM) to grant Exhibitor access to s3.
    *  **s3_bucket**
       This parameter specifies name of your S3 bucket.
    *  **s3_prefix**
       This parameter specifies S3 prefix to be used within your S3 bucket to be used by Exhibitor.

*   `exhibitor_storage_backend: shared_filesystem`
    This option specifies a Network File System (NFS) mount for shared storage. If you specify `shared_filesystem`, you must also specify this parameter:
    *  **exhibitor_fs_config_dir**
       This parameter specifies the absolute path to the folder that Exhibitor uses to coordinate its configuration. This should be a directory inside of a Network File System (NFS) mount. For example, if every master has `/fserv` mounted via NFS, set as `exhibitor_fs_config_dir: /fserv/dcos-exhibitor`.

       **Important:** With `shared_filesystem`, all masters must must have the NFS volume mounted and `exhibitor_fs_config_dir` must be inside of it. If any of your servers are missing the mount, the DC/OS cluster will not start.

### <a name="master"></a>master_discovery
This required parameter specifies the Mesos master discovery method. The available options are `static` or `vrrp`.

*  `master_discovery: static`
This option specifies that Mesos agents are used to discover the masters by giving each agent a static list of master IPs. The masters must not change IP addresses, and if a master is replaced, the new master must take the old master's IP address. If you specify `static`, you must also specify this parameter:

    *  **master_list**
       This required parameter specifies a list of your static master IP addresses as a YAML nested series (`-`).

*  `master_discovery: vrrp`
This option specifies that Keepalived with a VIP is used to discover the master. You are required to maintain this VIP infrastructure. If you specify `vrrp`, you must also specify these parameters:

    *  **keepalived_router_id**
       This parameter specifies the virtual router ID of the Keepalived cluster. You must use the same virtual router ID across your cluster.
    *  **keepalived_interface**
       This parameter specifies the interface that Keepalived uses.
    *  **keepalived_pass**
       If you've set your `auth_type` to `PASS`, this parameter specifies the password that you set for `auth_pass` in your Keepalived configuration file.
    *  **keepalived_virtual_ipaddress**
       This parameter specifies the VIP in use by your Keepalived cluster.
    *  **num_masters**
       This parameter specifies the number of Mesos masters in your DC/OS cluster. If `master_discovery: static`, do not use the `num_masters` parameter.

## Security and Authentication

### auth_cookie_secure_flag
This parameter specifies whether to allow web browsers to send the DC/OS authentication cookie through a non-HTTPS connection.

*  `auth_cookie_secure_flag: false` Send the DC/OS authentication cookie through non-HTTPS connections.  If you are accessing the DC/OS cluster through an HTTP connection, this is the required setting. This is the default value.
*  `auth_cookie_secure_flag: true` Require an HTTPS connection to send the DC/OS authentication cookie. If you are accessing the DC/OS cluster through only HTTPS connections, this is the recommended setting.

### ssh_key_path
This parameter specifies the path to the installer uses to log into the target nodes. By default this is set to `/genconf/ssh_key`. This parameter should not be changed because `/genconf` is local to the container that is running the installer, and is a mounted volume.
### ssh_port
This parameter specifies the port to SSH to, for example `22`.
### ssh_user
This parameter specifies the SSH username, for example `centos`.
### superuser_password_hash
This required parameter specifies the hashed superuser password. The `superuser_password_hash` is generated by using the installer `--hash-password` flag. For more information, see <a href="https://docs.mesosphere.com/administration/security-and-authentication/managing-authorization/" target="_blank">Managing Authorization and Authentication</a>.
### superuser_username
This required parameter specifies the Admin username. For more information, see <a href="https://docs.mesosphere.com/administration/security-and-authentication/managing-authorization/" target="_blank">Managing Authorization and Authentication</a>.

## Networking
### <a name="dns-search"></a>dns_search
This parameter specifies a space-separated list of domains that are tried when an unqualified domain is entered (e.g. domain searches that do not contain &#8216;.&#8217;). The Linux implementation of `/etc/resolv.conf` restricts the maximum number of domains to 6 and the maximum number of characters the setting can have to 256. For more information, see <a href="http://man7.org/linux/man-pages/man5/resolv.conf.5.html">man /etc/resolv.conf</a>.

A `search` line with the specified contents is added to the `/etc/resolv.conf` file of every cluster host. `search` can do the same things as `domain` and is more extensible because multiple domains can be specified.

In this example, `example.com` has public website `www.example.com` and all of the hosts in the datacenter have fully qualified domain names that end with `dc1.example.com`. One of the hosts in your datacenter has the hostname `foo.dc1.example.com`. If `dns_search` is set to &#8216;dc1.example.com example.com&#8217;, then every DC/OS host which does a name lookup of foo will get the A record for `foo.dc1.example.com`. If a machine looks up `www`, first `www.dc1.example.com` would be checked, but it does not exist, so the search would try the next domain, lookup `www.example.com`, find an A record, and then return it.

    dns_search: dc1.example.com dc1.example.com example.com dc1.example.com dc2.example.com example.com

### resolvers
This required parameter specifies a YAML nested list (`-`) of DNS resolvers for your DC/OS cluster nodes. You can specify a maximum of 3 resolvers. Set this parameter to the most authoritative nameservers that you have. If you want to resolve internal hostnames, set it to a nameserver that can resolve them. If you have no internal hostnames to resolve, you can set this to a public nameserver like Google or AWS. In the example file above, the <a href="https://developers.google.com/speed/public-dns/docs/using" target="_blank">Google Public DNS IP addresses (IPv4)</a> are specified (`8.8.8.8` and `8.8.4.4`).

**Caution:** If you set the `resolvers` parameter incorrectly, you will permanently damage your configuration and have to reinstall DC/OS.

## Performance and Tuning
### <a name="docker-remove"></a>docker_remove_delay
This parameter specifies the amount of time to wait before removing the Docker image generated by the installer. It is recommended that you accept the default value 1 hour.

### <a name="gc-delay"></a>gc_delay
This parameter specifies the maximum amount of time to wait before cleaning up the executor directories. It is recommended that you accept the default value of 2 days.

### <a name="log_directory"></a>log_directory
This parameter specifies the path to the installer host logs from the SSH processes. By default this is set to `/genconf/logs`. In most cases this should not be changed because `/genconf` is local to the container that is running the installer, and is a mounted volume.

### <a name="process_timeout"></a>process_timeout
This parameter specifies the allowable amount of time, in seconds, for an action to begin after the process forks. This parameter is not the complete process time. The default value is 120 seconds.

**Tip:** If have a slower network environment, consider changing to `process_timeout: 600`.

<!--
### <a name="roles"></a>roles
This parameter specifies the Mesos roles to delegate to a node. For more information, see <a href="https://open.mesosphere.com/reference/mesos-master/#roles" target="_blank">Mesos roles</a>. The available options are `slave_public`, ` master `, and `slave`.

*  `roles: slave_public`
   Runs the public agent node. This is the default value.
*  `roles: master`
   Runs the master node.
*  `roles: slave`
   Runs the private agent node.

### [config-yaml-bootstrap-url]

### [config-yaml-cluster-name]

### **exhibitor_storage_backend**
This parameter specifies the type of storage backend to use for Exhibitor. You can use internal DC/OS storage (<code>static</code>) or specify an external storage system (<code>zookeeper</code>, <code>aws_s3</code>, and <code>shared_filesystem</code>) for configuring and orchestrating ZooKeeper with Exhibitor on the master nodes. Exhibitor automatically configures your ZooKeeper installation on the master nodes during your DC/OS installation.

*   [config-yaml-zk-static]
*   [config-yaml-zookeeper]
    *   [config-yaml-exhibitor-zk-hosts]
    *   [config-yaml-exhibitor-zk-path]
*   [config-yaml-aws-s3]
*   [config-yaml-shared-filesystem]

### [config-yaml-master-discovery]

*   [config-yaml-static]
    *   [config-yaml-master-list]
*   [config-yaml-vrrp]
    *   [config-yaml-keepalived-router-id]
    *   [config-yaml-keepalived-interface]
    *   [config-yaml-keepalived-pass]
    *   [config-yaml-keepalived-virtual-ipaddress]
    *   [config-yaml-num-masters]

### [config-yaml-rexray-config-method]

# Security and Authentication

### [config-yaml-auth-cookie-secure-flag]

### [config-yaml-ssh-key-path]

### [config-yaml-ssh-port]

### [config-yaml-ssh-user]

### [config-yaml-superuser-password-hash]

### [config-yaml-superuser-username]

# Networking

### [config-yaml-dns-search]

### [config-yaml-resolvers]

# Performance and Tuning

### [config-yaml-docker-remove-delay]

### [config-yaml-gc-delay]

### [config-yaml-log-directory]

### [config-yaml-process-timeout]

### [config-yaml-roles]

*   [config-yaml-slave-public]
*   [config-yaml-master]
*   [config-yaml-slave]

### [config-yaml-weights]

# <a name="examples1"></a>Example Configurations

#### DC/OS cluster with 3 masters, an Exhibitor/ZooKeeper backed by ZooKeeper, and static master list specified.

    agent_list:
    - <agent-private-ip-1>
    - <agent-private-ip-2>
    - <agent-private-ip-3>
    - <agent-private-ip-4>
    - <agent-private-ip-5>
    bootstrap_url: 'file:///opt/dcos_install_tmp'
    cluster_name: '<cluster-name>'
    exhibitor_storage_backend: zookeeper
    exhibitor_zk_hosts: <host1>:<port1>
    exhibitor_zk_path: /dcos
    log_directory: /genconf/logs
    master_discovery: static
    master_list:
    - <master-private-ip-1>
    - <master-private-ip-2>
    - <master-private-ip-3>
    process_timeout: 120
    resolvers:
    - <dns-resolver-1>
    - <dns-resolver-2>
    ssh_key_path: /genconf/ssh-key
    ssh_port: '<port-number>'
    ssh_user: <username>


#### <a name="shared"></a>DC/OS cluster with 3 masters, an Exhibitor/ZooKeeper shared filesystem storage backend, Internal DNS

    agent_list:
    - <agent-private-ip-1>
    - <agent-private-ip-2>
    - <agent-private-ip-3>
    - <agent-private-ip-4>
    - <agent-private-ip-5>
    bootstrap_url: file:///tmp/dcos
    cluster_name: fs-example
    exhibitor_fs_config_dir: /shared-mount
    exhibitor_storage_backend: shared_filesystem
    log_directory: /genconf/logs
    master_discovery: static
    master_list:
    - <master-private-ip-1>
    - <master-private-ip-2>
    - <master-private-ip-3>
    process_timeout: 120
    resolvers:
    - 0.10.5.1
    - 10.10.6.1
    roles: slave_public
    ssh_key_path: /genconf/ssh-key
    ssh_port: '<port-number>'
    ssh_user: <username>
    weights: slave_public=1


#### <a name="aws"></a>DC/OS Cluster with 3 masters, an Exhibitor/ZooKeeper backed by an AWS S3 bucket, AWS DNS, and a public agent node

    agent_list:
    - <agent-private-ip-1>
    - <agent-private-ip-2>
    - <agent-private-ip-3>
    - <agent-private-ip-4>
    - <agent-private-ip-5>
    aws_access_key_id: AKIAIOSFODNN7EXAMPLE
    aws_region: us-west-2
    aws_secret_access_key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
    bootstrap_url: file:///tmp/dcos
    cluster_name: s3-example
    exhibitor_storage_backend: aws_s3
    log_directory: /genconf/logs
    master_discovery: static
    master_list:
    - <master-private-ip-1>
    - <master-private-ip-2>
    - <master-private-ip-3>
    process_timeout: 120
    resolvers:
    - 169.254.169.253
    roles: slave_public
    s3_bucket: mybucket
    s3_prefix: s3-example
    ssh_key_path: /genconf/ssh-key
    ssh_port: '<port-number>'
    ssh_user: <username>
    weights: slave_public=1


#### <a name="zk"></a>DC/OS cluster with 3 masters, an Exhibitor/ZooKeeper backed by ZooKeeper, VRRP master discovery, public agent node, and Google DNS

    agent_list:
    - <agent-private-ip-1>
    - <agent-private-ip-2>
    - <agent-private-ip-3>
    - <agent-private-ip-4>
    - <agent-private-ip-5>
    bootstrap_url: file:///tmp/dcos
    cluster_name: zk-example
    exhibitor_storage_backend: zookeeper
    exhibitor_zk_hosts: 10.10.10.1:2181
    exhibitor_zk_path: /zk-example
    keepalived_interface: eth1
    keepalived_pass: $MY_STRONG_PASSWORD
    keepalived_router_id: 51
    keepalived_virtual_ipaddress: 67.34.242.55
    log_directory: /genconf/logs
    master_discovery: vrrp
    num_masters: 3
    process_timeout: 120
    resolvers:
    - 8.8.4.4
    - 8.8.8.8
    roles: slave_public
    ssh_key_path: /genconf/ssh-key
    ssh_port: '<port-number>'
    ssh_user: <username>
    weights: slave_public=1

 [1]: https://en.wikipedia.org/wiki/YAML
