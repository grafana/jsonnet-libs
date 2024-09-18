# CSPlib

A collection of dashboards and their component parts for cloud service provider SaaS services.

# New Dashboard definition
1. Create a new `.libsonnet` file on the `csp-mixin/signals` folder that will contain the general settings of your dashboard and its panels like title, description, panel queries, legend template, discovery metric, variable definitions, aggregation level...
2. Override default configuration loaded from `azureconfig.libsonnet` or `gcpconfig.libsonnet` for the specific dashboard if needed. Ex. You can initialize groupLabels like: `groupLabels: this.groupLabels` or override global values like this: `groupLabels: ['job', 'resourceName']`.
3. Add the new signal definition to the `config.libsonnet` file. Ex. `virtualMachines: (import './signals/virtualMachines.libsonnet')(this),`.
4. Add your panel definitions to the file `panels.libsonnet` like:
   ```
   [panel_id]:
     this.signals.[signal_id].[signal_definition_id].as[PanelType]()
     + commonlib.panels.generic.[panelType].base.stylize(),
   
   # Example: 
   
   avm_availability:
      this.signals.virtualMachines.vmAvailability.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
   
   alb_snatports:
      this.signals.azureloadbalancer.snatPorts.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
   ```
   _Note: You can prefix the definition with the first letter of the provider and the first letter of the dashboard name You want to build. Ex. `avm_` for **A**zure **V**irtual **M**achine because this file contains all panels for all dashboards._

5. Add all your row definitions in the `rows.libsonnet` file. You need to define:
   - The title of the row if you have one.
   - The panel(s) that you want to show.
   - The width and height of each panel
   
   See example below:
   
   ```
   alb_loadbalancers: [
      g.panel.row.new('SNAT Ports'),
      this.grafana.panels.alb_snatports
      + g.panel.timeSeries.gridPos.withW(12)
      + g.panel.timeSeries.gridPos.withH(8),
   ],
   
   # or without any row (just the panels)
   avm_overview: [
      this.grafana.panels.avm_availability
      + g.panel.timeSeries.gridPos.withW(24)
      + g.panel.timeSeries.gridPos.withH(2),
   ],
   ```
6. Add your dashboard definition to the `dashboards.libsonnet` file. You can define a unique signal for gcp and azure dashboard or specify a dashboard just for one of the provider (azure or gcp). See example below:
   ```
   +
   if csplib.config.uid == 'azure' then
   {
      [csplib.config.uid + '-virtualMachines.json']:
        local variables = csplib.signals.virtualMachines.getVariablesMultiChoice();
        g.dashboard.new(csplib.config.dashboardNamePrefix + 'Virtual Machines')
        + g.dashboard.withUid(csplib.config.uid + '-virtualMachines')
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

7. Run the following command to generate the .json object containing the dashboard definition and then import it as a new dashboard on any instance:
   ```
   mixtool generate dashboards -J vendor -d dashout mixin.libsonnet
   ```
8. Lint and fix the files modified with the following command:
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
