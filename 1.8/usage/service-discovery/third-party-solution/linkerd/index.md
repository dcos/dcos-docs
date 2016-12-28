---
post_title: linkerd
menu_order: 0
---

linkerd is a service mesh for DC/OS. It is installed on every agent, and acts as a transparent, load-balancing proxy, providing service discovery and resilient communication between services.

The linkerd Universe package is configured to use Marathon for service discovery. This means that applications and services can refer to each other by their Marathon task name. For example, a connection to `http://myservice` made through linkerd will be load-balanced over instances of the Marathon application `myservice`, without using DNS. You can also configure linkerd to use dedicated service discovery systems such as ZooKeeper, Consul or etcd (as well as DNS itself) and to failover between these systems and Marathon.

![diagram](/docs/1.8/usage/service-discovery/third-party-solution/linkerd/img/diagram.png)

In addition to service discovery and resilient communication, linkerd provides a uniform layer of visibility across all services and a convenient service metrics dashboards.

## Next Steps

- Install linkerd and linkerd-viz by following the [linkerd tutorial][1].
- For a step-by-step example with a sample app, read the blog post: [DC/OS Blog: Service Discovery and Visibility with Ease on DC/OS][2]

 [1]: https://github.com/dcos/examples/tree/master/1.8/linkerd
 [2]: https://dcos.io/blog/2016/service-discovery-and-visibility-with-ease-on-dc-os/index.html
