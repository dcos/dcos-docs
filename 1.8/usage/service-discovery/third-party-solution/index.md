---
post_title: Third Party Solutions
menu_order: 300
---

In addition to [VIPs][1], [Minuteman][2], [Marathon-LB][3], and [Mesos-DNS][4], the DC/OS Universe provides other third party solutions intended for more specific use cases.

# linkerd

[linkerd][5] is a service mesh that does load balancing, routing, circuit breaking, and retries. linkerd is a good option when you have latency-sensitive HTTP, gRPC or Thrift communication between services, and can direct communication through proxy.

You can use linkerd to route HTTP, Thrift, and gRPC traffic through a service mesh by their logical name by following the instructions in the [linkerd tutorial][6] section. By default, linkerd uses Marathon task names as logical names, but can also use dedicated service discovery systems such as ZooKeeper, Consul or etcd.

 [1]: /docs/1.8/usage/service-discovery/load-balancing-vips/virtual-ip-addresses/
 [2]: /docs/1.8/usage/service-discovery/load-balancing-vips/
 [3]: /docs/1.8/usage/service-discovery/marathon-lb/
 [4]: /docs/1.8/usage/service-discovery/mesos-dns/
 [5]: /docs/1.8/usage/service-discovery/third-party-solution/linkerd/
 [6]: https://github.com/dcos/examples/tree/master/1.8/linkerd
