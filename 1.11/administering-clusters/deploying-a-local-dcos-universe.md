---
post_title: Deploying a Local Universe
menu_order: 1000
feature_maturity: preview
---


You can install and run DC/OS services on a datacenter without internet access with a local [Universe](https://github.com/mesosphere/universe). You can deploy a local Universe that includes all Certified packages (easiest), or a local Universe that includes selected packages (advanced).

**Prerequisites:**

- [DC/OS CLI installed](/docs/1.11/cli/install/).

- Logged into the DC/OS CLI. On Enterprise DC/OS, you must be logged in as a user with the `dcos:superuser` permission.

**Note:** As the Universe tarball is over two gigabytes in size it may take some time to download it to your local drive and upload it to each master.

# <a name="certified"></a>Deploying a local Universe containing Certified Universe packages

1.  From a terminal prompt, use the following commands to download the local Universe and its service definitions onto your local drive.

    ```bash
    curl -v https://downloads.mesosphere.com/universe/public/local-universe.tar.gz -o local-universe.tar.gz
    curl -v https://raw.githubusercontent.com/mesosphere/universe/version-3.x/docker/local-universe/dcos-local-universe-http.service -o dcos-local-universe-http.service
    curl -v https://raw.githubusercontent.com/mesosphere/universe/version-3.x/docker/local-universe/dcos-local-universe-registry.service -o dcos-local-universe-registry.service
    ```

1.  Use [secure copy](https://linux.die.net/man/1/scp) to transfer the Universe and registry files to a master node, replacing `<master-IP>` with the public IP address of a master before issuing the following commands.

     **Tip:** You can find the public IP address of a master in the top left corner of the DC/OS web interface.

    ```bash
    scp local-universe.tar.gz core@<master-IP>:~
    scp dcos-local-universe-http.service core@<master-IP>:~
    scp dcos-local-universe-registry.service core@<master-IP>:~
    ```

1.  [SSH](/docs/1.11/administering-clusters/sshcluster/) into the master using the following command. Replace `<master-IP>` with the IP address used in the previous commands.

    ```bash
    ssh -A core@<master-IP>
    ```

1.  Confirm that the files were successfully copied.

    ```
    ls
    ```

1.  You should see the following files listed.

    ```
    dcos-local-universe-http.service  dcos-local-universe-registry.service  local-universe.tar.gz
    ```

1.  Move the registry files into the `/etc/systemd/system/` directory.

    ```
    sudo mv dcos-local-universe-registry.service /etc/systemd/system/
    sudo mv dcos-local-universe-http.service /etc/systemd/system/
    ```

1.  Confirm that the files were successfully copied into `/etc/systemd/system/`.

    ```bash
    ls -la /etc/systemd/system/dcos-local-universe-*
    ```

1.  Load the Universe into the local Docker instance.

    ```bash
    docker load < local-universe.tar.gz
    ```

    **Tip:** This may take some time to complete.

1.  Restart the systemd daemon.

    ```bash
    sudo systemctl daemon-reload
    ```

1.  Enable and start the `dcos-local-universe-http` and `dcos-local-universe-registry` services.

    ```bash
    sudo systemctl enable dcos-local-universe-http
    sudo systemctl enable dcos-local-universe-registry
    sudo systemctl start dcos-local-universe-http
    sudo systemctl start dcos-local-universe-registry
    ```

1.  Use the following commands to confirm that the services are now up and running.

    ```bash
    sudo systemctl status dcos-local-universe-http
    sudo systemctl status dcos-local-universe-registry
    ```

1.  If you only have one master, skip to step 25. If you have multiple masters, continue to the next step.

1.  Use the following command to discover the private IP addresses of all of your masters. Identify the private IP address of the master you are SSHed into right now from the list.

    **Tip:** It will match the path shown after `core@ip-` in your prompt, where the hyphens become periods.

    ```
    host master.mesos
    ```

1.  Use [secure copy](https://linux.die.net/man/1/scp) to transfer the Universe and registry files to one of the other masters. Replace `<master-IP>` with the IP address of the other master.

    ```bash
    scp local-universe.tar.gz core@<master-IP>:~
    scp /etc/systemd/system/dcos-local-universe-registry.service core@<master-IP>:~
    scp /etc/systemd/system/dcos-local-universe-http.service core@<master-IP>:~
    ```

1.  [SSH](/docs/1.11/administering-clusters/sshcluster/) into the master that you just copied these files to.

    ```bash
    ssh -A core@<master_IP>
    ```

1.  Confirm that the files were successfully copied.

    ```
    ls
    ```

1.  You should see the following files listed.

    ```
    dcos-local-universe-http.service  dcos-local-universe-registry.service  local-universe.tar.gz
    ```

1.  Move the registry files into the `/etc/systemd/system/` directory.

    ```
    sudo mv dcos-local-universe-registry.service /etc/systemd/system/
    sudo mv dcos-local-universe-http.service /etc/systemd/system/
    ```

1.  Confirm that the files were successfully copied into `/etc/systemd/system/`.

    ```bash
    ls -la /etc/systemd/system/dcos-local-universe-*
    ```

1.  Load the Universe into the local Docker instance.

    ```
    docker load < local-universe.tar.gz
    ```

    **Tip:** This may take some time to complete.

1.  Restart the Docker daemon.

    ```bash
    sudo systemctl daemon-reload
    ```

1.  Start the `dcos-local-universe-http` and `dcos-local-universe-registry` services.

    ```bash
    sudo systemctl start dcos-local-universe-http
    sudo systemctl start dcos-local-universe-registry
    ```

1.  Use the following commands to confirm that the services are now up and running.

    ```bash
    sudo systemctl status dcos-local-universe-http
    sudo systemctl status dcos-local-universe-registry
    ```

1.  Repeat steps 14 through 23 until you have completed this procedure for all of your masters. Then continue to the next step.

1.  Close the SSH session by typing `exit` or open a new terminal prompt.

     **Tip:** You may have to exit more than one SSH session if you have multiple masters.

1.  (Optional) Use the following command to remove the references to the default Universe from your cluster. If you want to leave the default Universe in place and just add the local Universe as an additional repository, skip to the next step.

    ```bash
    dcos package repo remove Universe
    ```

    **Tip:** You can also remove the references to the default Universe repository from **Settings** > **Package Repositories** in the DC/OS web interface.

1.  Use the following command to add a reference to the local Universes that you added to each master.

    ```bash
    dcos package repo add local-universe http://master.mesos:8082/repo
    ```

1.  [SSH into one of your agent nodes.](/docs/1.11/administering-clusters/sshcluster/)

    ```bash
    dcos node ssh --master-proxy --mesos-id=<mesos-id>
    ```

1.  Use the following commands to download a copy of the DC/OS certificate locally and set it as trusted.

    ```bash
    sudo mkdir -p /etc/docker/certs.d/master.mesos:5000
    sudo curl -o /etc/docker/certs.d/master.mesos:5000/ca.crt http://master.mesos:8082/certs/domain.crt
    sudo systemctl restart docker
    ```

1. Configure the Apache Mesos fetcher to trust the downloaded Docker certificate.

   1. Copy the certificate:
   ```
   sudo cp /etc/docker/certs.d/master.mesos:5000/ca.crt /var/lib/dcos/pki/tls/certs/docker-registry-ca.crt
   ```
   1. Generate a hash:
   ```
   cd /var/lib/dcos/pki/tls/certs/
   openssl x509 -hash -noout -in docker-registry-ca.crt
   ```
   1. Create a soft link:
   ```
   sudo ln -s /var/lib/dcos/pki/tls/certs/docker-registry-ca.crt /var/lib/dcos/pki/tls/certs/<hash_number>.0
   ```
   **Note:** You will need to create the `/pki/tls/certs` directory on the public agent.

1.  Close the SSH session by typing `exit` or open a new terminal prompt. Repeat steps 28-30 on each agent node.

1.  To verify your success, log into the DC/OS web interface and click the **Catalog** tab. You should see a list of Certified packages. Install one of the packages.



### FAQ

*   **I can't install CLI subcommands**

    Packages are hosted at `master.mesos:8082`. If you cannot resolve or connect to `master.mesos:8082` from your DC/OS CLI install, you cannot install CLI subcommands. If you can connect to port 8082 on your masters, add the IP for one of the masters to `/etc/hosts`.

*   **The images are broken**

    All Universe components are hosted inside of your cluster, including the images. The components are served up by `master.mesos:8082`. If you have connectivity to that IP, you can add it to `/etc/hosts` and get the images working.

*   **I don't see the package I was looking for**

    By default, only Certified packages are bundled. If you'd like to get something else, use the instructions in the next section.

# <a name="build"></a>Deploying a local Universe containing selected packages

**Prerequisite:** [Git](https://git-scm.com/). On Unix/Linux, see these <a href="https://git-scm.com/book/en/v2/Getting-Started-Installing-Git" target="_blank">installation instructions</a>.

To deploy a local Universe containing your own set of packages you must build a customized local Universe Docker image.

1.  Clone the Universe repository:

    ```bash
    git clone https://github.com/mesosphere/universe.git --branch version-3.x
    ```

2.  Build the `universe-base` image:

    ```bash
    cd universe/docker/local-universe/
    sudo make base
    ```

3.  Build the `mesosphere/universe` Docker image and compress it to the `local-universe.tar.gz`
file. Specify a comma-separated list of package names and versions using the `DCOS_PACKAGE_INCLUDE`
variable. To minimize the container size and download time, you can select only what you need. If
you do not use the `DCOS_PACKAGE_INCLUDE` variable, all Certified Universe packages are
included. To view which packages are Certified, click the **Catalog** tab in the DC/OS web
interface.

    ```bash
    sudo make DCOS_VERSION=1.10 DCOS_PACKAGE_INCLUDE="cassandra:1.0.25-3.0.10,marathon:1.4.2" local-universe
    ```

4.  Perform all of the steps as described in [Deploying a local Universe containing Certified Universe packages][5], except step 27. Replace the command in step 27 with the following.

    ```bash
    dcos package repo add local-universe http://master.mesos:8082/repo
    ```

 [5]: #certified
