---
post_title: Distributed Process Management
nav_title: Distributed Process Management
menu_order: 5
---

This section describes the management of processes in a DC/OS cluster, from the resource allocation to the execution of a process.

At a high level, this interaction takes place between the DC/OS components when a user launches a process. Communication occurs between the different layers, such as the user interacting with the scheduler, and within a layer, for example, a master communicating with agents.

![Concept of distributed process management in DC/OS](../img/dcos-architecture-distributed-process-management-concept.png)

Here is an example, using the Marathon service and a user launching a container based on a Docker image:

![Example of distributed process management in DC/OS](../img/dcos-architecture-distributed-process-management-example.png)

The chronological interaction between the above components looks like this. Notice that Executors and Task are folded into one block since in practice this is often the case:

![Sequence diagram for distributed process management in DC/OS](../img/dcos-architecture-distributed-process-management-seq-diagram.png)

In detail, here are the steps:

<table class="table">
<thead>
<tr>
<th>Step</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>1</td>
<td>Client/Scheduler init: the Client needs to know how to connect to the Scheduler in order to launch a process, for example via Mesos-DNS or DC/OS CLI.</td>
</tr>
<tr>
<td>2</td>
<td>Mesos master sends resource offer to Scheduler: the resource offers are based on cluster resources managed through agents and the <a href="https://www.cs.berkeley.edu/~alig/papers/drf.pdf">DRF</a> algorithm in Mesos master.</td>
</tr>
<tr>
<td>3</td>
<td>Scheduler declines resource offers because no process requests from Clients are pending. As long as no clients have initiated a process, the scheduler will reject offers from the master.</td>
</tr>
<tr>
<td>4</td>
<td>Client initiates process launch. For example, this could be a user creating a Marathon app via the DC/OS <a href="/docs/1.9/usage/webinterface">Services</a> tab or via the HTTP endpoint <code>/v2/app</code>.</td>
</tr>
<tr>
<td>5</td>
<td>Mesos master sends the resource offers . For example, <code>cpus(*):1; mem(*):128; ports(*):[21452-21452]</code></td>
</tr>
<tr>
<td>6</td>
<td>If resource offer matches the requirements the Scheduler has for the process, it accepts the offer and sends a <code>launchTask</code> request to Mesos master.</td>
</tr>
<tr>
<td>7</td>
<td>Mesos master directs Mesos agents to launch tasks.</td>
</tr>
<tr>
<td>8</td>
<td>Mesos agent launches tasks via Executor.</td>
</tr>
<tr>
<td>9</td>
<td>Executor reports task status to Mesos agent.</td>
</tr>
<tr>
<td>10</td>
<td>Mesos agent reports task status to Mesos master.</td>
</tr>
<tr>
<td>11</td>
<td>Mesos master reports task status to scheduler.</td>
</tr>
<tr>
<td>12</td>
<td>Scheduler reports process status to client.</td>
</tr>
</tbody>
</table>

[auth]: /docs/1.9/administration/id-and-access-mgt/
[components]: /docs/1.9/overview/architecture/components/
