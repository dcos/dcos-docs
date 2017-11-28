---
post_title: Connecting to Multiple Clusters
nav_title: Multiple Clusters
menu_order: 3.1
---

You can connect the CLI to multiple DC/OS clusters using [dcos cluster](/docs/1.11/cli/command-reference/dcos-cluster). `dcos cluster` has subcommands to set up connections to and attach to clusters and rename and remove clusters. 

Setting up a connection to a cluster stores connection configuration in the file `<home-directory>/.dcos/clusters/<cluster_id>/dcos.toml`, attaches to the cluster, and authenticates to DC/OS. Attaching to a connected cluster sets it as the active cluster.

## Setting up a connection to a cluster

To set up a connection to a cluster, run the `dcos cluster setup` command, replacing `<dcos_url>` with the cluster URL:

```bash
dcos cluster setup <dcos_url>
```

## Attaching to a cluster

To attach to a connected cluster, run the `dcos cluster attach` command, replacing `<name>` with the cluster name:

```bash
dcos cluster attach <name>
```

## Viewing connected clusters

To view all connected clusters, run the `dcos cluster list` command. The command lists the cluster name, cluster ID, DC/OS version (if the cluster is reachable), and the URL of the master node. The attached cluster has an asterisk (`*`) by its cluster name. In this example, the cluster named `dcosdev` is attached:

```bash
  NAME                   CLUSTER ID                 VERSION                     URL
dcosprod     5f7fb957-6daf-446e-8689-0b5b476b2d39   1.10.0    https://dcosclus-eosy.us-west-2.elb.amazonaws.com
dcosdev*     cf96739f-f800-42ea-95d7-d60acc689194   1.10.0    https://dcosclus-5m65.us-west-2.elb.amazonaws.com
```

To view only the attached cluster, run the `dcos cluster list --attached` command.

## Renaming a cluster

You can rename a connected cluster with the `dcos cluster rename <old-name> <new-name>` command. For example, to rename your cluster from `dcosdev` to `dcoslive`:

```bash
dcos cluster rename dcosdev dcoslive
```

## Removing a cluster

You can remove a connected cluster with the `dcos cluster remove <name>` command. For example, to remove the cluster `dcosdev`:

```bash
dcos cluster remove dcosdev
```

If you remove the attached cluster, dcos commands to perform operations such as installing packages on the cluster will fail until you attach another connected cluster.
