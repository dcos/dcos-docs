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

This document is for developers who would like to test theirs software which requires MySQL in DCOS environment. This is a basic installation of MySQL server which doesn't include data backup and is not highly available, so it's not recommended to use it in production as is.

# Prerequisites
*   [DCOS](/administration/installing/) installed
*   [DCOS CLI](/usage/cli/install/) installed
*	  [Cluster Size](../getting-started/cluster-size): at least one agent node with 1 CPU, 1GB of RAM and 1000MB of disk space available.

# Install MySQL from official Docker image
Create a file named [mysql.marathon.json](mysql.marathon.json) with the following Marathon application descriptor:
<pre>
{
  "id": "/mysql",
  "cpus": 1,
  "mem": 1024,
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

# Test installation

TODO: Add connection with Ruby app by Tobi.

# Cleanup

To remove MySQL launch the following command:
<pre>
dcos marathon app remove mysql
</pre>