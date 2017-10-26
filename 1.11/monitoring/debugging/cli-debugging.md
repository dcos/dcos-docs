---
post_title: Debugging from the DC/OS CLI
feature_maturity: preview
menu_order: 10
---

The DC/OS CLI provides commands to debug services that are not deploying or behaving as expected.

To see full logs, append `--log-level=debug` to any DC/OS CLI command. For example, to troubleshoot HDFS package installation, use this command:

```bash
dcos -—log-level="debug" package install hdfs
```
For more information about log levels, consult the [CLI command reference](/docs/1.10/cli/command-reference/) or run `dcos --help`.

# Debug Subcommands for Stuck Deployments

The DC/OS CLI provides a set of debugging subcommands to troubleshoot a stuck service or pod deployment. You can also use debug services and pods from the [DC/OS web interface](/docs/1.10/monitoring/debugging/gui-debugging/).

# Using the debugging commands

## Prerequisites
- A DC/OS cluster.
- The DC/OS CLI installed.
- A service or pod that is stuck in deployment.

## Sample application definitions
If you do not currently have a service or pod that is stuck in deployment, you can use the following two [Marathon application definitions](/docs/1.10/deploying-services/creating-services/) to test the instructions in this section.

- mem-app.json

  This service creates an infinite deployment by requesting more memory than is available.

  ```json
  {
        "id": "mem-app",
        "cmd": "sleep 1000",
        "cpus": 0.1,
        "mem": 12000,
        "instances": 3,
        "constraints": [
                [
                        "hostname",
                        "UNIQUE"
                ]
        ]
  }
  ```

- stuck-sleep.json

  This service requests too many instances.

  ```json
  {
          "id": "stuck-sleep",
          "cmd": "sleep 1000",
          "cpus": 0.1,
          "mem": 3000,
          "instances": 10,
          "constraints": [
                  [
                          "hostname",
                          "UNIQUE"
                  ]
          ]
  }
  ```

## dcos marathon debug list

The `dcos marathon debug list` command shows you all services that are in a waiting state. This enables you to see only the services that are not running.

```bash
dcos marathon debug list

ID            SINCE                     INSTANCES TO LAUNCH  WAITING  PROCESSED OFFERS  UNUSED OFFERS  LAST UNUSED OFFER         LAST USED OFFER           
/mem-app      2017-02-28T19:08:59.547Z  3                    True     13                13             2017-02-28T19:09:35.607Z  ---                       
/stuck-sleep  2017-02-28T19:09:25.56Z   9                    True     8                 7              2017-02-28T19:09:35.608Z  2017-02-28T19:09:25.566Z
```

The output of the command shows:

- How many instances of the service or pod are waiting to launch.
- How many Mesos resource offers have been processed.
- How many Mesos resource offers are unused
- The time when the user created or updated the service or pod.

This output can quickly show you which services or pods are stuck in deployment and how long they have been stuck.

## dcos marathon debug summary

Once you know which services or pods are stuck in deployment, use the `dcos marathon debug summary /<app-id>|/<pod-id>` command to learn more about a particular stuck service or pod.

```bash
dcos marathon debug summary /mem-app

RESOURCE     REQUESTED                 MATCHED  PERCENTAGE  
ROLE         [*]                       1 / 2    50.00%      
CONSTRAINTS  [['hostname', 'UNIQUE']]  1 / 1    100.00%     
CPUS         0.1                       1 / 1    100.00%     
MEM          12000                     0 / 1    0.00%       
DISK         0                         0 / 0    ---         
PORTS        ---                       0 / 0    ---  
```

The output of the command shows the resources, what the service or pod requested, how many offers were matched, and the percentage of offers that were matched. This command can quickly show you which resource requests are not being met.

## dcos marathon debug details

The `dcos marathon debug details /<app-id>|/<pod-id>` command lets you learn exactly how your service or pod definition should be changed.

```bash
dcos marathon debug details /mem-app

HOSTNAME    ROLE  CONSTRAINTS  CPUS  MEM  DISK  PORTS  RECEIVED                  
10.0.0.193   ok        ok       ok    -    ok     ok   2017-02-28T23:25:11.912Z  
10.0.4.126   -         ok       -     -    ok     -    2017-02-28T23:25:11.913Z
```

The output of the command shows:

- Which hosts are running the service or pod.
- The status of the role, constraints, CPUs, memory, disk, and ports the service or pod has requested.
- When the last resource offer was received.

In the example above, you can see that one instance of `/mem-app` has a status of `ok` in all categories except memory. The other instance had fewer successful resource matches, with role, CPUs, memory, and ports having no match.
