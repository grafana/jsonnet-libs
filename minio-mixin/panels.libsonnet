local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this): {
    local signals = this.signals,
    local readApis = 'api=~"get.*|list.*|head.*"',

    // Overview
    storageUsedRatio:
      signals.storage.usedRatio.asGauge('Storage used')
      + g.panel.gauge.standardOptions.withMin(0)
      + g.panel.gauge.standardOptions.withMax(1)
      + g.panel.gauge.standardOptions.thresholds.withSteps([
        g.panel.gauge.thresholdStep.withColor('green') + g.panel.gauge.thresholdStep.withValue(null),
        g.panel.gauge.thresholdStep.withColor('red') + g.panel.gauge.thresholdStep.withValue(this.config.alertsWarningStorageUsed / 100),
      ]),
    disksTotal:
      signals.overview.disksTotal.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    disksOffline:
      signals.overview.disksOffline.asStat()
      + commonlib.panels.generic.stat.base.stylize()
      + g.panel.stat.standardOptions.thresholds.withSteps([
        g.panel.stat.thresholdStep.withColor('green') + g.panel.stat.thresholdStep.withValue(null),
        g.panel.stat.thresholdStep.withColor('red') + g.panel.stat.thresholdStep.withValue(1),
      ])
      + g.panel.stat.standardOptions.color.withMode('thresholds'),
    errors:
      signals.overview.errors.asTimeSeries()
      + commonlib.panels.requests.timeSeries.errors.stylize(),

    // Storage
    storageUsed:
      signals.storage.used.asTimeSeries()
      + commonlib.panels.disk.timeSeries.base.stylize(),
    storageAvailable:
      signals.storage.available.asTimeSeries()
      + commonlib.panels.disk.timeSeries.base.stylize(),
    storageTotal:
      signals.storage.total.asTimeSeries()
      + commonlib.panels.disk.timeSeries.base.stylize(),

    // Buckets
    bucketSize:
      signals.buckets.size.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    bucketObjects:
      signals.buckets.objects.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),
    bucketObjectsBySize:
      signals.buckets.objectsBySize.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize(),

    // Requests
    readRequests:
      signals.requests.requests.withFilteringSelectorMixin(readApis).asTimeSeries('Read requests')
      + commonlib.panels.requests.timeSeries.rate.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),
    writeRequests:
      signals.requests.requests.withFilteringSelectorMixin('api=~"put.*"').asTimeSeries('Write requests')
      + commonlib.panels.requests.timeSeries.rate.stylize()
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),
    deleteRequests:
      signals.requests.requests.withFilteringSelectorMixin('api=~"delete.*"').asTimeSeries('Delete requests')
      + commonlib.panels.requests.timeSeries.rate.stylize(),

    // Performance
    readLatency:
      signals.requests.ttfb.withFilteringSelectorMixin(readApis).withQuantile(0.99).asTimeSeries('Read latency')
      + signals.requests.ttfb.withFilteringSelectorMixin(readApis).withQuantile(0.50).asPanelMixin()
      + signals.requests.ttfbAverage.withFilteringSelectorMixin(readApis).asPanelMixin()
      + commonlib.panels.requests.timeSeries.duration.stylize(),
    internodeTraffic:
      signals.network.internodeRx.asTimeSeries('Internode traffic')
      + signals.network.internodeTx.asPanelMixin()
      + commonlib.panels.generic.timeSeries.base.stylize(),
  },
}
