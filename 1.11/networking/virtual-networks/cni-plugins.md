---
post_title: CNI Plugin Support
nav_title: CNI Plugin Support
feature_maturity: preview
menu_order: 30
---

As of version 1.10, DC/OS works with any type of CNI network. Use CNI to allow your containers to communicate with one another when they are isolated from the hosts they are running on.

# Configuring your Cluster for CNI

Add your plugin and configuration file to each agent on your cluster. Consult the [CNI specification](https://github.com/containernetworking/cni/blob/master/SPEC.md) to learn more about CNI plugins and configuration.

1. Add your plugin file to the `/opt/mesosphere/active/cni/` directory.

1. Add your configuration file to the `/opt/mesosphere/etc/dcos/network/cni/` directory.
   A typical configuration file looks like this.

   ```
   {
     "name": "dcos",
     "type": "bridge",
     "bridge": "m-dcos",
     "isGateway": true,
     "ipMasq": false,
     "mtu": 1420,
     "ipam": {
       "type": "host-local",
       "subnet": "9.0.1.0/25",
       "routes": [
         {
            "dst": "0.0.0.0/0"
         }
       ]
     }
   }
   ```
   The `type` parameter specifies the name of the plugin. Here, the plugin name is `bridge`. The `name` parameter is the name of the network, which you will also use later in your service definition.

# Configuring your Service to Use a CNI Plugin

**Note:** Your service must use the [Universal Container Runtime (UCR)](/docs/1.11/deploying-services/containerizers/ucr/).

Add the `ipAddress.networkName` parameter to your service definition. `networkName` must match the `name` parameter of the configuration file in the previous step. In our current example, it is `dcos`.

```
"ipAddress": {
        "networkName": "dcos"
}
```
