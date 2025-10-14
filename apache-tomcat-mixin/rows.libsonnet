local g = import './g.libsonnet';


{
  new(this):
    {
      local panels = this.grafana.panels,

      // overview rows
      overview: g.panel.row.new('Overview')
                + g.panel.row.withCollapsed(value=false)
                + g.panel.row.withPanels([
                  panels.overviewMemoryUsagePanel { gridPos+: { w: 12 } },
                  panels.overviewCPUUsagePanel { gridPos+: { w: 12 } },
                  panels.overviewTrafficSentPanel { gridPos+: { w: 12 } },
                  panels.overviewTrafficReceivedPanel { gridPos+: { w: 12 } },
                  panels.overviewRequestsPanel { gridPos+: { w: 12 } },
                  panels.overviewProcessingTimePanel { gridPos+: { w: 12 } },
                  panels.overviewThreadsPanel { gridPos+: { w: 24 } },
                ]),

      // hosts rows
      hosts: g.panel.row.new('Hosts')
             + g.panel.row.withCollapsed(value=false)
             + g.panel.row.withPanels([
               panels.hostsSessionsPanel { gridPos+: { w: 12 } },
               panels.hostsSessionProcessingTimePanel { gridPos+: { w: 12 } },
             ]),

      hostServlets: g.panel.row.new('Servlet')
                    + g.panel.row.withCollapsed(value=false)
                    + g.panel.row.withPanels([
                      panels.hostsServletPanel { gridPos+: { w: 12 } },
                      panels.hostsServletProcessingTimePanel { gridPos+: { w: 12 } },
                    ]),
    },
}
