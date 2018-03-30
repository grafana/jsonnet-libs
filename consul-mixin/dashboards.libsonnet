local g = import "klumps/lib/grafana.libsonnet";

{
  dashboards+:: {
    "consul.json": g.dashboard("Consul")
      .addTemplate("namespace", "kube_pod_container_info{image=~\".*consul.*\"}", "namespace")
      .addRow(
        g.row("Leader")
        .addPanel(
          g.panel("Leader Status") +
          g.statPanel('min(consul_raft_leader)', 'none')
        )
        .addPanel(
          g.panel("QPS") +
          g.queryPanel('irate(consul_rpc_requests[1m])', 'QPS')
        )
      )
  },
}
