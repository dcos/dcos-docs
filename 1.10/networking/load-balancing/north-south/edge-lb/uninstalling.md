---
post_title: Uninstalling Edge-LB
menu_order: 5
post_excerpt: ""
feature_maturity: ""
enterprise: 'yes'
---

*Do not* use the UI or CLI (marathon) to create or destroy services managed by
Edge LB. Operations *must performed exclusively through the Edge LB CLI*.

1.  Delete each [pool](/1.10/networking/edge-lb/architecture#edge-lb-pool) (and each [load balancer](/1.10/networking/edge-lb/architecture#edge-lb-load-balancer) within it) with this command:

    ```bash
    dcos edgelb pool delete <name>
    ```

1.  Uninstall the [Edge-LB API server](/1.10/networking/edge-lb/architecture#edge-lb-api-server)

    ```bash
    dcos package uninstall edgelb
    ```

1.  Remove the Universe repositories with these commands:

    ```bash
    dcos package repo remove edgelb-aws
    dcos package repo remove edgelb-pool-aws
    ```
