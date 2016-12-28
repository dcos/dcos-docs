---
post_title: Labeling Tasks
menu_order: 12
---

This tutorial illustrates how labels can be defined using the DC/OS web interface and the Marathon HTTP API, and how information pertaining to applications that are running can be queried based on label value criteria.

When you deploy applications or containers in a DC/OS cluster, you can associate a tag or label with your deployed components in order to track and report usage of the cluster by those components. For example, you may want to assign a cost center identifier or a customer number to a Mesos application and produce a summary report at the end of the month with usage metrics such as the amount of CPU and memory allocated to the applications by cost center or customer.

# Assigning Labels to Applications and Tasks

You can attach labels to tasks either via the **Services** tab of the DC/OS web interface or from the DC/OS CLI. You can specify more than one label, but each label can have only one value.

## Assign a Label from the DC/OS Web Interface

From the DC/OS web interface, click the **Services** tab. You can add labels when you deploy a new service or edit an existing one from the **Labels** tab.

## Assign a label from the DC/OS CLI

You can also specify label values in the `labels` parameter of your application definition. 

    $ vi myapp.json
    
    {
        "id": "myapp",
        "cpus": 0.1,
        "mem": 16.0,
        "ports": [
            0
        ],
        "cmd": "/opt/mesosphere/bin/python3 -m http.server $PORT0",
        "instances": 2,
        "labels": {
            "COST_CENTER": "0001"
        }
    }

Then, deploy from the DC/OS CLI:

```bash
$ dcos marathon app add <myapp>.json
```

# Displaying Label Information


Once your applications is deployed and started, you can filter by label from the **Services** tab of the DC/OS UI.

You can also use the Marathon HTTP API from the DC/OS CLI to query the running applications based on the label value criteria.
 
The code snippet below shows an HTTP request issued to the Marathon HTTP API. The curl program is used in this example to submit the HTTP GET request, but you can use any program that is able to send HTTP GET/PUT/DELETE requests. You can see the HTTP end-point is `https://52.88.210.228/marathon/v2/apps` and the parameters sent along with the HTTP request include the label criteria `?label=COST_CENTER==0001`:

    $ curl --insecure \
    > https://52.88.210.228/marathon/v2/apps?label=COST_CENTER==0001 \
    > | python -m json.tool | more

You can also specify multiple label criteria like so: `?label=COST_CENTER==0001,COST_CENTER==0002`

In the example above, the response you receive will include only the applications that have a label `COST_CENTER` defined with a value of `0001`. The resource metrics are also included, such as the number of CPU shares and the amount of memory allocated. At the bottom of the response, you can see the date/time this application was deployed, which can be used to compute the uptime for billing or charge-back purposes.
