---
post_title: Recovering Agent Disk Space
menu_order: 900
---

If tasks fill up the reserved volume of an agent node, there are a few options to recover space:

- Check each component's healthiness and restart each component.

- If the work directory is on a separate volume (as recommended in [Agent nodes](/docs/1.11/installing/custom/system-requirements/#agent-nodes), then you can empty this volume and restart the agent.

If neither of these approaches work, you may need to re-image the node. 
