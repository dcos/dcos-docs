---
post_title: Edge-LB Quickstart
menu_order: 1
post_excerpt: ""
feature_maturity: ""
enterprise: 'yes'
---

In this quickstart you will create an [Edge-LB pool](/1.10/networking/edge-lb/architecture#edge-lb-pool), a sample service to load balance, and then access this service through [Edge-LB](/1.10/networking/edge-lb/architecture#edge-lb).

**Prerequsites:**

- Edge-LB [installed and running](/1.10/networking/edge-lb/installing/).

# Quickstart

1.  Create a [pool](/1.10/networking/edge-lb/architecture#edge-lb-pool) configuration. There are more [examples here](/1.10/networking/edge-lb/examples), and more detailed [configuration documented here](/1.10/networking/edge-lb/configuration), but for this quickstart, you can use this configuration, named `sample-minimal.yaml`:

    ```yaml
    ---
    pools:
      - name: sample-minimal
        count: 1
        haproxy:
          frontends:
            - bindPort: 80
              protocol: HTTP
              linkBackend:
                defaultBackend: host-httpd
          backends:
            - name: host-httpd
              protocol: HTTP
              servers:
                - framework:
                    value: marathon
                  task:
                    value: host-httpd
                  port:
                    name: web
    ```
1.  Upload the configuration to [Edge-LB](/1.10/networking/edge-lb/architecture#edge-lb). This will create a [pool](/1.10/networking/edge-lb/architecture#edge-lb-pool) with 1 [load balancer](/1.10/networking/edge-lb/architecture#edge-lb-load-balancer) instance that will run on the public agent nodes.

    ```bash
    dcos edgelb config sample-minimal.yaml
    ```

1.  Create the service to load balance. We will call it `host-httpd.json`

    ```json
    {
        "id": "/host-httpd",
        "cmd": "/start $PORT0",
        "instances": 1,
        "cpus": 0.1,
        "mem": 32,
        "container": {
            "type": "DOCKER",
            "docker": {
                "image": "nlsun/httpd"
            }
        },
        "portDefinitions": [
            {
                "name": "web",
                "protocol": "tcp",
                "port": 0
            }
        ],
        "healthChecks": [
            {
                "portIndex": 0,
                "path": "/",
                "protocol": "HTTP"
            }
        ]
    }
    ```

1.  Deploy the sample service.

    ```bash
    dcos marathon app add host-httpd.json
    ```

1.  Once the service has deployed, you can access the `host-httpd` service at `http://<public-ip>/`

    You can find the private IP(s) (that DC/OS was configured with) of the node(s) that the [Edge-LB load balancers](/1.10/networking/edge-lb/architecture#edge-lb-load-balancer) are running on with the following command:
    ```
    dcos edgelb pool status sample-minimal --ip-only
    ```

    You can then use this information to determine the public IP that you would like to use to access the [load balancer](/1.10/networking/edge-lb/architecture#edge-lb-load-balancer).

# Other commands

1.  Get agent information about running [load balancers](/1.10/networking/edge-lb/architecture#edge-lb-load-balancer):

    ```bash
    dcos edgelb pool lb sample-minimal edgelb-pool-0
    ```

    Your output should resemble this:

    ```bash
    ...
    {
      "containerStatus": {
        ...
        "networkInfos": [
          {
            ...
            "ipAddresses": [
              {
                ...
                "ipAddress": "10.0.6.138"
              }
            ]
          }
        ]
      },
      "executorId": {
        "value": "edgelb-pool__fe58bc1d-ea3b-4d80-b703-828144d02374"
      },
      "slaveId": {
        "value": "a4b62ed1-88cf-4e3d-bd8a-19cc8fc10ac0-S2"
      },
      "state": "TASK_RUNNING",
      "taskId": {
        "value": "edgelb-pool-0-server__fbae1265-f51e-48c9-8162-c09fe19b657d"
      },
      "taskName": "edgelb-pool-0-server"
    }
    ```

# Next steps

- For more Edge-LB configuration examples, see the [examples](/1.10/networking/edge-lb/examples).
- For more information about configuring Edge-LB, see the [edgelb configuration](/1.10/networking/edge-lb/configuration).

- Consult the [dcos edgelb command reference](/1.10/cli/command-reference/dcos-edgelb/).
