---
post_title: Storage
menu_order: 100 
---

DC/OS applications lose their state when they terminate and are relaunched. In some contexts, for instance, if your application uses MySQL, or if you are using a stateful service like Kafka or Cassandra, you'll want your application to preserve its state. Use [local persistent volumes](/docs/1.9/usage/storage/persistent-volume/) or [external volumes](/docs/1.9/usage/storage/external-storage/) to enable tasks to be restarted without data loss. [Learn how to configure your cluster to use persistent volumes](/docs/1.9/administration/storage/mount-disk-resources/).