---
post_title: Template Reference
menu_order: 200
---




These advanced template parameters are specified in the individual JSON files. During DC/OS installation these template files are used to generate a customized DC/OS build.

#### [Zen](#zen) template
The [Zen](/docs/1.7/administration/installing/cloud/aws/advanced/template-reference/#zen) templates orchestrate the individual component templates to create a DC/OS cluster.

#### Agent template
The [agent](/docs/1.7/administration/installing/cloud/aws/advanced/template-reference/#private-agent) templates create [public](/docs/1.7/overview/concepts/#public) or [private](/docs/1.7/overview/concepts/#private) agent nodes that are then attached to a DC/OS cluster as a part of an AutoScalingGroup. 

#### Master template
The [master](/docs/1.7/administration/installing/cloud/aws/advanced/template-reference/#master) templates create master nodes, on top of the infrastructure stack already created.

#### Infrastructure template
The [infrastructure](/docs/1.7/administration/installing/cloud/aws/advanced/template-reference/#infrastructure) template defines and creates a DC/OS specific infrastructure that works well with an existing VPC. 


## <a name="zen"></a>Zen

The Zen templates ([zen-1.json](https://s3.amazonaws.com/downloads.mesosphere.io/dcos/stable/cloudformation/zen-1.json), [zen-3.json](https://s3.amazonaws.com/downloads.mesosphere.io/dcos/stable/cloudformation/zen-3.json), [zen-5.json](https://s3.amazonaws.com/downloads.mesosphere.io/dcos/stable/cloudformation/zen-5.json), [zen-7.json](https://s3.amazonaws.com/downloads.mesosphere.io/dcos/stable/cloudformation/zen-7.json)) orchestrate the individual component templates.

<table class="table">
  <tr>
    <th>Parameter Name</th>
    <th>Key Value</th>
  </tr>
  <tr>
    <td>KeyName</td>
    <td>AWS EC2 Key Pair to SSH into instances</td>
  </tr>
  <tr>
    <td>Vpc</td>
    <td>Existing VPC to use. Nodes will be launched using subnets and Internet Gateway under this VPC</td>
  </tr>
  <tr>
    <td>InternetGateway</td>
    <td>Internet Gateway ID, must be attached to the 'Vpc'. Used by all nodes for outgoing Internet access.</td>
  </tr>
  <tr>
    <td>MasterInstanceType</td>
    <td>Region-specific instance type. E.g. m3.xlarge</td>
  </tr>
  <tr>
    <td>PrivateAgentInstanceCount</td>
    <td>Specify the number of private agent nodes or accept the default.</td>
  </tr>
  <tr>
    <td>PrivateAgentInstanceType</td>
    <td>Region-specific instance type. E.g. m3.xlarge</td>
  </tr>
  <tr>
    <td>PrivateSubnet</td>
    <td>Subnet ID for use by all private agent nodes</td>
  </tr>
  <tr>
    <td>PublicAgentInstanceCount</td>
    <td>Specify the number of public agent nodes or accept the default.</td>
  </tr>
  <tr>
    <td>PublicAgentInstanceType</td>
    <td>Region-specific instance type. E.g. m3.xlarge</td>
  </tr>
  <tr>
    <td>PublicSubnet</td>
    <td>Subnet ID for use by all public agent nodes</td>
  </tr>
</table>


## <a name="private-agent"></a>Private agents

The private agent template ([advanced-priv-agent.json](https://s3.amazonaws.com/downloads.mesosphere.io/dcos/stable/cloudformation/advanced-priv-agent.json)) creates agents which are then attached to a DC/OS cluster as a part of an AutoScalingGroup. To configure the template, specify the VPC, subnet, and master DNS address for the DC/OS cluster to join. 

<table class="table">
  <tr>
    <th>Parameter Name</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>InternalMasterLoadBalancerDnsName</td>
    <td>DNS Name of Internal Load Balancer. Has to be valid for agents to join a running cluster</td>
  </tr>
  <tr>
    <td>KeyName</td>
    <td>AWS EC2 Key Pair to SSH into instances</td>
  </tr>
  <tr>
    <td>PrivateAgentInstanceCount</td>
    <td>Specify the number of private agent nodes or accept the default.</td>
  </tr>
  <tr>
    <td>PrivateAgentInstanceType</td>
    <td>Region-specific instance type. E.g. m3.xlarge</td>
  </tr>
  <tr>
    <td>PrivateAgentSecurityGroup</td>
    <td>Permissive Security group used by private Agents</td>
  </tr>
  <tr>
    <td>PrivateSubnet</td>
    <td>Subnet ID for use by all private agent nodes</td>
  </tr>
</table>



## <a name="public-agent"></a>Public agents

The public agent template ([advanced-pub-agent.json](https://s3.amazonaws.com/downloads.mesosphere.io/dcos/stable/cloudformation/advanced-pub-agent.json)) creates agents which are then attached to a DC/OS cluster as a part of an AutoScalingGroup. To configure the template, specify the VPC, subnet, and master DNS address for the DC/OS cluster to join. 

<table class="table">
  <tr>
    <th>Parameter Name</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>InternalMasterLoadBalancerDnsName</td>
    <td>DNS Name of Internal Load Balancer. Has to be valid for agents to join a running cluster</td>
  </tr>
  <tr>
    <td>KeyName</td>
    <td>AWS EC2 Key Pair to SSH into instances</td>
  </tr>
  <tr>
    <td>PublicAgentInstanceCount</td>
    <td>Specify the number of public agent nodes or accept the default.</td>
  </tr>
  <tr>
    <td>PublicAgentInstanceType</td>
    <td>Region-specific instance type. E.g. m3.xlarge</td>
  </tr>
  <tr>
    <td>PublicAgentSecurityGroup</td>
    <td>Permissive Security group used by Public Agents</td>
  </tr>
  <tr>
    <td>PublicSubnet</td>
    <td>Subnet ID for use by all public agent nodes</td>
  </tr>
</table>

## <a name="master"></a>Master

The master templates ([advanced-master-1.json](https://s3.amazonaws.com/downloads.mesosphere.io/dcos/stable/cloudformation/advanced-master-1.json), [advanced-master-3.json](https://s3.amazonaws.com/downloads.mesosphere.io/dcos/stable/cloudformation/advanced-master-3.json), [advanced-master-5.json](https://s3.amazonaws.com/downloads.mesosphere.io/dcos/stable/cloudformation/advanced-master-5.json), [advanced-master-7.json](https://s3.amazonaws.com/downloads.mesosphere.io/dcos/stable/cloudformation/advanced-master-7.json)) create masters, on top of the infrastructure stack already created.

<table class="table">
  <tr>
    <th>Parameter Name</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>AdminSecurityGroup</td>
    <td>Admin URL Security Group. Controls Access to the Admin page</td>
  </tr>
  <tr>
    <td>ExhibitorS3Bucket</td>
    <td>S3 Bucket resource name. Used by Exhibitor for ZooKeeper discovery and coordination. See Exhibitor documentation on 'shared configuration': https://github.com/Netflix/exhibitor/wiki/Shared-Configuration for more information</td>
  </tr>
  <tr>
    <td>KeyName</td>
    <td>AWS EC2 Key Pair to SSH into instances</td>
  </tr>
  <tr>
    <td>LbSecurityGroup</td>
    <td>Loadbalancer Security Group. Rules allow masters and private agent nodes to communicate.</td>
  </tr>
  <tr>
    <td>MasterInstanceType</td>
    <td>Region-specific instance type. E.g. m3.xlarge</td>
  </tr>
  <tr>
    <td>MasterSecurityGroup</td>
    <td>Security group used by master nodes</td>
  </tr>
  <tr>
    <td>PrivateAgentSecurityGroup</td>
    <td>Security group used by Private Agents, typically with limited access to the outside</td>
  </tr>
  <tr>
    <td>PrivateSubnet</td>
    <td>Subnet ID for use by all private agent nodes</td>
  </tr>
  <tr>
    <td>PublicAgentSecurityGroup</td>
    <td>Permissive Security group used by Public Agents</td>
  </tr>
  <tr>
    <td>PublicSubnet</td>
    <td>Subnet ID for use by all public agent nodes</td>
  </tr>
</table>

## <a name="infrastructure"></a>Infrastructure

The infrastructure template ([infra.json](https://s3.amazonaws.com/downloads.mesosphere.io/dcos/stable/cloudformation/infra.json)) defines, and creates, a DC/OS specific infrastructure that works well with a VPC already created. This is the lowest building block of a DC/OS cluster and the components created in this stack are consumed by the dependent templates (master and agents).

<table class="table">
  <tr>
    <th>Parameter Name</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>AdminLocation</td>
    <td>Optional: Specify the IP range to whitelist for access to the admin zone. Must be a valid CIDR.</td>
  </tr>
  <tr>
    <td>InternetGateway</td>
    <td>Internet Gateway ID, must be attached to the 'Vpc'. Used by all nodes for outgoing Internet access.</td>
  </tr>
  <tr>
    <td>KeyName</td>
    <td>AWS EC2 Key Pair to SSH into instances</td>
  </tr>
  <tr>
    <td>PrivateSubnet</td>
    <td>Subnet ID for use by all private agent nodes</td>
  </tr>
  <tr>
    <td>PublicSubnet</td>
    <td>Subnet ID for use by all public agent nodes</td>
  </tr>
  <tr>
    <td>Vpc</td>
    <td>Existing VPC to use. Nodes will be launched using subnets and Internet Gateway under this VPC</td>
  </tr>
</table>