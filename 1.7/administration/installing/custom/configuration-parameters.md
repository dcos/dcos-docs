---
UID: 56f984452f28e
post_title: Configuration parameters
post_excerpt: ""
layout: docs.jade
published: true
menu_order: 100
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: true
---
These configuration parameters are specified in [YAML][1] format in your config.yaml file. During DC/OS installation the configuration file is used to generate a customized DC/OS build. <!-- A config.yaml template file is available [here][2]. -->

# Cluster Setup

### [config-yaml-agent-list]

### [config-yaml-bootstrap-url]

### [config-yaml-cluster-name]

### **exhibitor_storage_backend**
This parameter specifies the type of storage backend to use for Exhibitor. You can use internal DC/OS storage (<code>static</code>) or specify an external storage system (<code>zookeeper</code>, <code>aws_s3</code>, and <code>shared_filesystem</code>) for configuring and orchestrating Zookeeper with Exhibitor on the master nodes. Exhibitor automatically configures your Zookeeper installation on the master nodes during your DC/OS installation. 

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

#### DC/OS cluster with 3 masters, an Exhibitor/Zookeeper backed by Zookeeper, and static master list specified.

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
    

#### <a name="shared"></a>DC/OS cluster with 3 masters, an Exhibitor/Zookeeper shared filesystem storage backend, Internal DNS

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
    - <dns-resolver-1>
    - <dns-resolver-2>
    roles: slave_public
    ssh_key_path: /genconf/ssh-key
    ssh_port: '<port-number>'
    ssh_user: <username>
    weights: slave_public=1
    

#### <a name="aws"></a>DC/OS Cluster with 3 masters, an Exhibitor/Zookeeper backed by an AWS S3 bucket, AWS DNS, and a public agent node

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
    - <dns-resolver-1>
    - <dns-resolver-2>
    roles: slave_public
    s3_bucket: mybucket
    s3_prefix: s3-example
    ssh_key_path: /genconf/ssh-key
    ssh_port: '<port-number>'
    ssh_user: <username>
    weights: slave_public=1
    

#### <a name="zk"></a>DC/OS cluster with 3 masters, an Exhibitor/Zookeeper backed by Zookeeper, VRRP master discovery, public agent node, and Google DNS

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
    - <dns-resolver-1>
    - <dns-resolver-2>
    roles: slave_public
    ssh_key_path: /genconf/ssh-key
    ssh_port: '<port-number>'
    ssh_user: <username>
    weights: slave_public=1

 [1]: https://en.wikipedia.org/wiki/YAML
