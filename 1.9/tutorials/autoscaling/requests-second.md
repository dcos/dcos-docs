---
post_title: >
  Autoscaling using requests per second
nav_title: Requests/Second
menu_order: 1
---

You can use the [marathon-lb-autoscale](https://github.com/mesosphere/marathon-lb-autoscale) application to implement request rate-based autoscaling with Marathon. The marathon-lb-autoscale application works with any application that uses TCP traffic and can be routed through HAProxy.

<table class="table" bgcolor="#E6E6E6"> <tr> <td style="border-left: thin solid; border-top: thin solid; border-bottom: thin solid;border-right: thin solid;"><b>Disclaimer:</b> Mesosphere does not support this tutorial, associated scripts, or commands, which are provided solely on a "as is" basis and without warranty. Do not use in a production environment. This is a referential example meant to illustrate how this solution could be done with DC/OS. Before using a similar solution in your environment, you would need to adapt, validate, and test.</td> </tr> </table>

marathon-lb-autoscale collects data from all HAProxy instances to determine the current RPS (requests per second) for your apps. The autoscale controller then attempts to maintain a defined target number of requests per second per service instance. marathon-lb-autoscale makes API calls to Marathon to scale the app.

For more information, see the Marathon-LB advanced features [documentation](/docs/1.9/networking/marathon-lb/advanced/).