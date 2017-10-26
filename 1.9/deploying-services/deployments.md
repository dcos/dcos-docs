---
post_title: Deployments
menu_order: 5
---

Every change in the definition of applications or groups in DC/OS is performed as a Marathon deployment. A [deployment](/docs/1.9/deploying-services/marathon-api/#!/deployments/V2Deployments) is a set of actions, including:

- Start
- Stop
- Upgrade
- Scale

Marathon deployments are active until the deployment finished successfully.

You can deploy multiple applications at the same time, but you cannot deploy the same application if it is already an active deployment. Multiple deployment requests for the same application will be rejected.

# Dependencies 

If applications do not have dependencies, they can be deployed in any order without restriction. If there are dependencies, then the deployment actions are performed in a specific order.

In this example, the application `app` is dependent on the application `db`. 

![dependency diagram](/docs/1.9/img/dependency.png)

Here is the deployment order:

- Starting : if `db` and `app` are added to the system, `db` is started first and then app.
- Stopping : if `db` and `app` are removed from the system, `app` is removed first and then `db`.
- Upgrade : See [Rolling Restarts](#rolling).
- Scaling : if `db` and `app` are scaled, `db` is scaled first and then `app`.

# <a name="rolling"></a>Rolling Upgrades
 
The goal of rolling upgrades is to start a set of processes with the new version and stop the set of processes with the old version. There are many ways to do this. By default, DC/OS service deployments use the rolling upgrade method. 

The upgrade behavior is controlled by health and readiness checks that are set in your application. 

- **Health checks** are specified in each application and are run against tasks. If health check fails for a task, DC/OS will replace the task. For more information, see the [documentation](/docs/1.9/deploying-services/creating-services/health-checks/).
- **Readiness checks** are a temporary monitor that wait for your application to be ready. Readiness checks are useful for cache-warming, JIT warming, or a migration. If a readiness check fails, DC/OS will wait until it succeeds before continuing with the deployment.

You can use the `minimumHealthCapacity` parameter to define the minimum number of healthy instances that a certain version of the application must have at all times during update. This parameter is defined individually in each application. The minimumHealthCapacity is a percentage which, when applied to the instance count, defines the number of healthy instances that a certain version of the application must have at all times during update. 


