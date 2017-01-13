---
post_title: Advanced Features
menu_order: 300
---
## HAProxy configuration

Marathon-LB works by automatically generating configuration for HAProxy and then reloading HAProxy as needed. Marathon-LB generates the HAProxy configuration based on application data available from the Marathon REST API. It can also subscribe to the [Marathon Event Bus][10] for real-time updates. When an application starts, stops, relocates or has any change in health status, Marathon-LB will automatically regenerate the HAProxy configuration and reload HAProxy.

## Templates

Marathon-LB has a templating feature for specifying custom HAProxy configuration parameters. Templates can be set either globally (for all apps), or on a per-app basis using labels. Let’s demonstrate an example of how to specify our own global template. Here’s the template we’ll use:

### Global Template

To specify a global template:

1.  On your local machine, create a file called `HAPROXY_HEAD` in a directory called `templates` with the contents below:

        global daemon log /dev/log local0 log /dev/log local1 notice maxconn 4096 tune.ssl.default-dh-param 2048 defaults log global retries 3 maxconn 3000 timeout connect 5s timeout client 30s timeout server 30s option redispatch listen stats bind 0.0.0.0:9090 balance mode http stats enable monitor-uri /\_haproxy\_health_check

    In the code above, the following items have changed from the default: `maxconn`, `timeout client`, and `timeout server`.

2.  Tar or zip the file. [Here’s a handy script you can use to do this][1].

    Take the file you created (`templates.tgz` if you use the script), and make it available from an HTTP server. If you’d like to use the sample one, use this URI: <https://downloads.mesosphere.com/marathon/marathon-lb/templates.tgz>

3.  Augment the Marathon-LB config by saving the following JSON in a file called `options.json`:

        { "marathon-lb":{ "template-url":"https://downloads.mesosphere.com/marathon/marathon-lb/templates.tgz" } }

4.  Launch the new Marathon-LB:

        $ dcos package install --options=options.json marathon-lb

    Your customized Marathon-LB HAProxy instance will now be running with the new template. [A full list of the templates available can be found here][2].

### Per-app Templates

To create a template for an individual app, modify the application definition. In the example below, the default template for the external NGINX application definition (`nginx-external.json`) has been modified to *disable* HTTP keep-alive. While this is an artificial example, there may be cases where you need to override certain defaults per-application.

    {
      "id": "nginx-external",
      "container": {
        "type": "DOCKER",
        "docker": {
          "image": "nginx:1.7.7",
          "network": "BRIDGE",
          "portMappings": [
            { "hostPort": 0, "containerPort": 80, "servicePort": 10000 }
          ],
          "forcePullImage":true
        }
      },
      "instances": 1,
      "cpus": 0.1,
      "mem": 65,
      "healthChecks": [{
          "protocol": "HTTP",
          "path": "/",
          "portIndex": 0,
          "timeoutSeconds": 10,
          "gracePeriodSeconds": 10,
          "intervalSeconds": 2,
          "maxConsecutiveFailures": 10
      }],
      "labels":{
        "HAPROXY_GROUP":"external",
        "HAPROXY_0_BACKEND_HTTP_OPTIONS":"  option forwardfor\n  no option http-keep-alive\n      http-request set-header X-Forwarded-Port %[dst_port]\n  http-request add-header X-Forwarded-Proto https if { ssl_fc }\n"
      }
    }

Other options you may want to specify include enabling the [sticky option][3], [redirecting to HTTPS][4], or [specifying a vhost][5].

    "labels":{
      "HAPROXY_0_STICKY":true,
      "HAPROXY_0_REDIRECT_TO_HTTPS":true,
      "HAPROXY_0_VHOST":"nginx.mesosphere.com"
    }


## SSL Support

Marathon-LB supports SSL, and you may specify multiple SSL certificates per frontend. Additional SSL certificates can be included by passing a list of paths with the extra `--ssl-certs` command line flag. You can inject your own SSL certificates into the Marathon-LB config by specifying the `HAPROXY_SSL_CERT` environment variable in your application definition.

If you do not specify an SSL certificate, Marathon-LB will generate a self-signed certificate at startup. If you are using multiple SSL certificates, you can select the SSL certificate per app service port by specifying the `HAPROXY_{n}_SSL_CERT` parameter, which corresponds to the file path for the SSL certificates specified. For example, you might have:

    "labels":{
      "HAPROXY_0_VHOST":"nginx.mesosphere.com",
      "HAPROXY_0_SSL_CERT":"/etc/ssl/certs/nginx.mesosphere.com"
    }

The SSL certificates must be pre-loaded into the container for Marathon-LB to load them. You can do this by building your own image of Marathon-LB, rather than using the Mesosphere-provided image.

## Using HAProxy metrics

HAProxy’s statistics report can be used to monitor health, performance, and even make scheduling decisions. HAProxy’s data consists of counters and 1-second rates for various metrics.

To illustrate how to use the metrics, we will use them to create an [implementation of Marathon app autoscaling][6].

For a given app, we can measure its performance in terms of requests per second for a given set of resources. If the app is stateless and scales horizontally, we can then scale the number of app instances proportionally to the number of requests per second averaged over N intervals. The autoscale script polls the HAProxy stats endpoint and automatically scales app instances based on the incoming requests.

![image04](../img/image04.png)

The script takes the current RPS (requests per second) and divides that number by the target RPS per app instance. The result of this fraction is the number of app instances required (or rather, the ceiling of that fraction is the instances required).

![image00](../img/image00.png)

To demonstrate autoscaling, we’re going to use 3 separate Marathon apps:

*   **marathon-lb-autoscale** - the script that monitors HAProxy and scales our app via the Marathon REST API.
*   **nginx** - our demo app
*   **siege** - a tool for generating HTTP requests

1.  Begin by running marathon-lb-autoscale. The JSON app definition [can be found here][7]. Save the file and launch it on Marathon:

        $ dcos marathon app add https://gist.githubusercontent.com/brndnmtthws/2ca7e10b985b2ce9f8ee/raw/66cbcbe171afc95f8ef49b70034f2842bfdb0aca/marathon-lb-autoscale.json

    The JSON app definition passes 2 important arguments to the tool: `--target-rps` tells marathon-lb-autoscale identifies the target RPS and `--apps` is a comma-separated list of the Marathon apps and service ports to monitor, concatenated with `_`. Each app could expose multiple service ports to the load balancer if configured to do so, and marathon-lb-autoscale will scale the app to meet the greatest common denominator for the number of required instances.

        "args":[
          "--marathon", "http://leader.mesos:8080",
          "--haproxy", "http://marathon-lb.marathon.mesos:9090",
          "--target-rps", "100",
          "--apps", "nginx_10000"
        ],

    **Note: If you’re not already running an external Marathon-LB instance, launch it with `dcos package install Marathon-LB`.**

2.  Launch your NGINX test instance. The JSON app definition [can be found here][8]. Save the file, and launch with:

        $ dcos marathon app add https://gist.githubusercontent.com/brndnmtthws/84d0ab8ac057aaacba05/raw/d028fa9477d30b723b140065748e43f8fd974a84/nginx.json

3.  Launch siege, a tool for generating HTTP request traffic. The JSON app definition [can be found here][9]. Save the file, and launch with:

        $ dcos marathon app add https://gist.githubusercontent.com/brndnmtthws/fe3fb0c13c19a96c362e/raw/32280a39e1a8a6fe2286d746b0c07329fedcb722/siege.json

    Now, if you check the HAProxy status page, you should see requests hitting the NGINX instance:

    ![image02](../img/image02-800x508.png)

    Under the “Session rate” section, you can see there are currently about 54 requests per second on the NGINX fronted.

4.  Scale the siege app so that we generate a large number of HTTP requests:

        $ dcos marathon app update /siege instances=15

    After a few minutes you will see that the NGINX app has been automatically scaled up to serve the increased traffic.

5.  Experiment with the parameters for marathon-lb-autoscale (which are [documented here][14]). Try changing the interval, number of samples, and other values until you achieve the desired effect. The default values are fairly conservative, which may or may not meet your expectations. It’s suggested that you include a 50 percent safety factor in the target RPS. For example, if you measure your application as being able to meet SLAs at 1500 RPS with 1 CPU and 1GiB of memory, you may want to set the target RPS to 1000.

 [1]: https://gist.github.com/brndnmtthws/c5c613d9e90d2df771f9
 [2]: https://github.com/mesosphere/marathon-lb#templates
 [3]: https://cbonte.github.io/haproxy-dconv/configuration-1.5.html#5.2-cookie
 [4]: https://cbonte.github.io/haproxy-dconv/configuration-1.5.html#4.2-redirect%20scheme
 [5]: https://cbonte.github.io/haproxy-dconv/configuration-1.5.html#7.2
 [6]: https://github.com/mesosphere/marathon-lb-autoscale
 [7]: https://gist.github.com/brndnmtthws/2ca7e10b985b2ce9f8ee
 [8]: https://gist.github.com/brndnmtthws/84d0ab8ac057aaacba05
 [9]: https://gist.github.com/brndnmtthws/fe3fb0c13c19a96c362e
 [10]: https://mesosphere.github.io/marathon/docs/event-bus.html
