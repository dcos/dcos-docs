---
post_title: Storage
menu_order: 10
---

DC/OS applications lose their state when they terminate and are relaunched. In some contexts, for instance, if your application uses MySQL, or if you are using a stateful service like Kafka or Cassandra, you'll want your application to preserve its state. [Configure Mesos mount disk resources](/docs/1.9/administration/storage/mount-disk-resources/) to enable users to create tasks that can be restarted without data loss. [Learn how to create stateful applications](/docs/1.9/usage/storage/persistent-volume/).
