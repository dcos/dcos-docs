---
post_title: DC/OS on Google Compute Engine
nav_title: GCE
menu_order: 3
---

You can configure a DC/OS cluster on Google Compute Engine (GCE) by using these scripts.

- [Configure bootstrap node](#bootstrap)
- [Install the DC/OS GCE scripts](#install)
- [Configure parameters](#configure)

## Prerequisites
- Google Cloud Console account

## <a name="bootstrap"></a>Bootstrap node configuration
A bootstrap node is required to run the scripts and to bootstrap the DC/OS cluster.

### Create a GCE project and instance

1.  Create a project by using the Google Cloud Console. In these examples we created a project called `trek-treckr`.

1.  Create the bootstrap node using the Google Cloud Console. In these examples we used a [n1-standard-1](https://cloud.google.com/compute/docs/machine-types) instance running CentOS 7 with a 10 GB persistent disk in `zone europe-west1-c`. The bootstrap node must have "Allow full access to all Cloud APIs" in the Identity and API access section. Also enable Block project-wide SSH keys in the SSH Keys section. Create the instance.

1.  After creating the bootstrap instance, start the instance and run the following from the shell. These commands install prerequisite software on your bootstrap node.

    ```bash
    $ sudo yum update google-cloud-sdk &&
    sudo yum update &&
    sudo yum install epel-release &&
    sudo yum install python-pip &&
    sudo pip install -U pip &&
    sudo pip install 'apache-libcloud==1.2.1' &&
    sudo pip install 'docker-py==1.9.0' &&
    sudo yum install git ansible
    ```

### Setup RSA public/private keypairs

You must create the RSA public/private keypairs to allow passwordless logins via SSH to the nodes of the DC/OS cluster. This is required by Ansible to create the cluster nodes and install DC/OS on the nodes.

**Important:** Replace `ajazam` with your username in these examples.

1.  Run this command to generate the keys:

    ```bash
    $ ssh-keygen -t rsa -f ~/.ssh/id_rsa -C ajazam
    ```

    Do not enter a password when prompted.

1.  Make a backup copy of `id_rsa.pub`.

1.  Open RSA pub key:

    ```bash
    $ vi ~/.ssh/id_rsa.pub
    ```

    You should see something like this:

    ```bash
    $ ssh-rsa abcdefghijklmaasnsknsdjfsdfjs;dfj;sdflkjsd ajazam
    ```

1.  Prefix your username, followed by a colon, to the above line. Also

    ```bash
    $ ajazam:ssh-rsa abcdefghijklmaasnsknsdjfsdfjs;dfj;sdflkjsd ajazam
    ```

1.  Save contents of `id_rsa.pub`.

1.  Add the rsa public key to your project

    ```bash
    $ chmod 400 ~/.ssh/id_rsa
    $ gcloud compute project-info add-metadata --metadata-from-file sshKeys=~/.ssh/id_rsa.pub
    ```

### Configure Docker

1.  You must disable SELinux for Docker to work. Make the following change to `/etc/selinux/config`:

    ```bash
    SELINUX=disabled
    ```

1.  Reboot host.

1.  To install Docker add the Yum repo.

    ```bash
    $ sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
    [dockerrepo]
    name=Docker Repository
    baseurl=https://yum.dockerproject.org/repo/main/centos/7/
    enabled=1
    gpgcheck=1
    gpgkey=https://yum.dockerproject.org/gpg
    EOF
    ```

1.  Install the Docker package.

    ```bash
    $ sudo yum install docker-engine-1.11.2
    ```

1.  Add following changes to `/usr/lib/systemd/system/docker.service`.

    ```bash
    ExecStart=/usr/bin/docker daemon --storage-driver=overlay
    ```

1.  Reload systemd.

    ```bash
    $ sudo systemctl daemon-reload
    ```

1.  Start Docker.

    ```bash
    $ sudo systemctl start docker.service
    ```

1.  Verify that Docker works.

    ```bash
    $ sudo docker run hello-world
    ```

## <a name="install"></a>Install the DC/OS GCE scripts

1.  Download the `dcos-gce` scripts

    ```bash
    $ git clone https://github.com/ajazam/dcos-gce
    ```

1.  Change directory.

    ```bash
    $ cd dcos-gce
    ```

1.  Review and customize the `dcos_gce/group_vars/all`. You should review `project`, `subnet`, `login_name`, `bootstrap_public_ip`, and `zone`. To install DC/OS v1.7, ensure that:

    ```
    dcos_installer_download_path = "https://downloads.dcos.io/dcos/EarlyAccess/commit/14509fe1e7899f439527fb39867194c7a425c771/{{ dcos_installer_filename }}?_ga=1.2991607.674486911.1475259096/"
    ```

1.  Insert following into `~/.ansible.cfg` to stop host key checking.

    ```bash
    [defaults]
    host_key_checking = False

    [paramiko_connection]
    record_host_keys = False

    [ssh_connection]
    ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o UserKnownHostsFile=/dev/null
    ```
Ensure The IP address for master0 in dcos_gce/hosts is the next consecutive IP from bootstrap_public_ip, e.g. if bootstrap_public_ip = 1.2.3.4 then ensure master0 = 1.2.3.5

1.  To create and configure the master nodes run this command:

    ```bash
    $ ansible-playbook -i hosts install.yml
    ```

1.  To create and configure the private nodes run this command:

    ```bash
    $ ansible-playbook -i hosts add_agents.yml --extra-vars "start_id=0001 end_id=0002 agent_type=private"
    ```
    Where `start_id=0001` and `end_id=0002` specify the range of IDs that are appended to the hostname "agent" to create unique agent names. If `start_id` is not specified, a default value of `0001` is used.  If the `end_id` is not specified, a default value of `0001` is used. The values for `agent_type` are either private or public. If an `agent_type` is not specified, a default value of `agent_type=private` is used.

1.  To create public nodes run this command:

    ```bash
    $ ansible-playbook -i hosts add_agents.yml --extra-vars "start_id=0003 end_id=0004 agent_type=public"
    ```

## <a name="configure"></a>Configurable parameters

- File `dcos_gce/hosts` is an Ansible inventory file. Text wrapped by brackets `[]` represents a group name and individual entries after the group name represent hosts in that group.

- The `[masters]` group contains node names and IP addresses for the master nodes. In the supplied file, the host name is `master0` and the IP address `10.132.0.3` is assigned to `master0`. **YOU MUST CHANGE** the IP address for `master0` for your network. You can create multiple entries, for example `master1`, `master2` etc. Each node must have a unique IP address.

- The `[agents]` group has one entry. It specifies the names of all the agents one can have in the DC/OS cluster. The value specifies that `agent0000` to `agent9999`. A total of 10,000 agents are allowed. This really is an artificial limit because it can easily be changed.

- The `[bootstrap]` group has the name of the bootstrap node.

- File `./group_vars/all` contains miscellaneous parameters that will change the behaviour of the installation scripts. The parameters are split into two groups.

    - Group 1 parameters must be changed to reflect your environment.
    - Group 2 parameters can optionally be changed to change the behaviour of the scripts.

### Group 1
You must customize these for your environment.

### project
Specify your project ID. Default: `trek-trackr`.

### subnet
Specify your network. Default: `default`.

### login_name
Specify the login name used for accessing each GCE instance. Default: `ajazam`.

### bootstrap_public_ip
Specify the bootstrap nodes public IP. Default: `10.132.0.2`.

### zone
You can optionally specify your preferred zone. Default: `europe-west1-d`.


### Group 2
You can optionally change these parameters to modify the behaviour of the installation scripts.

### master_boot_disk_size:
Specify the size of the master node boot disk. Default 10 GB.

### master_machine_type
Specify the GCE instance type used for the master nodes. Default: `n1-standard-2`.

### master_boot_disk_type
Specify the master boot disk type. Default: `pd-standard`.

### agent_boot_disk_size
Specify the size of the agent boot disk. Default 10 GB.

### agent_machine_type
Specify the GCE instance type used for the agent nodes. Default: `n1-standard-2`.

### agent_boot_disk_type
Specify the agent boot disk type. Default: `pd-standard`.

### agent_instance_type
Specify whether agents are preemptible. If the value is `"MIGRATE"` then they are not preemptible. If the value is `"TERMINATE" --preemptible` then the instance is preemptible. Default: `"MIGRATE"`.

### agent_type
Specify whether an agent is "public" or "private". Default: "private".

### start_id
Specify the number appended to the text *agent* is used to define the hostname of the first agent. e.g. `agent0001`. Intermediate agents between `start_id` and `end_id` will be created if required. Default: `0001`.

### end_id
Specify the number appended to the text *agent* is used to define the hostname of the last agent. e.g. `agent0001`. Intermediate agents between `start_id` and `end_id` will be created if required. Default: `0001`.


### gcloudbin
Specify the location of the gcloudbin binary. Default: `/usr/local/bin/gcloud`.

### image
Specify the disk image used on the master and agent. Default: `/centos-cloud/centos-7-v20160921`.

### bootstrap_public_port
Specify the port on the bootstrap node which is used to fetch the DC/OS installer from each of the master and agent nodes. Default: `8080`.

### cluster_name
Specify the name of the DC/OS cluster. Default: `cluster_name`.

### scopes
Do not change this parameter. It is required by the Google Cloud SDK.

### dcos_installer_filename
Specify the filename for the DC/OS installer. Default `dcos_generate_config.sh`.

### dcos_installer_download_path
Specify the location of where the DC/OS installer is available from [dcos.io](https://dcos.io). Default: `https://downloads.dcos.io/dcos/stable/{{ dcos_installer_filename }}`. The value of `{{ dcos_installer_file }}` is described above.

### home_directory
Specify the home directory for your logins. Default: `/home/{{ login_name }}`. The value of `{{ login_name }}` is described above.

### downloads_from_bootstrap
Specify the concurrent downloads of the DC/OS installer to the cluster of master and agent nodes. You might need to experiment with this to get the best performance. The performance will be a function of the machine type used for the bootstrap node. Default: 2.

### dcos_bootstrap_container
Specify the name of the DC/OS bootstrap container running on the bootstrap node. Default: `dcosinstaller`.





