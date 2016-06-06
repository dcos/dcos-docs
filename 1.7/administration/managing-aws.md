---
post_title: Managing AWS
menu_order: 9
---
<!-- This source repo for this topic is https://github.com/dcos/dcos-docs -->
## Finding your public addresses

The DC/OS AWS CloudFormation template creates 1 Mesos agent node
in the [public zone][1] by default, which is also fronted by a public ELB.

To find your public ELB hostname and public agent IPs:

1.  Find your
    [Amazon EC2 Management](https://console.aws.amazon.com/ec2/home) page.

2.  Navigate to the **Load Balancers** tab, which you can find on the left
    panel under **Load Balancing**.

3.  Search for your cluster name in the search bar, and select the ELB that
    contains the name "Public". The ELB hostname is visible under the "DNS Name".

    ![Load Balancers](../img/aws-load-balancers.png)

    In this example, the DNS A record is
    `brenden-l-PublicSl-1CE9GBJKVK1NZ-1614104872.us-west-2.elb.amazonaws.com`.

    **Tip**: You should always use the DNS A record, rather than pointing directly
    to an IP, unless you attach an elastic IP. To use your own hostname with
    the ELB, create a CNAME record that points to the ELB A record.

4.  Click on the **Instances** tab to view the list of instances in the LB pool.
    All instances should be listed with a status of "InService".

    ![Load Balancer Backend Instances](../img/aws-load-balancer-instances.png)


5.  To view the public IP, click on one of the instances and look in the lower
    pane for the public hostname and IP.

    ![Public Agent hostname and IP](../img/aws-public-agent.png)

    In this example, the public IP is `54.187.143.120`.

## Scaling an AWS cluster

The DC/OS AWS CloudFormation template is optimized to run DC/OS, but you might want to change the number of agent nodes based on your needs.

**Important:** Scaling down your AWS cluster could result in data loss. It is recommended that you scale down by 1 node at a time, letting the DC/OS service recover. For example, if you are running a DC/OS service and you scale down from 10 to 5 nodes, this could result in losing all the instances of your service.

To change the number of agent nodes with AWS:

1.  From [AWS CloudFormation Management][3] page, select your DC/OS cluster and click **Update Stack**.
2.  Click through to the **Specify Parameters** page, and you can specify new values for the **PublicSlaveInstanceCount** and **SlaveInstanceCount**.
3.  On the **Options** page, accept the defaults and click **Next**. **Tip:** You can choose whether to rollback on failure. By default this option is set to **Yes**.
4.  On the **Review** page, check the acknowledgement box and then click **Create**.

Your new machines will take a few minutes to initialize; you can watch them in the EC2 console. The DC/OS web interface will update as soon as the new nodes register.

## Upgrading a DC/OS cluster in AWS

You can update an existing DC/OS cluster or services to use the latest DC/OS template.

To upgrade a DC/OS cluster:

1.  Create a new DC/OS cluster by using the latest [DC/OS template][2] for AWS.

2.  Migrate your active DC/OS services and apps to the new DC/OS cluster:

    1.  Migrate, Extract, Transform and Load (ETL) the app data to the new cluster.

    2.  Migrate your DC/OS services and apps to the new cluster.

    3.  Change the DNS so that it points to the DC/OS services running in the new cluster.

3.  Shutdown your existing DC/OS cluster.

 [1]: /docs/1.7/overview/security/
 [2]: /docs/latest/administration/installing/cloud/aws/
 [3]: https://console.aws.amazon.com/cloudformation/home
