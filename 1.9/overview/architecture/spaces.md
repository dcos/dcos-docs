---
post_title: Spaces
nav_title: Spaces
menu_order: 3
---

In DC/OS, services can live in the user space or the system space. These are analogous to the Linux user and kernel spaces.

These spaces are primarily distinguished by owner and service manager. The system space is owned and managed by the system administrator, while the user space is shared by the other users of the system.

In future releases, these spaces may be delineated by hierarchical security spaces, rather than simply service manager, which would allow system services to be deployed on the built-in DC/OS schedulers and users to each have their own distinct space.

## System space

The system space includes all [system services](/docs/1.9/overview/concepts/#system-service). These system services include the [system components](/docs/1.9/overview/architecture/components/). These components are all [systemd services](/docs/1.9/overview/concepts/#systemd-service).

System space services and jobs are scheduled manually by the DC/OS installer and managed by systemd on the nodes themselves.

In future releases, some [Marathon services](/docs/1.9/overview/concepts/#marathon-service) may be deployed into the system space as well, using hierarchical security spaces.

## User space

The user space includes all [DC/OS services](/docs/1.9/overview/concepts/#user-service) and [DC/OS jobs](/docs/1.9/overview/concepts/#dcos-job).

All user space services and jobs are scheduled on top of DC/OS using one of the built in schedulers: Marathon (services) or Metronome (jobs).

DC/OS services that are also [schedulers](/docs/1.9/overview/concepts/#dcos-scheduler) (schedule tasks via Mesos directly) are called [scheduler services](/docs/1.9/overview/concepts/#dcos-scheduler-service).
