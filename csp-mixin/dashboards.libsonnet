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
          g.util.grid.wrapPanels(
            csplib.grafana.rows.overview
            + csplib.grafana.rows.api
            + csplib.grafana.rows.network,
          )
        ),
    }
    +
    if csplib.config.uid == 'gcp' then
      {
        [csplib.config.uid + '-loadbalancer.json']:
          local variables = csplib.signals.loadbalancer.getVariablesMultiChoice();
          g.dashboard.new(csplib.config.dashboardNamePrefix + 'Load Balancing')
          + g.dashboard.withUid(csplib.config.uid + '-loadbalancer')
          + g.dashboard.withTags(csplib.config.dashboardTags)
          + g.dashboard.withTimezone(csplib.config.dashboardTimezone)
          + g.dashboard.withRefresh(csplib.config.dashboardRefresh)
          + g.dashboard.timepicker.withTimeOptions(csplib.config.dashboardPeriod)
          + g.dashboard.withVariables([
            if std.asciiLower(v.label) == std.asciiLower(csplib.config.loadBalancer.backendLabel)
            then v { label: 'Backend Target' }
            else if std.asciiLower(v.label) == std.asciiLower(csplib.config.loadBalancer.countryLabel)
            then v { label: 'Country' }
            else v
            for v in variables
          ])
          + g.dashboard.withPanels(
            g.util.grid.wrapPanels(
              csplib.grafana.rows.glb_requests
            )
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
                     g.util.grid.wrapPanels(
                       csplib.grafana.rows.aep_storage +
                       csplib.grafana.rows.aep_resources
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
                     g.util.grid.wrapPanels(
                       csplib.grafana.rows.asql_connections +
                       csplib.grafana.rows.asql_resources
                     )
                   ),
               } else {},
}
