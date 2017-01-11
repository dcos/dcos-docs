---
post_title: Removing an Agent
menu_order: 3.2
---

To shut down and safely remove an agent node follow these steps.

1.  [SSH](/docs/1.9/administration/access-node/sshcluster/) to the agent node that you want to remove.
1.  Run this command to explicitly de-register and cleanly shut down tasks:

    ```bash
    $ systemctl kill -s SIGUSR1 dcos-mesos-slave
    ```

If an agent is already shut down, go to the Mesos `/machine/down` [endpoint](http://mesos.apache.org/documentation/latest/maintenance/) and [instruct](http://mesos.apache.org/documentation/latest/endpoints/master/machine/down/) Mesos that it is dead and not just gone because of a network partition.



