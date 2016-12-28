---
post_title: DigitalOcean DC/OS Installation Guide
nav_title: DigitalOcean
menu_order: 2
---

You can create a DC/OS cluster on DigitalOcean using Terraform.

The included Terraform templates are configured to run Mesosphere DC/OS on DigitalOcean. Depending on the DC/OS services that you install, or the amount of computing power your workload needs, you might have to modify the templates to suit your needs. You can modify the Terraform templates, but Mesosphere cannot assist in troubleshooting. If you require support with droplet creation or other related issues, please email support@digitalocean.com, visit the unofficial DigitalOcean IRC channel (#digitalocean on freenode) or consider the Enterprise DC/OS.

## Security

- Keep in mind that all nodes are Internet-facing by default after deploying via Terraform and are not secured out-of-the-box. Additional configuration will be required to put master and agent nodes into a security group.

## Environment

- 1, 3 or 5 Mesos master nodes in the admin zone

- 4 Mesos private agent nodes

- 1 Mesos public agent node

- DigitalOcean 4GB (or more) Droplets

# Create a DC/OS cluster

## Prerequisites:

- [DigitalOcean API Key](https://www.digitalocean.com/help/api/)

- [Terraform by Hashicorp](https://www.terraform.io/intro/getting-started/install.html)

## Installing DC/OS

1.  Download and install Terraform using the instructions on the link provided above

2.  [Download the DC/OS Terraform manifests from GitHub](https://github.com/jmarhee/digitalocean-dcos-terraform) into a local  directory.

    ```bash
    $ git clone https://github.com/jmarhee/digitalocean-dcos-terraform
    ```

3.  From that directory, generate an ssh keypair:

    ```bash
    $ ssh-keygen -t rsa -f ./do-key
    ```

4.  Get yourself a token to use against the API. You can [follow the documentation](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2).

4.  Add the key to DigitalOcean:

    ```bash
    $ curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d '{"name":"dcos-key","public_key":"<public-key>"}' "https://api.digitalocean.com/v2/account/keys"
    ```

4. Get the key ID:

    ```bash
    $ curl -X GET -H 'Content-Type: application/json' -H 'Authorization: Bearer $TOKEN' "https://api.digitalocean.com/v2/account/keys"
    ```

4.  Copy `sample.terraform.tfvars` to a new file named `terraform.tfvars`, and edit the new file, filling in the values as desired. The following are blank and if not filled in, you will be prompted by terraform when necessary:

    - digitalocean_token - Your DigitalOcean API key

    - ssh_key_fingerprint - The key ID from above

    - dcos_installer_url - Where to get DC/OS
      https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh

    The following have default values and may be changed depending on your requirements:

    - region - DigitalOcean facility: [NYC1|NYC2|NYC3|SGP1|LON1|AMS2|AMS3|SFO1|TOR1|FRA1]
      Choose the DigitalOcean datacenter for your cluster - default NYC2

    - agent_size - Size of DigitalOcean Droplet to use for the DC/OS Agents: [4GB|8GB|16GB|32GB|48GB|64GB]
      Choose the DigitalOcean droplet size to use for the DC/OS Private Agents - default 4GB

    - master_size - Size of DigitalOcean Droplet to use for the DC/OS Master: [4GB|8GB|16GB|32GB|48GB|64GB]
      Choose the DigitalOcean droplet size to use for the DC/OS Master Nodes - default 4GB

    - boot_size - Size of DigitalOcean Droplet to use for the DC/OS Boot Node: [4GB|8GB|16GB|32GB|48GB|64GB]
      Choose the DigitalOcean droplet size to use for the DC/OS Boot Server - default 4GB

    - dcos_cluster_name - the name of your DC/OS cluster - defaults to digitalocean-dcos

    - dcos_agent_count - Number of private agents to deploy - defaults to  4

    - dcos_public_agent_count - Number of public agents to deploy - defaults to 1

    - dcos_init_pubkey - The path to your ssh public key created in step 4 - defaults to ./do-key.pub

    - key_file_path - The path to your ssh private key created in step 4 - defaults to ./do-key

5.  Also from that same directory, run `terraform apply` which will deploy the servers into your project at DigitalOcean, and run the DC/OS installation routine. When it completes, you will see output similar to the following, but with the IP addresses assigned to your servers:

    ![terraform apply output](../../../img/digitalocean_terraform_output.png)

You may need to wait a few minutes from this point for all the DC/OS services to become active and the control panel available on the master node. After 15 or 20 minutes, you'll want to check out the [troubleshooting](../../custom/troubleshooting/) documentation.

# Launch DC/OS
Launch the DC/OS web interface by entering the Mesos master IP address:

1.  Cut/paste the link provided by after running terraform apply, or by running terraform output from the same directory, into your browser to open the DC/OS web interface. The interface runs on the standard HTTP port 80, so you do not need to specify a port number after the hostname.

2.  Install the DC/OS Command-Line Interface (CLI). You can install the CLI to administer your DC/OS cluster. You can access the documentation at any time by clicking the caret icon in the lower left corner.

    ![dcos help link](../../../img/digitalocean_help_link.png)

## Next steps

- Adding and removing nodes:

  - Run `terraform apply -var ‘dcos_agent_count=N’` to change the private agent count to the number specified. (`‘dcos_public_agent_count’` is also available)

  - Increasing node count is fast, safe, and fun!

  - We recommend against reducing the node count in production. Stateful DC/OS apps and services may suffer outages and failures if nodes are not put into maintenance mode, and their tasks rescheduled through their respective schedulers.

