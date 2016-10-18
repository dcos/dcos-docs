---
post_title: Pods
menu_order: 85
---

# Overview
Pods enable you to share storage, networking, and other resources among a group of services on a single agent and address them as one group rather than as separate services, similar to a virtual machine. Pods allow quick, convenient coordination between services that need to work together, for instance a database and web server that make up a content management system. Scaling your pod is also straightforward.

**Note:** Pods functionality is considered experimental in DC/OS version 1.9.
		
# Features
* Co-located containers.
* Pod-level resource isolation.
* Sandbox and ephemeral volumes that are shared among pod containers.
* Configurable sandbox mount point for each container.
* Pod-level health checks.
