---
post_title: Marathon API
menu_order: 40
---

The Marathon API allows you to manage long-running containerized services (apps and pods).

The Marathon API is backed by the [Marathon component](/docs/1.9/overview/architecture/components/#marathon), which runs on the master nodes.

One of the Marathon instances is elected as leader, while the rest are hot backups in case of failure. All API requests must go through the Marathon leader. To enforce this, Admin Router proxies requests from any master node to the Marathon leader.

For more information about using Marathon, see [Managing Services](/docs/1.9/deploying-services/).


## Routes

Access to the Marathon API is proxied through the Admin Router on each master node using the following route:

```
/service/marathon/
```


## Resources

<div class="swagger-section">
  <div id="message-bar" class="swagger-ui-wrap message-success" data-sw-translate=""></div>
  <div id="swagger-ui-container" class="swagger-ui-wrap" data-api="/docs/1.9/api/marathon.yaml">

  <div class="info" id="api_info">
    <div class="info_title">Loading docs...</div>
  <div class="info_description markdown"></div>
</div>
