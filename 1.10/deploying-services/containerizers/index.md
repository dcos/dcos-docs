---
post_title: Using Containerizers
menu_order: 40
---

A containerizer is a Mesos agent component responsible for launching containers, within which you can run a service. Running services in containers offers a number of benefits, including the ability to isolate tasks from one another and control task resources programmatically.

DC/OS supports the following Mesos containerizer types:

- The [DC/OS Universal Container Runtime](/docs/1.10/deploying-services/containerizers/ucr/).

- The [Docker containerizer](/docs/1.10/deploying-services/containerizers/docker-containerizer/).

The tables below provide a feature comparison of your containerizer choices on DC/OS.

## DC/OS Features

| Feature																	| Docker			| UCR 			| Comments |
| --------------------------------------- | ----------- | --------- | -------- |
| **Command**                             | Yes         | Yes       |          |
| **Container Images** 										| Yes					| Yes				|					 |
| **Pods**																| No					| Yes				|					 |
| **GPUs**																| No					| Yes				|					 |
| **URIs**																| Yes					| Yes				|					 |
| **Docker Options**											| Yes					| No				|					 |
| **Force Pull**													| Yes					| Yes				|	CLI only |
| **Secrets**															| Yes					| Yes				| Enterprise DC/OS only |
| **Debugging with exec**         				| No					| Yes				|	CLI only |
| **All Security Modes**									| Yes					| Yes				| Enterprise DC/OS only |

## Container Backend

|	Feature																	|	Docker			|	UCR			  |
| --------------------------------------- | ----------- | --------- |
| **Overlayfs**                           | Yes         | Yes       |
| **Aufs**                                | Yes         | Yes       |
| **Bind**                                | N/A         | Yes       |

## Storage

|	Feature																	|	Docker			|	UCR				| Comments  |
| --------------------------------------- | ----------- | --------- | --------- |
| **Local Persistent Volumes**						| Yes					| Yes				|						|
| **Host Volumes**												| Yes					| Yes				| CLI only  |
| **External Volumes**                    | Yes         | Yes       |           |

## Service Endpoints

|	Feature																	|	Docker			|	UCR				|
| --------------------------------------- | ----------- | --------- |
| **Named Ports**													| Yes					| Yes				|
| **Numbered Ports**											| Yes					| Yes				|

## Networking

|	Feature																	|	Docker			|	UCR				|Comments   |
| --------------------------------------- | ----------- | --------- | --------- |
| **Host Networking**       							| Yes					| Yes				|						|
| **Bridge Networking**       						| Yes					| No				|						|
| **CNI**         												| N/A					| Yes				|						|
| **CNM**                    							| Yes					| N/A				| Docker 1.11+ |
| **L4lB**        												| Yes					| Yes				|	Requires defined service endpoints. TCP health checks do not work with L4LB |

## Private Registry

|	Feature													|	Docker			|	UCR				|
| ------------------------------- | ----------- | --------- |
| **Token-based Container Auth**	| Yes					| No				|
| **Token-based Cluster Auth**		| Yes					| Yes				|
| **Basic Container Auth**        | Yes         | No        |
| **Basic Cluster Auth**          | Yes         | Yes       |

## Health Checks

|	Feature																	|	Docker			|	UCR				|Comments   |
| --------------------------------------- | ----------- | --------- | --------- |
| **TCP**													        | Yes					| Yes				|	CLI only	|
| **HTTP/HTTPS**                          | Yes         | Yes       | CLI only  |
| **Command**                             | Yes         | Yes       |           |
| **Local TCP**                           | Yes         | Yes       | CLI only  |
| **Local HTTP/HTTPS**                    | Yes         | Yes       |           |
