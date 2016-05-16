---
post_title: Finding a public agent IP
---

After you have installed DC/OS with a public agent node declared, you can navigate to the public IP address of your public agent node.

**Prerequisites**

- DC/OS is installed with at least 1 master and [public agent](/docs/1.7/overview/concepts/#public) node
- DC/OS CLI is installed
- [jQuery](https://github.com/stedolan/jq/wiki/Installation)
- [SSH](/docs/1.7/administration/sshcluster/) configured

You can find your public agent IP by running this command from the DC/OS CLI. This command SSHs to your cluster to obtain cluster information and then pings [ifconfig.co](https://ifconfig.co/) to determine your public IP address. 

**Tip:** Due to a known issue, you might have to make an initial [SSH connection to your public agent](/administration/sshcluster/) node before running this command. 

```
$ echo "curl -s ifconfig.co" | dcos node ssh --master-proxy --mesos-id=$(dcos task --json | jq --raw-output '.[] | select(.name == "tomcat") | .slave_id') 2>/dev/null
```

Here is an example where the public IP address is `52.39.29.79`:

```
$ echo "curl -s ifconfig.co" | dcos node ssh --master-proxy --mesos-id=$(dcos task --json | jq --raw-output '.[] | select(.name == "tomcat") | .slave_id') 2>/dev/null
52.39.29.79
```



