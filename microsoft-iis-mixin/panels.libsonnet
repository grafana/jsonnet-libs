local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this): {
    local signals = this.signals,

    // Overview - Requests
    requests:
      commonlib.panels.requests.timeSeries.base.new(
        'Requests',
        targets=[signals.overview.requests.asTarget()]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The request rate split by HTTP Method for an IIS site')
      + g.panel.timeSeries.standardOptions.withUnit('reqps')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true),

    requestErrors:
      commonlib.panels.requests.timeSeries.errors.new(
        'Request errors',
        targets=[
          signals.overview.lockedErrors.asTarget(),
          signals.overview.notFoundErrors.asTarget(),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('Requests that have resulted in errors for an IIS site.')
      + g.panel.timeSeries.standardOptions.withUnit('errors/sec')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withAsTable(true),

    blockedAsyncIORequests:
      commonlib.panels.generic.timeSeries.base.new(
        'Blocked async I/O requests',
        targets=[
          signals.overview.blockedAsyncIORequests.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('Number of async I/O requests that are currently queued for an IIS site.')
      + g.panel.timeSeries.standardOptions.withUnit('requests')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    rejectedAsyncIORequests:
      commonlib.panels.network.timeSeries.base.new(
        'Rejected async I/O requests',
        targets=[
          signals.overview.rejectedAsyncIORequests.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('Number of async I/O requests that have been rejected for an IIS site.')
      + g.panel.timeSeries.standardOptions.withUnit('requests')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    trafficSent:
      commonlib.panels.network.timeSeries.traffic.new(
        'Traffic sent',
        targets=[signals.overview.bytesSent.asTarget()]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The traffic sent by an IIS site.')
      + g.panel.timeSeries.standardOptions.withUnit('Bps')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    trafficReceived:
      commonlib.panels.network.timeSeries.traffic.new(
        'Traffic received',
        targets=[signals.overview.bytesReceived.asTarget()]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The traffic received by an IIS site.')
      + g.panel.timeSeries.standardOptions.withUnit('Bps')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    filesSent:
      commonlib.panels.generic.timeSeries.base.new(
        'Files sent',
        targets=[
          signals.overview.filesSent.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The files sent by an IIS site.')
      + g.panel.timeSeries.standardOptions.withUnit('files')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    filesReceived:
      commonlib.panels.generic.timeSeries.base.new(
        'Files received',
        targets=[
          signals.overview.filesReceived.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The files received by an IIS site.')
      + g.panel.timeSeries.standardOptions.withUnit('files')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    currentConnections:
      commonlib.panels.network.timeSeries.base.new(
        'Current connections',
        targets=[
          signals.overview.currentConnections.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The number of current connections to an IIS site.')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    attemptedConnections:
      commonlib.panels.network.timeSeries.base.new(
        'Attempted connections',
        targets=[
          signals.overview.connectionAttempts.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The number of attempted connections to an IIS site.')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    // Server Cache Panels
    fileCacheHitRatio:
      commonlib.panels.generic.timeSeries.base.new(
        'File cache hit ratio',
        targets=[
          signals.overview.fileCacheHitRatio.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The current file cache hit ratio for an IIS server.')
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    uriCacheHitRatio:
      commonlib.panels.generic.timeSeries.base.new(
        'URI cache hit ratio',
        targets=[
          signals.overview.uriCacheHitRatio.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The current URI cache hit ratio for an IIS server.')
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    metadataCacheHitRatio:
      commonlib.panels.generic.timeSeries.base.new(
        'Metadata cache hit ratio',
        targets=[
          signals.overview.metadataCacheHitRatio.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The current metadata cache hit ratio for an IIS server.')
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    outputCacheHitRatio:
      commonlib.panels.generic.timeSeries.base.new(
        'Output cache hit ratio',
        targets=[
          signals.overview.outputCacheHitRatio.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The current output cache hit ratio for an IIS site.')
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    // Application Panels
    workerRequests:
      commonlib.panels.requests.timeSeries.rate.new(
        'Requests',
        targets=[
          signals.applications.workerRequests.withExprWrappersMixin(['sum by(app, job, instance) (', ')'])
          .asTarget(),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The HTTP request rate for an IIS application.')
      + g.panel.timeSeries.standardOptions.withUnit('reqps')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    workerRequestErrors:
      commonlib.panels.requests.timeSeries.errors.new(
        'Request errors',
        targets=[
          signals.applications.workerRequestErrors.withExprWrappersMixin(['sum by(app, instance, job, status_code) (', ')'])
          .asTarget(),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('Requests that have resulted in errors for an IIS application.')
      + g.panel.timeSeries.standardOptions.withUnit('reqps')
      + g.panel.timeSeries.fieldConfig.defaults.custom.withStacking({ mode: 'normal' })
      + g.panel.timeSeries.options.legend.withPlacement('right'),

    websocketConnectionAttempts:
      commonlib.panels.network.timeSeries.base.new(
        'Websocket connection attempts',
        targets=[
          signals.applications.websocketConnectionAttempts.withExprWrappersMixin(['sum by(app, instance, job) (', ')'])
          .asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The number of attempted websocket connections for an IIS application.')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    websocketConnectionSuccessRate:
      commonlib.panels.generic.timeSeries.base.new(
        'Websocket connection success rate',
        targets=[
          signals.applications.websocketConnectionSuccessRate.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The success rate of websocket connection attempts for an IIS application.')
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    currentWorkerThreads:
      commonlib.panels.generic.timeSeries.base.new(
        'Current worker threads',
        targets=[
          signals.applications.currentWorkerThreads.asTarget(),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The current number of worker threads processing requests for an IIS application.'),

    workerThreadPoolUtilization:
      commonlib.panels.generic.timeSeries.base.new(
        'Thread pool utilization',
        targets=[
          signals.applications.threadPoolUtilization.asTarget(),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The current application thread pool utilization for an IIS application.')
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    currentWorkerProcesses:
      commonlib.panels.generic.timeSeries.base.new(
        'Current worker processes',
        targets=[
          signals.applications.currentWorkerProcesses.withExprWrappersMixin(['sum by(app, instance, job) (', ')'])
          .asTarget(),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The current number of worker processes processing requests for an IIS application.')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    workerProcessFailures:
      commonlib.panels.generic.timeSeries.base.new(
        'Worker process failures',
        targets=[
          signals.applications.totalWorkerProcessFailures.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The number of worker process failures for an IIS application.')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    workerProcessStartupFailures:
      commonlib.panels.generic.timeSeries.base.new(
        'Worker process startup failures',
        targets=[
          signals.applications.workerProcessStartupFailures.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The number of worker process startup failures for an IIS application.')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    workerProcessShutdownFailures:
      commonlib.panels.generic.timeSeries.base.new(
        'Worker process shutdown failures',
        targets=[
          signals.applications.workerProcessShutdownFailures.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The number of worker process shutdown failures for an IIS application.')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    workerProcessPingFailures:
      commonlib.panels.generic.timeSeries.base.new(
        'Worker process ping failures',
        targets=[
          signals.applications.workerProcessPingFailures.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The number of worker process ping failures for an IIS application.')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    workerFileCacheHitRatio:
      commonlib.panels.generic.timeSeries.base.new(
        'Worker file cache hit ratio',
        targets=[
          signals.applications.workerFileCacheHitRatio.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The current file cache hit ratio for an IIS application.')
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    workerUriCacheHitRatio:
      commonlib.panels.generic.timeSeries.base.new(
        'Worker URI cache hit ratio',
        targets=[
          signals.applications.workerUriCacheHitRatio.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The current URI cache hit ratio for an IIS application.')
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    workerMetadataCacheHitRatio:
      commonlib.panels.generic.timeSeries.base.new(
        'Worker metadata cache hit ratio',
        targets=[
          signals.applications.workerMetadataCacheHitRatio.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The current metadata cache hit ratio for an IIS site.')
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),

    workerOutputCacheHitRatio:
      commonlib.panels.generic.timeSeries.base.new(
        'Worker output cache hit ratio',
        targets=[
          signals.applications.workerOutputCacheHitRatio.asTarget()
          + g.query.prometheus.withInterval('2m'),
        ]
      )
      + g.panel.timeSeries.panelOptions.withDescription('The current output cache hit ratio for an IIS application.')
      + g.panel.timeSeries.standardOptions.withUnit('percent')
      + g.panel.timeSeries.options.legend.withPlacement('bottom'),
  },
}
