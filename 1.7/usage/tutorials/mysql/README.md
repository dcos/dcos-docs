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
Create or download a file named [mysql.marathon.json](mysql.marathon.json) with the following Marathon application descriptor:
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
        "containerPath": "mysqldata",
        "mode": "RW",
        "persistent": {
          "size": 1000
        }
      }
    ],
    "docker": {
      "image": "mysql:5.7.12",
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
      ]
    }
  },
  "args": [
    "--datadir=/mnt/mesos/sandbox/mysqldata/"
  ],
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
Deploy the app via Marathon:
<pre>
$ dcos marathon app add mysql.marathon.json 
</pre>
This command will install MySQL server on your DCOS cluster and make it available on VIP 3.3.0.6 and standard MySQL port 3306. 

# Test installation

SSH to the master:
<pre>
dcos node ssh --master-proxy --leader
</pre>
Install MySQL client (CoreOS):
<pre>
$ /bin/toolbox 
$ dnf install mysql
</pre>
Install MySQL client (CentOS):
<pre>
$ yum install mysql
</pre>
Create table in the mysqltutorial database:
<pre>
$ mysql -uuser -pDC/OS_ROCKS -e "CREATE TABLE messages(message VARCHAR(256));"  -h 3.3.0.6 mysqltutorial 
</pre>
Insert a record to the table:
<pre>
$ mysql -uuser -pDC/OS_ROCKS -e "INSERT INTO messages VALUES('test');" -h 3.3.0.6  mysqltutorial
</pre>
Make sure that the record is inserted:
<pre>
$ mysql -uuser -pDC/OS_ROCKS -e "SELECT * FROM messages;" -h 3.3.0.6 mysqltutorial
+---------+
| message |
+---------+
| test    |
+---------+
</pre>
From your local workstation, suspend the MySQL application:
<pre>
$ dcos marathon app stop /mysql
Created deployment 3d9915f1-b067-439c-bd59-297362c217d8
</pre>
and make sure that the application doesn't have any running tasks:
<pre>
$ dcos marathon app list
ID      MEM   CPUS  TASKS  HEALTH  DEPLOYMENT  CONTAINER  CMD                                           
/mysql  1024   1     0/0    0/0       ---        DOCKER   [u'--datadir=/mnt/mesos/sandbox/mysqldata/']
</pre>
Start MySQL server again:
<pre>
$ dcos marathon app start /mysql
Created deployment 9efc11a0-901e-4bf9-be17-82fed35cfc95
</pre>
From the master node, make sure that the data survived during the application restart:
<pre>
$ mysql -uuser -pDC/OS_ROCKS -e "SELECT * FROM messages;" -h 3.3.0.6 mysqltutorial
+---------+
| message |
+---------+
| test    |
+---------+
</pre>

# Cleanup

To remove MySQL launch, the following command:
<pre>
$ dcos marathon app remove /mysql
</pre>