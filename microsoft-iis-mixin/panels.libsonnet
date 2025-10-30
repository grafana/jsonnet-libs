local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this): {
    local signals = this.signals,
    local vars = this.grafana.variables,

    // Overview - Requests
    requests:
      g.panel.timeSeries.new('Requests')
      + g.panel.timeSeries.panelOptions.withDescription('The request rate split by HTTP Method for an IIS site')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.requests.requests.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('reqps')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withStacking({ mode: 'normal' }),

    requestErrors:
      g.panel.timeSeries.new('Request errors')
      + g.panel.timeSeries.panelOptions.withDescription('Requests that have resulted in errors for an IIS site.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.requests.lockedErrors.asTarget(),
        signals.requests.notFoundErrors.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('errors/sec')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    blockedAsyncIORequests:
      g.panel.timeSeries.new('Blocked async I/O requests')
      + g.panel.timeSeries.panelOptions.withDescription('Number of async I/O requests that are currently queued for an IIS site.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.async_io.blockedRequests.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('requests')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.options.legend.withPlacement('bottom')
      + g.panel.timeSeries.options.tooltip.withMode('none'),

    rejectedAsyncIORequests:
      g.panel.timeSeries.new('Rejected async I/O requests')
      + g.panel.timeSeries.panelOptions.withDescription('Number of async I/O requests that have been rejected for an IIS site.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.async_io.rejectedRequests.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('requests')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    trafficSent:
      g.panel.timeSeries.new('Traffic sent')
      + g.panel.timeSeries.panelOptions.withDescription('The traffic sent by an IIS site.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.data_transfer.bytesSent.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('Bps')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    trafficReceived:
      g.panel.timeSeries.new('Traffic received')
      + g.panel.timeSeries.panelOptions.withDescription('The traffic received by an IIS site.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.data_transfer.bytesReceived.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('Bps')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    filesSent:
      g.panel.timeSeries.new('Files sent')
      + g.panel.timeSeries.panelOptions.withDescription('The files sent by an IIS site.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.data_transfer.filesSent.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('files/s')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    filesReceived:
      g.panel.timeSeries.new('Files received')
      + g.panel.timeSeries.panelOptions.withDescription('The files received by an IIS site.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.data_transfer.filesReceived.asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('files/s')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    currentConnections:
      g.panel.timeSeries.new('Current connections')
      + g.panel.timeSeries.panelOptions.withDescription('The number of current connections to an IIS site.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.connections.currentConnections.asTarget(),
      ])
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    attemptedConnections:
      g.panel.timeSeries.new('Attempted connections')
      + g.panel.timeSeries.panelOptions.withDescription('The number of attempted connections to an IIS site.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.connections.connectionAttempts.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    // Server Cache Panels
    fileCacheHitRatio:
      g.panel.timeSeries.new('File cache hit ratio')
      + g.panel.timeSeries.panelOptions.withDescription('The current file cache hit ratio for an IIS server.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.server_cache.fileCacheHitRatio.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    uriCacheHitRatio:
      g.panel.timeSeries.new('URI cache hit ratio')
      + g.panel.timeSeries.panelOptions.withDescription('The current URI cache hit ratio for an IIS server.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.server_cache.uriCacheHitRatio.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    metadataCacheHitRatio:
      g.panel.timeSeries.new('Metadata cache hit ratio')
      + g.panel.timeSeries.panelOptions.withDescription('The current metadata cache hit ratio for an IIS server.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.server_cache.metadataCacheHitRatio.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    outputCacheHitRatio:
      g.panel.timeSeries.new('Output cache hit ratio')
      + g.panel.timeSeries.panelOptions.withDescription('The current output cache hit ratio for an IIS site.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.server_cache.outputCacheHitRatio.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    // Application Panels
    workerRequests:
      g.panel.timeSeries.new('Requests')
      + g.panel.timeSeries.panelOptions.withDescription('The HTTP request rate for an IIS application.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.worker_requests.requests.withExprWrappersMixin(['sum by(app, job, instance) (', ')'])
        .asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('reqps')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    workerRequestErrors:
      g.panel.timeSeries.new('Request errors')
      + g.panel.timeSeries.panelOptions.withDescription('Requests that have resulted in errors for an IIS application.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.worker_requests.requestErrors.withExprWrappersMixin(['sum by(app, instance, job, status_code) (', ')'])
        .asTarget(),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('reqps')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withStacking({ mode: 'normal' })
      + g.panel.timeSeries.options.legend.withPlacement('right'),

    websocketConnectionAttempts:
      g.panel.timeSeries.new('Websocket connection attempts')
      + g.panel.timeSeries.panelOptions.withDescription('The number of attempted websocket connections for an IIS application.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.worker_websocket.connectionAttempts.withExprWrappersMixin(['sum by(app, instance, job) (', ')'])
        .asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    websocketConnectionSuccessRate:
      g.panel.timeSeries.new('Websocket connection success rate')
      + g.panel.timeSeries.panelOptions.withDescription('The success rate of websocket connection attempts for an IIS application.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.worker_websocket.connectionSuccessRate.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    currentWorkerThreads:
      g.panel.timeSeries.new('Current worker threads')
      + g.panel.timeSeries.panelOptions.withDescription('The current number of worker threads processing requests for an IIS application.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.worker_threads.currentThreads.withExprWrappersMixin(['sum by(app, instance, job, state) (', ')'])
        .asTarget(),
      ])
      + g.panel.timeSeries.options.legend.withPlacement('right'),

    currentWorkerProcesses:
      g.panel.timeSeries.new('Current worker processes')
      + g.panel.timeSeries.panelOptions.withDescription('The current number of worker processes for an IIS application pool.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.app_pools.currentWorkerProcesses.withExprWrappersMixin(['sum by(app, instance, job) (', ')'])
        .asTarget(),
      ])
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    workerProcessFailures:
      g.panel.timeSeries.new('Worker process failures')
      + g.panel.timeSeries.panelOptions.withDescription('Total worker process failures for an IIS application pool.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.worker_processes.totalFailures.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.worker_processes.startupFailures.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.worker_processes.shutdownFailures.asTarget()
        + g.query.prometheus.withInterval('1m'),
        signals.worker_processes.pingFailures.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    workerFileCacheHitRatio:
      g.panel.timeSeries.new('Worker file cache hit ratio')
      + g.panel.timeSeries.panelOptions.withDescription('The current file cache hit ratio for an IIS worker process.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.worker_cache.fileCacheHitRatio.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    workerUriCacheHitRatio:
      g.panel.timeSeries.new('Worker URI cache hit ratio')
      + g.panel.timeSeries.panelOptions.withDescription('The current URI cache hit ratio for an IIS worker process.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.worker_cache.uriCacheHitRatio.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    workerMetadataCacheHitRatio:
      g.panel.timeSeries.new('Worker metadata cache hit ratio')
      + g.panel.timeSeries.panelOptions.withDescription('The current metadata cache hit ratio for an IIS worker process.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.worker_cache.metadataCacheHitRatio.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    workerOutputCacheHitRatio:
      g.panel.timeSeries.new('Worker output cache hit ratio')
      + g.panel.timeSeries.panelOptions.withDescription('The current output cache hit ratio for an IIS worker process.')
      + g.panel.timeSeries.queryOptions.withTargets([
        signals.worker_cache.outputCacheHitRatio.asTarget()
        + g.query.prometheus.withInterval('1m'),
      ])
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    // Logs panel
    accessLogs:
      g.panel.logs.new('Access logs')
      + g.panel.logs.panelOptions.withDescription('Recent access logs from access logs file for an IIS site.')
      + g.panel.logs.queryOptions.withTargets([
        g.query.loki.new(
          '${loki_datasource}',
          '{' + this.config.filteringSelector + ', site=~"$site"} |= ``'
        ),
      ])
      + g.panel.logs.options.withEnableLogDetails(true)
      + g.panel.logs.options.withShowCommonLabels(false)
      + g.panel.logs.options.withShowTime(false)
      + g.panel.logs.options.withWrapLogMessage(false),
  },
}
