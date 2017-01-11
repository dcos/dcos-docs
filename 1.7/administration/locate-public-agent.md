---
post_title: Finding a public agent IP
menu_order: 200
---

After you have installed DC/OS with a public agent node declared, you can navigate to the public IP address of your public agent node.

**Prerequisites**

- DC/OS is installed with at least 1 master and [public agent](/docs/1.7/overview/concepts/#public) node
- DC/OS [CLI](/docs/1.7/usage/cli/) 0.4.6 or later
- [jq](https://github.com/stedolan/jq/wiki/Installation)
- [SSH](/docs/1.7/administration/sshcluster/) configured

You can find your public agent IP by running this command from your terminal. This command SSHs to your cluster to obtain cluster information and then pings [ifconfig.co](https://ifconfig.co/) to determine your public IP address. 

```
$ for id in $(dcos node --json | jq --raw-output '.[] | select(.reserved_resources.slave_public != null) | .id'); do dcos node ssh --option StrictHostKeyChecking=no --option LogLevel=quiet --master-proxy --mesos-id=$id "curl -s ifconfig.co" ; done 2>/dev/null
```

Here is an example where the public IP address is `52.39.29.79`:

```
$ for id in $(dcos node --json | jq --raw-output '.[] | select(.reserved_resources.slave_public != null) | .id'); do dcos node ssh --option StrictHostKeyChecking=no --option LogLevel=quiet --master-proxy --mesos-id=$id "curl -s ifconfig.co" ; done 2>/dev/null
52.39.29.79
52.40.79.170
52.40.79.170
```




