---
post_title: Using Containerizers
menu_order: 40
---

A containerizer is a Mesos agent component responsible for launching containers, within which you can run a service. Running services in containers offers a number of benefits, including the ability to isolate tasks from one another and control task resources programmatically.

DC/OS supports the Mesos containerizer types:

- The [original Mesos containerizer](/docs/1.10/deploying-services/containerizers/mesos-containerizer/).

- The [DC/OS Universal Container Runtime](/docs/1.10/deploying-services/containerizers/ucr/).

- The [Docker containerizer](/docs/1.10/deploying-services/containerizers/docker-containerizer/).

The tables below provide a feature comparison of your containerizer choices on DC/OS.

## DC/OS Features

| 																				| Docker			| Original Mesos				| UCR 			| Comments |
| --------------------------------------- | ----------- | --------------------- | --------- | -------- |
| **Command**                             | Yes          | Yes                   | Yes      |          |
| **Container Images** 										| Yes					| No										| Yes				|					 |
| **Pods**																| No					| Yes										| Yes				|					 |
| **GPUs**																| No					| Yes										| Yes				|					 |
| **URIs**																| Yes					| Yes										| Yes				|					 |
| **Docker Options**											| Yes					| No										| No				|					 |
| **Force Pull**													| Yes					| No										| Yes				|	CLI only |
| **Secrets**															| Yes					| Yes										| Yes				| Enterprise only |
| **Debugging with exec**         				| No					| Yes										| Yes				|	CLI only |
| **All Security Modes**									| Yes					| Yes										| Yes				| Enterprise only |

## Container Backend

|																					|	Docker			|	Original Mesos				|	UCR			  |
| --------------------------------------- | ----------- | --------------------- | --------- |
| **Overlayfs**                           | Yes         | N/A                   | Yes       |
| **Aufs**                                | Yes         | N/A                   | Yes       |
| **Bind**                                | N/A         | N/A                   | Yes       |

## Storage

|																					|	Docker			|	Original Mesos				|	UCR				| Comments  |
| --------------------------------------- | ----------- | --------------------- | --------- | --------- |
| **Local Persistent Volumes**						| Yes					| Yes										| Yes				|						|
| **Host Volumes**												| Yes					| Yes									  | Yes				| CLI only  |
| **External Volumes**                    | Yes         | Yes                   | Yes       |           |

## Service Endpoints

|																					|	Docker			|	Original Mesos				|	UCR				|
| --------------------------------------- | ----------- | --------------------- | --------- |
| **Named Ports**													| Yes					| Yes										| Yes				|
| **Numbered Ports**											| Yes					| Yes										| Yes				|

## Networking

|																					|	Docker			|	Original Mesos				|	UCR				|Comments   |
| --------------------------------------- | ----------- | --------------------- | --------- | --------- |
| **Host Networking**       							| Yes					| Yes										| Yes				|						|
| **Bridge Networking**       						| Yes					| No										| No				|						|
| **CNI**         												| N/A					| Yes										| Yes				|						|
| **CNM**                    							| Yes					| N/A										| N/A				| Docker 1.11+ |
| **L4lB**        												| Yes					| Yes										| Yes				|	Requires defined service endpoints. TCP health checks do not work with L4LB |

## Private Registry

|																	|	Docker			|	Original Mesos				|	UCR				|
| ------------------------------- | ----------- | --------------------- | --------- |
| **Token-based Container Auth**	| Yes					| N/A										| No				|
| **Token-based Cluster Auth**		| Yes					| N/A										| Yes				|
| **Basic Container Auth**        | Yes         | N/A                   | No        |
| **Basic Cluster Auth**          | Yes         | N/A                   | Yes       |

## Health Checks

|																					|	Docker			|	Original Mesos				|	UCR				|Comments   |
| --------------------------------------- | ----------- | --------------------- | --------- | --------- |
| **TCP**													        | Yes					| Yes										| Yes				|	CLI only	|
| **HTTP/HTTPS**                          | Yes         | Yes                   | Yes       | CLI only  |
| **Command**                             | Yes         | Yes                   | Yes       |           |
| **Local TCP**                           | Yes         | Yes                   | Yes       | CLI only  |
| **Local HTTP/HTTPS**                    | Yes         | Yes                   | Yes       |           |
