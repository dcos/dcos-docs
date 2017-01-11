---
post_title: Metrics API 
feature_maturity: experimental
menu_order: 1
---

You can use your custom built tools to get any metric, either from running Mesos tasks or the hosts which run your DC/OS cluster. 


# About the Metrics API

The HTTP producer is enabled by default and exposes a JSON-formatted HTTP API on each node in the cluster. These APIs include both metrics datapoints as well as dimensions, or key/value pairs with relevant node and cluster metadata.

# Request and response format

The API supports JSON only. You must include application/json as your Content-Type in the HTTP header, as shown below.

```bash
Accept: application/json
```

# Hostname and base path
  
The metrics endpoints are all *service-specific*. The metrics component is designed to be put behind Admin Router, which provides security for these endpoints. On a DC/OS cluster, the final URL to query will resemble:

```
http://<host>/system/v1/metrics/v0/<endpoint>
```
# API reference

<div class="swagger-section">
  <div id="message-bar" class="swagger-ui-wrap message-success" data-sw-translate=""></div>
  <div id="swagger-ui-container" class="swagger-ui-wrap" data-api="/docs/1.9/api/metrics.yaml">

  <div class="info" id="api_info">
    <div class="info_title">Loading docs...</div>
  <div class="info_description markdown"></div>
</div>