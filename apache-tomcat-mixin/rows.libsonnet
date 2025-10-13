local g = import './g.libsonnet';


{
  new(this):
    {
      local panels = this.grafana.panels,

      // overview rows
      overview: g.panel.row.new('Overview')
                + g.panel.row.withCollapsed(value=false)
                + g.panel.row.withPanels([
                  panels.overviewMemoryUsagePanel,
                  panels.overviewCPUUsagePanel,
                  panels.overviewTrafficSentPanel,
                  panels.overviewTrafficReceivedPanel,
                  panels.overviewRequestsPanel,
                  panels.overviewProcessingTimePanel,
                  panels.overviewThreadsPanel,
                ]),

      // hosts rows
      hosts: g.panel.row.new('Hosts')
             + g.panel.row.withCollapsed(value=false)
             + g.panel.row.withPanels([
               panels.hostsSessionsPanel,
               panels.hostsSessionProcessingTimePanel,
               panels.hostsServletPanel,
               panels.hostsServletProcessingTimePanel,
             ]),
    },
}
