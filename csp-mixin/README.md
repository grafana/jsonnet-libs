# CSPlib

A collection of dashboards and their component parts for cloud service provider SaaS services.

# New Dashboard definition
1. Create a new `.libsonnet` file on the `csp-mixin/signals` folder that will contain the general settings of your dashboard and its panels like title, description, panel queries, legend template, discovery metric, variable definitions, aggregation level...
2. Define variables definition by setting `groupLabels` and `instanceLabels` in your signal. You can use the global values defined on `azureconfig.libsonnet` or `gcpconfig.libsonnet` or override them as needed. Ex. You can initialize groupLabels like: `groupLabels: this.groupLabels` or override it like: `groupLabels: ['job', 'resourceName']`.
3. Add the new signal definition to the `config.libsonnet` file. Ex. `azurevm: (import './signals/azurevm.libsonnet')(this),`.
4. Create a new `.libsonnet` file on the `csp-mixin/panels` folder containing the configuration for each panel. Example:
   ```
   [panel_name]:
     this.signals.[panel_id].[signal_id].as[visualization_type]()
     + commonlib.panels.generic.[visualization_type].base.stylize(),
   
   # Example: 
   
   avm_instance_count:
      this.signals.azurevmOverview.instanceCount.asStat()
      + commonlib.panels.generic.stat.base.stylize(),

   avm_cpu_utilization:
     this.signals.azurevm.cpuUtilization.asTimeSeries()
     + commonlib.panels.generic.timeSeries.base.stylize(),
   ```
   Use **asPanelMixin** when you want to show multiple queries on the same panel. Example:
   ```
   this.signals.azurevmOverview.diskReadOperations.asTimeSeries()
     + commonlib.panels.generic.timeSeries.base.stylize()
     + this.signals.azurevmOverview.diskWriteOperations.asPanelMixin()
   ```
   
   _Note: You can prefix the definition with the first letter of the provider and the first letter of the dashboard name You want to build. Ex. `avm_` for **A**zure **V**irtual **M**achine._

5. Add all your row definitions in the `rows.libsonnet` file. You need to define:
   - The title of the row if you have one.
   - The panel(s) that you want to show.
   - The width and height of each panel
   
   See example below:
   
   ```
   avm_overview: [
     # the row definition is optional. You can show all panels together without to group them by row.
     g.panel.row.new('Overview'),

     this.grafana.panels.azurevm.avm_instance_count
      + g.panel.timeSeries.gridPos.withW(12)
      + g.panel.timeSeries.gridPos.withH(5),

     this.grafana.panels.azurevm.avm_availability
      + g.panel.timeSeries.gridPos.withW(12)
      + g.panel.timeSeries.gridPos.withH(5),
      ...
   ]
   ```
6. Add your dashboard definition to the `dashboards.libsonnet` file. 
   You can define a unique signal for **gcp** and **azure** dashboard or specify a dashboard just for one of the providers (azure or gcp). See example below:
   ```
   +
   if csplib.config.uid == 'azure' then
   {
      [csplib.config.uid + '-virtualmachines.json']:
        local variables = csplib.signals.azurevm.getVariablesMultiChoice();
        g.dashboard.new(csplib.config.dashboardNamePrefix + 'Virtual Machines')
        + g.dashboard.withUid(csplib.config.uid + '-virtualmachines')
        + g.dashboard.withTags(csplib.config.dashboardTags)
        + g.dashboard.withTimezone(csplib.config.dashboardTimezone)
        + g.dashboard.withRefresh(csplib.config.dashboardRefresh)
        + g.dashboard.timepicker.withTimeOptions(csplib.config.dashboardPeriod)
        + g.dashboard.withVariables(variables)
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            csplib.grafana.rows.avm_overview
          )
        ),
   } else {},
   ```

7. Run the following command from the `csp-mixin` folder to generate all the dashboards in `json` format and then import the one you are building on any instance. Check the folder `csp-mixin/dashout` that will contain all the generated dashboards:
   ```
   mixtool generate dashboards -J vendor -d dashout mixin.libsonnet
   ```
8. Lint and fix the files modified executing the following command from the root folder:
   ```
   make fmt
   ```

# Notes

## Blob Storage
* GCP - https://cloud.google.com/monitoring/api/metrics_gcp#gcp-storage
  * The `quota` metrics are alpha, and don't seem to be getting fetched by Grafana Alloy, even when enabled as a metrics prefix. Perhaps this needs to be enabled for a project?
  * `replication` metrics are beta. The only metric which is being retrieved by alloy is `replication/meeting_rpo` which is consistently 1 for all buckets. It may not make sense to graph these metrics, but perhaps it's useful to have an alert?
  * `storage` metrics (object_count, total_bytes), have a "v2" which is beta. As such, this lib is using the (implied) v1 metrics which are GA.
  * There are no latency metrics available
* Azure - https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/microsoft-storage-storageaccounts-blobservices-metrics
  * `Availability` is an available metric. It may not make sense to graph this, but perhaps it is useful to have an alert?
  * There are latency metrics. In our test environment there is very little (no?) traffic. What I have observed is that E2E latency, and server latency is the same value in our limited dataset. Perhaps this should only show a delta, I.E. if E2E is greater than server.
  * Network throughput (ingress/egress) metrics for azure are gauges, not counters. Right now, the promql uses rate, which produces "odd" results. The other option, using `deriv` produces negative values with the available data, which is also suboptimal. We *could* just put the raw gauge value on the timeseries, and call it a day. :thinking:
* AWS - TODO
