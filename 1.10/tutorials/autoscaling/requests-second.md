---
post_title: >
  Autoscaling using requests per second
nav_title: Requests/Second
menu_order: 1
---

You can use the [marathon-lb-autoscale](https://github.com/mesosphere/marathon-lb-autoscale) application to implement request rate-based autoscaling with Marathon. The marathon-lb-autoscale application works with any application that uses TCP traffic and can be routed through HAProxy.

<table class="table" bgcolor="#FAFAFA"> <tr> <td style="border-left: thin solid; border-top: thin solid; border-bottom: thin solid;border-right: thin solid;"><b>Important:</b> Mesosphere does not support this tutorial, associated scripts, or commands, which are provided without warranty of any kind. The purpose of this tutorial is to demonstrate capabilities, and may not be suited for use in a production environment. Before using a similar solution in your environment, you must adapt, validate, and test.</td> </tr> </table>

marathon-lb-autoscale collects data from all HAProxy instances to determine the current RPS (requests per second) for your apps. The autoscale controller then attempts to maintain a defined target number of requests per second per service instance. marathon-lb-autoscale makes API calls to Marathon to scale the app.

For more information, see the Marathon-LB advanced features [documentation](/docs/1.10/networking/marathon-lb/advanced/).