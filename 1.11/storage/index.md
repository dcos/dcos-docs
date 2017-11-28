---
post_title: Storage
menu_order: 090
---

DC/OS applications lose their state when they terminate and are relaunched. In some contexts, for instance, if your application uses MySQL, or if you are using a stateful service like Kafka or Cassandra, you'll want your application to preserve its state. 

Configure Mesos [`Mount` disk resources](/docs/1.11/storage/mount-disk-resources/) to enable tasks that can be restarted without data loss. 

Learn how to create stateful applications using [local persistent volumes](/docs/1.11/storage/persistent-volume/) and [external persistent volumes](/docs/1.11/storage/external-storage/).
