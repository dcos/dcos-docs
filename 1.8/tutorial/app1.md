
# Challenge
So we have redis working in our cluster now, let us make write and deploy and app connecting to it.


# Steps
  * Deploy App
    * Take a short look at app [here](https://raw.githubusercontent.com/joerg84/dcos-101/master/app1/app1.py). It basically just checks it can reach redis and prints the total number of keys. Some details will follow in future parts of this tutorial.
    * As the script has dependencies (correct python version and redis-python), we will run it in a docker container providing these dependencies. Feel free to take a look at the DOCKERFILE [here](https://github.com/joerg84/dcos-101/blob/master/app1/DOCKERFILE).
    * Get app definition `wget https://raw.githubusercontent.com/joerg84/dcos-101/master/app1/app1.json` This app definition will download the python script and use to docker container
    * Add app `dcos marathon app add app1.json`
  * Check that is running
    * `dcos task`
    * `dcos marathon app list`
    * Verify app1 is running and connected to redis by checking the logs: `dcos task log app1`

# Outcome
 We have deployed our first App which can connect to redis.

# Deep Dive
   Marathon as service backend
            * long running services
            * Different deployment options
            * Deploy via CLI
            * Deploy via HTTP endpoints
            *  Uninstall
