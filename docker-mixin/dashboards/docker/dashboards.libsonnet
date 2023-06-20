local g = import 'grafana-builder/grafana.libsonnet';
local grafana = import 'grafonnet/grafana.libsonnet';

function(config, templates, panels) {
    docker: {
      docs: 'Dashboard giving an overview of Docker performance',
      spec: grafana.dashboard.new(
        'Docker Overview',
        time_from='%s' % config.dashboardPeriod,
        editable=false,
        tags=(config.dashboardTags),
        timezone='%s' % config.dashboardTimezone,
        refresh='%s' % config.dashboardRefresh,
        uid='integration-docker-overview'
      )

      .addTemplates([
        templates.ds.spec,
        templates.job.spec,
        templates.instance.spec,
        templates.container.spec,
      ])

      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Docker Dashboards',
        includeVars=true,
        keepTime=true,
        tags=(config.dashboardTags),
      ))

      // Overview Row
      .addPanel(grafana.row.new(title='Overview'), gridPos={ x: 0, y: 2, w: 0, h: 0 })
      // Total containers
      .addPanel(panels.total_containers.spec, gridPos={ x: 0, y: 2, w: 4, h: 6 })
      // Total Images
      .addPanel(panels.total_images.spec, gridPos={ x: 4, y: 2, w: 4, h: 6 })
      // Host CPU used by containers
      .addPanel(panels.cpu_usage.spec, gridPos={ x: 8, y: 2, w: 4, h: 6 })
      // Host memory reserved by containers
      .addPanel(panels.mem_reserved.spec, gridPos={ x: 12, y: 2, w: 4, h: 6 })
      // Host memory utilization by containers
      .addPanel(panels.mem_usage.spec, gridPos={ x: 16, y: 2, w: 4, h: 6 })

      // Compute Row
      .addPanel(grafana.row.new(title='Compute'), gridPos={ x: 0, y: 8, w: 0, h: 0 })
      // CPU by container
      .addPanel(panels.cpu_by_container.spec, gridPos={ x: 0, y: 8, w: 12, h: 8 })
      // Memory by container
      .addPanel(panels.mem_by_container.spec, gridPos={ x: 12, y: 8, w: 12, h: 8 })

      // Network Row
      .addPanel(grafana.row.new(title='Network'), gridPos={ x: 0, y: 16, w: 0, h: 0 })
      // Network throughput
      .addPanel(panels.net_throughput.spec, gridPos={ x: 0, y: 16, w: 12, h: 8 })
      // TCP Socket by state
      .addPanel(panels.tcp_socket_by_state.spec, gridPos={ x: 12, y: 16, w: 12, h: 8 })

      // Storage Row
      .addPanel(grafana.row.new(title='Storage'), gridPos={ x: 0, y: 24, w: 0, h: 0 })
      // Disk
      .addPanel(panels.disk_usage.spec, gridPos={ x: 0, y: 24, w: 24, h: 8 })
    },
}