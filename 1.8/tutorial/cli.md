---
post_title: DC/OS 101 - First Steps
menu_order: 3
---

Welcome to part 1 of the DC/OS 101 Tutorial.

# Challenge
We have already taken a first look around the UI and now wonder "What is the best way to connect my cluster".

# Steps
  * Install CLI - https://dcos.io/docs/1.8/usage/cli/install/ or left lower corner in cluster.
    Make sure you are authorized to connect to your cluster by running `dcos auth login`.

  * Explore the cluster:
      * Check the running services with `dcos service`
      * Check the connected nodes with `dcos node`
      * Explore the logs of the leading master with `dcos node log --leader`

# Outcome
 We have sucessfully connected via the cli to our cluster.

# Deep Dive
 System Architecture Overview
