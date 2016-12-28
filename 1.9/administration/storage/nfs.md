---
post_title: NFS Server
menu_order: 1
---

# Overview

For some stateful services, such as Jenkins/Velocity, it can be convenient to mount a shared network drive to every node. A shared network drive makes it possible to launch the task on a new node if the node in use becomes unavailable.

**Note:** This example uses CoreOS and systemd and has not been tested in other environments.

## Notes

- These instructions are CoreOS-specific.
- This is not an HA NFS server. It runs on a single master and should only be used as a proof of concept.
- If you have access to a pre-existing NFS or another network store, skip to <a href="#part2">part II</a>.

### Part I: Configure the master with the file-share

1. Log in to the master node using the DC/OS command line interface:

    ```bash
    $ dcos node ssh --master-proxy --leader
    ```

1. Set up a folder for NFS runtime information:

    ```bash
    $ sudo mkdir /var/lib/nfs
    ```

1. Write an `/etc/exports` file to describe the folders to export. Replace the path `/data` with the absolute path to the export folder, and the CIDR range `10.0.1.0/24` with an appropriate range for your subnet:

    ```bash
    $ cat /etc/exports
    /data 10.0.1.0/24(rw,async,no_subtree_check,no_root_squash,fsid=0)
    ```

1. Start `rpc-mountd` and `nfsd`:

    ```bash
    $ sudo systemctl start rpc-mountd
    $ sudo systemctl start nfsd
    ```

1. Enable `rpc-mountd` and `nfsd` for automatic startup:

    ```bash
    $ sudo systemctl enable rpc-mountd
    $ sudo systemctl enable nfsd
    ```

<a name="part2"></a>
### Part II: Configure the agent(s) to mount the drive

1. List nodes in the cluster:

    ```bash
    $ dcos node
     HOSTNAME       IP                         ID
    10.0.1.251  10.0.1.251  68ded4c8-8808-4a41-b460-7171355b2037-S1
    10.0.1.252  10.0.1.252  68ded4c8-8808-4a41-b460-7171355b2037-S0
    ```

1. SSH to a node:

    ```bash
    $ dcos node ssh --master-proxy --mesos-id=68ded4c8-8808-4a41-b460-7171355b2037-S0
    ```

1. Make a new folder to mount into:

    ```bash
    $ sudo mkdir /mnt/data
    ```

1. Set up a folder for NFS runtime information:

    ```bash
    $ sudo mkdir /var/lib/nfs
    ```

1. Create a new systemd mount unit to describe the mount. The name of the `.mount` file is the same as the path to the mount point, with the leading slash removed and other slashes converted to dash. Using `/mnt/data` as an example, the file is named `mnt-data.mount`. In addition, replace `10.0.7.181` with the IP of the NFS host. [More information can be found in the CoreOS documentation][1]:

    ```bash
    $ cat /etc/systemd/system/mnt-data.mount
    [Mount]
    What=10.0.7.181:/data
    Where=/mnt/data
    Type=nfs
    ```

1. Test the new mount by using `touch` to create a file:

    ```bash
    $ touch /mnt/data/test.txt
    ```

[1]: https://coreos.com/os/docs/latest/mounting-storage.html
