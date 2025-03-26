local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(csplib):
    local this = self;
    {
      [csplib.config.uid + '-blobstorage.json']:
        local variables = csplib.signals.blobstore.getVariablesMultiChoice();
        g.dashboard.new(csplib.config.dashboardNamePrefix + 'Blob storage')
        + g.dashboard.withUid(csplib.config.uid + '-blobstorage')
        + g.dashboard.withTags(csplib.config.dashboardTags)
        + g.dashboard.withTimezone(csplib.config.dashboardTimezone)
        + g.dashboard.withRefresh(csplib.config.dashboardRefresh)
        + g.dashboard.timepicker.withTimeOptions(csplib.config.dashboardPeriod)
        + g.dashboard.withVariables([
          if std.asciiLower(v.label) == std.asciiLower(csplib.config.blobStorage.bucketLabel)  //v.label == 'Bucket_name'
          then v { label: 'Bucket Name' }
          else v
          for v in variables
        ])
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                csplib.grafana.rows.overview,
                csplib.grafana.rows.api,
                csplib.grafana.rows.network,
              ]
            )
          )
        ),
    }
    +
    if csplib.config.uid == 'gcp' then
      {
        [csplib.config.uid + '-loadbalancer.json']:
          local variables = csplib.signals.gcploadbalancer.getVariablesMultiChoice();
          g.dashboard.new(csplib.config.dashboardNamePrefix + 'Load Balancing')
          + g.dashboard.withUid(csplib.config.uid + '-loadbalancer')
          + g.dashboard.withTags(csplib.config.dashboardTags)
          + g.dashboard.withTimezone(csplib.config.dashboardTimezone)
          + g.dashboard.withRefresh(csplib.config.dashboardRefresh)
          + g.dashboard.timepicker.withTimeOptions(csplib.config.dashboardPeriod)
          + g.dashboard.withVariables([
            if std.asciiLower(v.label) == std.asciiLower(csplib.config.gcploadBalancer.backendLabel)
            then v { label: 'Backend Target' }
            else if std.asciiLower(v.label) == std.asciiLower(csplib.config.gcploadBalancer.countryLabel)
            then v { label: 'Country' }
            else v
            for v in variables
          ])
          + g.dashboard.withPanels(
            g.util.panel.resolveCollapsedFlagOnRows(
              g.util.grid.wrapPanels(
                [
                  csplib.grafana.rows.glb_requests,
                  csplib.grafana.rows.glb_latency,
                  csplib.grafana.rows.glb_traffic_metrics,
                ]
              )
            )
          ),
        [csplib.config.uid + '-computeengine.json']:
          local variables = csplib.signals.gcpce.getVariablesMultiChoice();
          g.dashboard.new(csplib.config.dashboardNamePrefix + 'Compute Engine')
          + g.dashboard.withUid(csplib.config.uid + '-computeengine')
          + g.dashboard.withTags(csplib.config.dashboardTags)
          + g.dashboard.withTimezone(csplib.config.dashboardTimezone)
          + g.dashboard.withRefresh(csplib.config.dashboardRefresh)
          + g.dashboard.timepicker.withTimeOptions(csplib.config.dashboardPeriod)
          + g.dashboard.withVariables(variables)
          + g.dashboard.withPanels(
            g.util.panel.resolveCollapsedFlagOnRows(
              g.util.grid.wrapPanels(
                [
                  csplib.grafana.rows.gce_overview,
                  csplib.grafana.rows.gce_instance,
                ]
              )
            )
          ),

        [csplib.config.uid + '-vpc.json']:
          local variables = csplib.signals.gcpvpc.getVariablesMultiChoice();
          g.dashboard.new(csplib.config.dashboardNamePrefix + 'Virtual private cloud')
          + g.dashboard.withUid(csplib.config.uid + '-vpc')
          + g.dashboard.withTags(csplib.config.dashboardTags)
          + g.dashboard.withTimezone(csplib.config.dashboardTimezone)
          + g.dashboard.withRefresh(csplib.config.dashboardRefresh)
          + g.dashboard.timepicker.withTimeOptions(csplib.config.dashboardPeriod)
          + g.dashboard.withVariables([
            if std.asciiLower(v.label) == std.asciiLower('project_id')
            then v { label: 'Project' }
            else v
            for v in variables
          ])
          + g.dashboard.withPanels(
            g.util.panel.resolveCollapsedFlagOnRows(
              g.util.grid.wrapPanels(
                [
                  csplib.grafana.rows.gcpvpc_overview,
                  csplib.grafana.rows.gcpvpc_service,
                  csplib.grafana.rows.gcpvpc_tunnel,
                ]
              )
            ),
          ),
      } else {}
             +
             if csplib.config.uid == 'azure' then
               {
                 [csplib.config.uid + '-elasticpool.json']:
                   local variables = csplib.signals.azureelasticpool.getVariablesMultiChoice();
                   g.dashboard.new(csplib.config.dashboardNamePrefix + 'Elastic pool')
                   + g.dashboard.withUid(csplib.config.uid + '-elasticpool')
                   + g.dashboard.withTags(csplib.config.dashboardTags)
                   + g.dashboard.withTimezone(csplib.config.dashboardTimezone)
                   + g.dashboard.withRefresh(csplib.config.dashboardRefresh)
                   + g.dashboard.timepicker.withTimeOptions(csplib.config.dashboardPeriod)
                   + g.dashboard.withVariables(variables)
                   + g.dashboard.withPanels(
                     g.util.panel.resolveCollapsedFlagOnRows(
                       g.util.grid.wrapPanels(
                         [
                           csplib.grafana.rows.aep_storage,
                           csplib.grafana.rows.aep_resources,
                         ]
                       )
                     )
                   ),

                 [csplib.config.uid + '-sqldb.json']:
                   local variables = csplib.signals.azuresqldb.getVariablesMultiChoice();
                   g.dashboard.new(csplib.config.dashboardNamePrefix + 'SQL database')
                   + g.dashboard.withUid(csplib.config.uid + '-sqldb')
                   + g.dashboard.withTags(csplib.config.dashboardTags)
                   + g.dashboard.withTimezone(csplib.config.dashboardTimezone)
                   + g.dashboard.withRefresh(csplib.config.dashboardRefresh)
                   + g.dashboard.timepicker.withTimeOptions(csplib.config.dashboardPeriod)
                   + g.dashboard.withVariables(variables)
                   + g.dashboard.withPanels(
                     g.util.panel.resolveCollapsedFlagOnRows(
                       g.util.grid.wrapPanels(
                         [
                           csplib.grafana.rows.asql_connections,
                           csplib.grafana.rows.asql_resources,
                         ]
                       )
                     )
                   ),

                 [csplib.config.uid + '-loadbalancer.json']:
                   local variables = csplib.signals.azureloadbalancer.getVariablesMultiChoice();
                   g.dashboard.new(csplib.config.dashboardNamePrefix + 'Load Balancing')
                   + g.dashboard.withUid(csplib.config.uid + '-loadbalancer')
                   + g.dashboard.withTags(csplib.config.dashboardTags)
                   + g.dashboard.withTimezone(csplib.config.dashboardTimezone)
                   + g.dashboard.withRefresh(csplib.config.dashboardRefresh)
                   + g.dashboard.timepicker.withTimeOptions(csplib.config.dashboardPeriod)
                   + g.dashboard.withVariables(variables)
                   + g.dashboard.withPanels(
                     g.util.panel.resolveCollapsedFlagOnRows(
                       g.util.grid.wrapPanels(
                         [
                           csplib.grafana.rows.alb_summary,
                           csplib.grafana.rows.alb_details,
                           csplib.grafana.rows.alb_loadbalancers,
                         ]
                       )
                     )
                   ),

                 [csplib.config.uid + '-virtualmachines.json']:
                   local variables = csplib.signals.azurevm.getVariablesMultiChoice();
                   g.dashboard.new(csplib.config.dashboardNamePrefix + 'Virtual Machines')
                   + g.dashboard.withUid(csplib.config.uid + '-virtualmachines')
                   + g.dashboard.withTags(csplib.config.dashboardTags)
                   + g.dashboard.withTimezone(csplib.config.dashboardTimezone)
                   + g.dashboard.withRefresh(csplib.config.dashboardRefresh)
                   + g.dashboard.timepicker.withTimeOptions(csplib.config.dashboardPeriod)
                   + g.dashboard.withVariables([
                     if std.asciiLower(v.label) == std.asciiLower(csplib.config.commomVars.groupLabel)
                     then v { label: 'Group' }
                     else if std.asciiLower(v.label) == std.asciiLower(csplib.config.commomVars.subscriptionLabel)
                     then v { label: 'Subscription' }
                     else if std.asciiLower(v.label) == std.asciiLower(csplib.config.commomVars.instanceLabel)
                     then v { label: 'Instance' }
                     else v
                     for v in variables
                   ])
                   + g.dashboard.withPanels(
                     g.util.panel.resolveCollapsedFlagOnRows(
                       g.util.grid.wrapPanels(
                         [
                           csplib.grafana.rows.avm_overview,
                           csplib.grafana.rows.avm_instance,
                         ]
                       )
                     )
                   ),

                 [csplib.config.uid + '-frontdoor.json']:
                   local variables = csplib.signals.azurefrontdoor.getVariablesMultiChoice();
                   g.dashboard.new(csplib.config.dashboardNamePrefix + 'Front Door')
                   + g.dashboard.withUid(csplib.config.uid + '-frontdoor')
                   + g.dashboard.withTags(csplib.config.dashboardTags)
                   + g.dashboard.withTimezone(csplib.config.dashboardTimezone)
                   + g.dashboard.withRefresh(csplib.config.dashboardRefresh)
                   + g.dashboard.timepicker.withTimeOptions(csplib.config.dashboardPeriod)
                   + g.dashboard.withVariables([
                     if std.asciiLower(v.label) == std.asciiLower(csplib.config.commomVars.groupLabel)
                     then v { label: 'Group' }
                     else if std.asciiLower(v.label) == std.asciiLower(csplib.config.commomVars.subscriptionLabel)
                     then v { label: 'Subscription' }
                     else if std.asciiLower(v.label) == std.asciiLower(csplib.config.commomVars.dimensionEndpoint)
                     then v { label: 'Endpoint' }
                     else v
                     for v in variables
                   ])
                   + g.dashboard.withPanels(
                     g.util.panel.resolveCollapsedFlagOnRows(
                       g.util.grid.wrapPanels(
                         [
                           csplib.grafana.rows.afd_overview,
                           csplib.grafana.rows.afd_endpoints,
                         ]
                       )
                     )
                   ),

                 [csplib.config.uid + '-queuestorage.json']:
                   local variables = csplib.signals.azurequeuestore.getVariablesMultiChoice();
                   g.dashboard.new(csplib.config.dashboardNamePrefix + 'Queue storage')
                   + g.dashboard.withUid(csplib.config.uid + '-queuestoreage')
                   + g.dashboard.withTags(csplib.config.dashboardTags)
                   + g.dashboard.withTimezone(csplib.config.dashboardTimezone)
                   + g.dashboard.withRefresh(csplib.config.dashboardRefresh)
                   + g.dashboard.timepicker.withTimeOptions(csplib.config.dashboardPeriod)
                   + g.dashboard.withVariables(variables)
                   + g.dashboard.withPanels(
                     g.util.panel.resolveCollapsedFlagOnRows(
                       g.util.grid.wrapPanels(
                         [
                           csplib.grafana.rows.azqueuestore_overview,
                           csplib.grafana.rows.azqueuestore_api,
                           csplib.grafana.rows.azqueuestore_network,
                         ]
                       )
                     )
                   ),
               } else {},
}
