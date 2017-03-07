---
post_title: Finding a Public Agent IP
nav_title: Finding a Public Agent
menu_order: 3.1
---

After you have installed DC/OS with a public agent node declared, you can navigate to the public IP address of your public agent node.

**Prerequisites**

- DC/OS is installed with at least 1 master and [public agent](/docs/1.8/overview/concepts/#public) node
- DC/OS [CLI](/docs/1.8/usage/cli/) 0.4.6 or later
- [jq](https://github.com/stedolan/jq/wiki/Installation)
- [SSH](/docs/1.8/administration/access-node/sshcluster/) configured

You can find your public agent IP by running this command from your terminal. This command SSHs to your cluster to obtain cluster information and then queries [ifconfig.co](https://ifconfig.co/) to determine your public IP address.

```
$ for id in $(dcos node --json | jq --raw-output '.[] | select(.attributes.public_ip == "true") | .id'); do dcos node ssh --option StrictHostKeyChecking=no --option LogLevel=quiet --master-proxy --mesos-id=$id "curl -s ifconfig.co" ; done 2>/dev/null
```

Here is an example where the public IP address is `52.39.29.79`:

```
$ for id in $(dcos node --json | jq --raw-output '.[] | select(.attributes.public_ip == "true") | .id'); do dcos node ssh --option StrictHostKeyChecking=no --option LogLevel=quiet --master-proxy --mesos-id=$id "curl -s ifconfig.co" ; done 2>/dev/null
52.39.29.79
```




