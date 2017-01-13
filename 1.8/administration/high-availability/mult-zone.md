---
post_title: Multiple Zones
menu_order: 1
---

Here are recommendations for specific multi-AZ configurations.

**Important:** A typical DC/OS cluster has all master and agent nodes in the same zone. The cost of having masters spread across zones usually outweigh the benefits. None of the following multi-AZ setups have been explicitly tested or verified by Mesosphere.

# Single-zone masters and cross-zone agents within a region
All DC/OS masters are present in a single zone, but the agents can span multiple zones within that region.

#### Recommendations


- If you are using a rack, you should distribute masters across the racks.
- All agents within a zone should be tagged with an attribute (e.g., `zone:us-east-1a`) to easily constrain apps and services to specific zones.
- Any DC/OS service schedulers should be scheduled to the same zone as masters (e.g., by using constraints).
- For ease of failover of apps between zones, ensure that apps do not depend on zone level resources or that those resources are properly replicated and migrated on failover. Also ensure there is enough spare capacity in each zone to handle failover workload.

#### Caveats

- If an agent-only zone fails, all other zones will continue to function normally. Apps from the failed zone will be rescheduled into other zones as long as there is spare capacity.
- If an agent-only zone gets partitioned from the masters-containing zone, apps will continue to run in that zone but schedulers might “reschedule” copies of the apps into other zones. 
- If a masters-containing zone fails, apps in other zones continue to run. But app updates or rescheduling of failed apps is not possible, until a quorum of masters come up.
- The total cross-sectional bandwidth between zones is limited. This means that performance can be degraded for data (I/O) intensive DC/OS services if deployed across zones.

# Cross-zone masters and cross-zone agents within a region
DC/OS masters and agents span multiple zones within a region.

#### Recommendations

- Quorum size and placement of masters should tolerate zone failure. For example, for a quorum size of two, place each of the three masters in a separate zone. Do not place a quorum of masters into a single zone.
- Quorum size and placement of masters should tolerate zone failure for DC/OS service schedulers. This can be achieved using constraints.
- For ease of failover of apps between zones, ensure that either apps do not depend on zone level resources or that those resources are properly replicated and migrated on failover.

#### Caveats

- If a zone that contains masters fails, apps that belong to that zone will be rescheduled to other zones if there is spare capacity. All DC/OS components should work normally if a quorum of masters is alive.
- Because networking partitions are more likely across zones, masters could end up in split-brain scenario. For example, two different masters think they are the leader at the same time. This is typically harmless because only one leader is allowed to make modifiable actions, for example register or shutdown agents.
- The total cross-sectional bandwidth between zones is limited. This means that performance can be degraded for data (I/O) intensive DC/OS services if deployed across zones.