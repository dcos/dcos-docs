---
post_title: >
  Autoscaling using requests per second
nav_title: Requests/Second
menu_order: 1
---

You can use the [marathon-lb-autoscale](https://github.com/mesosphere/marathon-lb-autoscale) application to implement request rate-based autoscaling with Marathon. The marathon-lb-autoscale application works with any application that uses TCP traffic and can be routed through HAProxy.

marathon-lb-autoscale collects data from all HAProxy instances to determine the current RPS (requests per second) for your apps. The autoscale controller then attempts to maintain a defined target number of requests per second per service instance. marathon-lb-autoscale makes API calls to Marathon to scale the app.

For more information, see the Marathon-LB advanced features [documentation](/docs/1.9/usage/service-discovery/marathon-lb/advanced/).