---
post_title: Uninstalling DC/OS
nav_title: Uninstall
menu_order: 500
---

You can uninstall DC/OS from each node individually or from all nodes at once.

## Uninstall all nodes
   
You can completely uninstall DC/OS from all of your nodes by using this method. You must have installed DC/OS via the CLI or GUI installer to use this method.
   
From the bootstrap node, enter this command:

```bash
$ sudo bash dcos_generate_config.sh --uninstall
```

Here is an example of the output:

```bash
Running mesosphere/dcos-genconf docker with BUILD_DIR set to /home/centos/genconf
====> EXECUTING UNINSTALL
This will uninstall DC/OS on your cluster. You may need to manually remove /var/lib/zookeeper in some cases after this completes, please see our documentation for details. Are you ABSOLUTELY sure you want to proceed? [ (y)es/(n)o ]: yes
====> START uninstall_dcos
====> STAGE uninstall
====> STAGE uninstall
====> OUTPUT FOR uninstall_dcos
====> END uninstall_dcos with returncode: 0
====> SUMMARY FOR uninstall_dcos
2 out of 2 hosts successfully completed uninstall_dcos stage.
====> END OF SUMMARY FOR uninstall_dcos
```

## Uninstall individual nodes

You can uninstall DC/OS from individual nodes by using this method.

From each node, enter these commands:

```bash
$ sudo -i /opt/mesosphere/bin/pkgpanda uninstall
$ sudo rm -rf /opt/mesosphere /var/lib/mesosphere /etc/mesosphere /var/lib/zookeeper /var/lib/mesos /var/lib/dcos  /run/dcos
$ sudo rm -rf /etc/profile.d/dcos.sh /etc/systemd/journald.conf.d/dcos.conf /etc/systemd/system/dcos-download.service /etc/systemd/system/dcos-link-env.service /etc/systemd/system/dcos-setup.service /etc/systemd/system/multi-user.target.wants/dcos-setup.service /etc/systemd/system/multi-user.target.wants/dcos.target 
$ sudo rm -fr /run/mesos /var/log/mesos /tmp/dcos
$ sudo systemctl daemon-reload
```

**Tip:** Uninstalling DC/OS with these commands does not delete everything on the host.
