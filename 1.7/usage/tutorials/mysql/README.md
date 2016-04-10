---
post_title: Running MySQL on DC/OS
post_excerpt: ""
layout: page
published: true
menu_order: 1
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---

[MySQL](https://www.mysql.com) is a widely used, open-source relational database management system.

**Time Estimate**:

It will take around 10 minutes to complete this tutorial.

**Target Audience**:

This document is for developers who would like to test theirs software which requires MySQL in DCOS environment.

# Prerequisites

- [Install](../install/README.md)
- [Docker](https://docker.com)
- Cluster Size - [Check Cluster Size](../getting-started/cluster-size)

# Install MySQL from official Docker image
Create file named mysql.marathon.json with the following Marathon application descriptor:
<pre>
{
  "id": "/mysql",
  "cpus": 1,
  "mem": 1024,
  "disk": 0,
  "instances": 1,
  "container": {
    "type": "DOCKER",
    "volumes": [
      {
        "containerPath": "/var/lib/mysql",
        "hostPath": "mysqldata",
        "mode": "RW"
      },
      {
        "containerPath": "mysqldata",
        "mode": "RW",
        "persistent": {
          "size": 1000
        }
      }
    ],
    "docker": {
      "image": "mysql:5.6",
      "network": "BRIDGE",
      "portMappings": [
        {
          "containerPort": 3306,
          "hostPort": 0,
          "protocol": "tcp",
          "labels": {
            "VIP_0": "3.3.0.6:3306"
          }
        }
      ],
      "privileged": false,
      "parameters": [],
      "forcePullImage": false
    }
  },
  "env": {
    "MYSQL_ROOT_PASSWORD": "MESOSPHERE_DC/OS_ROCKS",
    "MYSQL_USER": "user",
    "MYSQL_PASSWORD": "DC/OS_ROCKS",
    "MYSQL_DATABASE": "mysqltutorial"
  },
  "healthChecks": [
    {
      "protocol": "TCP",
      "portIndex": 0,
      "gracePeriodSeconds": 300,
      "intervalSeconds": 60,
      "timeoutSeconds": 20,
      "maxConsecutiveFailures": 3,
      "ignoreHttp1xx": false
    }
  ],
  "upgradeStrategy": {
    "minimumHealthCapacity": 0,
    "maximumOverCapacity": 0
  }
}
</pre>
Run the following dcos command:
<pre>
dcos marathon app add mysql.marathon.json 
</pre>
This command will install MySQL server on your DCOS cluster and make it available on VIP 3.3.0.6 and standard MySQL port 3306. 

# Cleanup

To remove MySQL launch the following command:
<pre>
dcos marathon app remove mysql
</pre>