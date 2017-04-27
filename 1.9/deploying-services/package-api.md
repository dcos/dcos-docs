---
post_title: DC/OS Package Management API
nav_title: Package API
menu_order: 10
---

The Package Management API allows you to install DC/OS services from DC/OS packages stored in a DC/OS package registry, such as the [Mesosphere Universe](/docs/1.9/overview/concepts/#mesosphere-universe).

The [DC/OS Package Manager (Cosmos) component](/docs/1.9/overview/architecture/components/#dcos-package-manager) runs on all master nodes.

For information about managing package repositories, see [Managing Package Repositories](/docs/1.9/administering-clusters/repo/).

For information about managing services, see [Managing Services](/docs/1.9/deploying-services/).


## Routes

Admin Router proxies three routes to the DC/OS Package Manager (Cosmos):

| Route | Resource |
|-------|----------|
| `/cosmos/service/` | `/service/` |
| `/package/` | `/package/` |
| `/capabilities` | `/capabilities` |


## Resources

The following resources are available under both of the above routes:

<div class="swagger-section">
  <div id="message-bar" class="swagger-ui-wrap message-success" data-sw-translate=""></div>
  <div id="swagger-ui-container" class="swagger-ui-wrap" data-api="/docs/1.9/api/package-manager.yaml">

  <div class="info" id="api_info">
    <div class="info_title">Loading docs...</div>
  <div class="info_description markdown"></div>
</div>
