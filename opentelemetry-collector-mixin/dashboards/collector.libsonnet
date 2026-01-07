local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local row = g.panel.row;
local variables = import './utils/variables.libsonnet';
local panels = import './utils/panels.libsonnet';
local queries = import './utils/queries.libsonnet';
local cfg = import '../config.libsonnet';

{
  grafanaDashboards+:: {
    'collector.json':
      g.dashboard.new(
        cfg._config.grafana.dashboardNamePrefix + 'Operational',
      )
      + g.dashboard.withDescription('A dashboard for monitoring the health of OpenTelemetry Collector instances using their internal metrics.')
      + g.dashboard.graphTooltip.withSharedCrosshair()
      + g.dashboard.withEditable(false)
      + g.dashboard.withUid(cfg._config.grafanaDashboardIDs['collector.json'])
      + g.dashboard.withTimezone(cfg._config.grafana.grafanaTimezone)
      + g.dashboard.withTags(cfg._config.grafana.dashboardTags)
      + g.dashboard.withVariables(variables.multiInstance)
      + g.dashboard.withPanels(
        g.util.grid.wrapPanels([
          // Overview row
          row.new('Overview'),
          panels.stat.base('Running collectors', [queries.runningCollectors]),
          panels.table.uptime('Collector uptime', [queries.collectorUptime]),

          // Resources row
          row.new('Resources'),
          panels.timeSeries.cpuUsage('CPU usage', [queries.cpuUsage])
          + { gridPos: { w: 8 } },
          panels.timeSeries.memoryUsage('Memory (RSS)', queries.memUsageRSS)
          + { gridPos: { w: 8 } },
          panels.timeSeries.memoryUsage('Memory (heap alloc)', queries.memUsageHeapAlloc)
          + { gridPos: { w: 8 } },

          // Receivers row
          row.new('Receivers'),
          panels.timeSeries.short('Accepted metric points', [queries.acceptedMetricPoints])
          + { gridPos: { w: 6 } },
          panels.timeSeries.short('Accepted log records', [queries.acceptedLogRecords])
          + { gridPos: { w: 6 } },
          panels.timeSeries.short('Accepted spans', [queries.acceptedSpans])
          + { gridPos: { w: 6 } },
          panels.timeSeries.short('Total incoming items', [queries.incomingItems])
          + { gridPos: { w: 6 } },
          panels.timeSeries.short('Refused metric points', [queries.refusedMetricPoints])
          + { gridPos: { w: 6 } },
          panels.timeSeries.short('Refused log records', [queries.refusedLogRecords])
          + { gridPos: { w: 6 } },
          panels.timeSeries.short('Refused spans', [queries.refusedSpans])
          + { gridPos: { w: 6 } },
          panels.timeSeries.short('Total outgoing items', [queries.outgoingItems])
          + { gridPos: { w: 6 } },

          // Processors row
          row.new('Processors'),
          panels.heatmap.base('Number of units in the batch', [queries.batchSendSize])
          + { gridPos: { w: 8 } },
          panels.timeSeries.short('Batch cardinality', [queries.batchCardinality])
          + { gridPos: { w: 8 } },
          panels.timeSeries.short('Queue current size vs capacity', [queries.queueSize, queries.queueCapacity])
          + { gridPos: { w: 8 } },
          panels.timeSeries.short('Batch size send trigger', [queries.batchSizeSendTrigger]),
          panels.timeSeries.short('Batch timeout send trigger', [queries.batchTimeoutSendTrigger]),

          // Exporters row
          row.new('Exporters'),
          panels.timeSeries.short('Exported metrics', [queries.exportedMetrics])
          + { gridPos: { w: 8 } },
          panels.timeSeries.short('Exported logs', [queries.exportedLogs])
          + { gridPos: { w: 8 } },
          panels.timeSeries.short('Exported spans', [queries.exportedSpans])
          + { gridPos: { w: 8 } },
          panels.timeSeries.short('Failed metrics', [queries.failedMetrics])
          + { gridPos: { w: 8 } },
          panels.timeSeries.short('Failed logs', [queries.failedLogs])
          + { gridPos: { w: 8 } },
          panels.timeSeries.short('Failed spans', [queries.failedSpans])
          + { gridPos: { w: 8 } },
          panels.timeSeries.short('Enqueue failed metrics', [queries.enqueueFailedMetrics])
          + { gridPos: { w: 8 } },
          panels.timeSeries.short('Enqueue failed logs', [queries.enqueueFailedLogs])
          + { gridPos: { w: 8 } },
          panels.timeSeries.short('Enqueue failed spans', [queries.enqueueFailedSpans])
          + { gridPos: { w: 8 } },

          // Network traffic row
          row.new('Network traffic'),
          panels.timeSeries.seconds('Inbound gRPC request duration percentiles', [
            queries.grpcInboundDurationP50,
            queries.grpcInboundDurationP90,
            queries.grpcInboundDurationP99,
          ]),
          panels.timeSeries.seconds('Inbound HTTP request duration percentiles', [
            queries.httpInboundDurationP50,
            queries.httpInboundDurationP90,
            queries.httpInboundDurationP99,
          ]),
          panels.timeSeries.bytes('Inbound gRPC request size percentiles', [
            queries.grpcInboundSizeP50,
            queries.grpcInboundSizeP90,
            queries.grpcInboundSizeP99,
          ]),
          panels.timeSeries.bytes('Inbound HTTP request size percentiles', [
            queries.httpInboundSizeP50,
            queries.httpInboundSizeP90,
            queries.httpInboundSizeP99,
          ]),
          panels.timeSeries.seconds('Outgoing gRPC request duration percentiles', [
            queries.grpcOutboundDurationP50,
            queries.grpcOutboundDurationP90,
            queries.grpcOutboundDurationP99,
          ]),
          panels.timeSeries.seconds('Outgoing HTTP request duration percentiles', [
            queries.httpOutboundDurationP50,
            queries.httpOutboundDurationP90,
            queries.httpOutboundDurationP99,
          ]),
          panels.timeSeries.bytes('Outgoing gRPC request size percentiles', [
            queries.grpcOutboundSizeP50,
            queries.grpcOutboundSizeP90,
            queries.grpcOutboundSizeP99,
          ]),
          panels.timeSeries.bytes('Outgoing HTTP request size percentiles', [
            queries.httpOutboundSizeP50,
            queries.httpOutboundSizeP90,
            queries.httpOutboundSizeP99,
          ]),

        ], panelWidth=12, panelHeight=8),
      ),
  },
}
