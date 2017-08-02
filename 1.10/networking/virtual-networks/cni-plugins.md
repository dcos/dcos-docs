---
nav_title: CNI Plugin Support
feature_maturity: preview
menu_order: 30
---

As of version 1.10, DC/OS works with any type of CNI network. Use CNI to allow your containers to communicate with one another when they are isolated from the hosts they are running on.

# Configuring your Cluster for CNI

Add your plugin and configuration file to each agent on your cluster. Consult the [CNI specification](https://github.com/containernetworking/cni/blob/master/SPEC.md) to learn more about CNI plugins and configuration.

1. Add your plugin file to the `opt/mesosphere/active/cni/` directory.

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

# Configuring your service to Use a CNI Plugin

Add a reference to the CNI in your service definition.

## Using the [Universal Container Runtime (UCR)](/docs/1.10/deploying-services/containerizers/ucr/)

Add the `ipAddress.networkName` parameter to your service definition, where `networkName` is the name of the network you added as the `name` parameter of the configuration file you added to each of your agent nodes in the previous step.

```
"ipAddress": {
        "networkName": "dcos"
}
```

## Using the [Docker Containerizer](/docs/1.10/deploying-services/containerizers/docker-containerizer/)

Add the `network.name` and `network.mode` parameters to your service definition, where `name` is the name of the network you added as the `name` parameter of the configuration file you added to each of your agent nodes in the previous step.
