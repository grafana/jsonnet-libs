local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

local stat = g.panel.stat;

local tableTimeSeriesTransforms = [
  {
    id: 'timeSeriesTable',
    options: {},
  },
  {
    id: 'merge',
    options: {},
  },
  {
    id: 'renameByRegex',
    options: {
      regex: 'Trend #(.*)',
      renamePattern: '$1',
    },
  },
];

local signalColors = {
  metrics: 'purple',
  logs: 'yellow',
  spans: 'blue',
};

local signalColorsOverrides = function(prefix='') [
  stat.fieldOverride.byRegexp.new('/.*%s[Mm]etrics.*/' % [prefix])
  + stat.fieldOverride.byRegexp.withProperty(
    'color',
    { mode: 'fixed', fixedColor: signalColors.metrics }
  ),
  stat.fieldOverride.byRegexp.new('/.*%s[Ll]ogs.*/' % [prefix])
  + stat.fieldOverride.byRegexp.withProperty(
    'color',
    { mode: 'fixed', fixedColor: signalColors.logs }
  ),
  stat.fieldOverride.byRegexp.new('/.*%s([Tt]races|[Ss]pans).*/' % [prefix])
  + stat.fieldOverride.byRegexp.withProperty(
    'color',
    { mode: 'fixed', fixedColor: signalColors.spans }
  ),
];

local orderFields = function(fields) {
  id: 'organize',
  options: {
    excludeByName: {},
    indexByName: std.foldl(function(acc, opts)
      local field = opts.field;
      local idx = opts.idx;
      acc {
        [field]: idx,
      }, std.mapWithIndex(function(idx, field) { field: field, idx: idx }, fields), {}),
  },
};

local gaugeHighValuesGreen = [
  {
    color: 'red',
    value: null,
  },
  {
    color: 'yellow',
    value: 0.9,
  },
  {
    color: 'green',
    value: 0.95,
  },
];

local percentGauge = function(steps)
  g.panel.gauge.standardOptions.withMin(0)
  + g.panel.gauge.standardOptions.withMax(1)
  + g.panel.gauge.standardOptions.thresholds.withMode('absolute')
  + g.panel.gauge.standardOptions.thresholds.withSteps(steps);

local ratePanel = function(name, targets)
  stat.new(name)
  + stat.panelOptions.withDescription('Per-signal rates of incoming data')
  + stat.options.withColorMode('background')
  + stat.panelOptions.withTransparent(true)
  + stat.queryOptions.withDatasource('prometheus', '${datasource}')
  + stat.queryOptions.withTargets(targets)
  + stat.standardOptions.withUnit('cps')
  + stat.standardOptions.withOverridesMixin(signalColorsOverrides());

local incomingByProcessorStyle =
  g.panel.timeSeries.options.withLegend({ calcs: [], displayMode: 'table', placement: 'right' })
  + g.panel.timeSeries.options.tooltip.withMode('multi')
  + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode('opacity')
  + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(80)
  + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal');

{
  new(signals, process):: {
    fleetOverview:
      g.panel.table.new('Fleet overview')
      + g.panel.table.panelOptions.withDescription('List of collectors and their queue saturation')
      + g.panel.table.standardOptions.withUnit('s')
      + g.panel.table.queryOptions.withDatasource('prometheus', '${datasource}')
      + g.panel.table.queryOptions.withTargets([
        process.signals.process.uptime.asTableTarget(),
        signals.exporter.saturationByCollector.asTableTarget(),
      ])
      + g.panel.table.standardOptions.thresholds.withMode('absolute')
      + g.panel.table.standardOptions.thresholds.withSteps([
        {
          value: null,
          color: 'green',
        },
        { value: 0.25, color: 'yellow' },
        { value: 0.5, color: 'red' },
      ])
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('Queue saturation')
        + g.panel.table.fieldOverride.byRegexp.withProperty(
          'custom.cellOptions',
          {
            type: 'gauge',
            mode: 'lcd',
          }
        )
        + g.panel.table.fieldOverride.byRegexp.withProperty(
          'unit',
          'percentunit'
        )
        + g.panel.table.fieldOverride.byRegexp.withProperty('min', 0)
        + g.panel.table.fieldOverride.byRegexp.withProperty('max', 1),
      ])
      + g.panel.table.queryOptions.withTransformationsMixin([
        g.panel.table.queryOptions.transformation.withId('joinByField')
        + g.panel.table.queryOptions.transformation.withOptions({
          byField: 'service_instance_id',
          mode: 'inner',
        }),
        g.panel.table.queryOptions.transformation.withId('renameByRegex')
        + g.panel.table.queryOptions.transformation.withOptions({
          regex: 'Value #(.*)',
          renamePattern: '$1',
        }),
        g.panel.table.queryOptions.transformation.withId('organize')
        + g.panel.table.queryOptions.transformation.withOptions({
          excludeByName: {},
          indexByName: {},
          renameByName: {
            service_instance_id: 'Instance ID',
            service_name: 'Name',
            service_version: 'Version',
          },
          includeByName: {
            service_instance_id: true,
            service_name: true,
            service_version: true,
            Uptime: true,
            'Queue saturation': true,
          },
        }),
      ]),
    alertList:
      g.panel.alertList.new('OpenTelemetry collector alerts')
      + g.panel.alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter('collector_distro_name!=""')
      + g.panel.alertList.options.UnifiedAlertListOptions.withDatasource('-- Grafana --'),
    receiverOverview:
      signals.receiver.metricsByReceiver.asTable(name='Receivers', format='time_series')
      + g.panel.table.queryOptions.withDatasource('prometheus', '${datasource}')
      + g.panel.table.panelOptions.withDescription('Ingestion rate breakdown by receiver')
      + signals.receiver.metricsRefusalByReceiver.asTableColumn(format='time_series')
      + signals.receiver.logsByReceiver.asTableColumn(format='time_series')
      + signals.receiver.logsRefusalByReceiver.asTableColumn(format='time_series')
      + signals.receiver.spansByReceiver.asTableColumn(format='time_series')
      + signals.receiver.spansRefusalByReceiver.asTableColumn(format='time_series')
      + g.panel.table.fieldConfig.defaults.custom.withCellOptionsMixin({
        type: 'sparkline',
      })
      + g.panel.table.standardOptions.withNoValue('0')
      + g.panel.table.standardOptions.withOverridesMixin(signalColorsOverrides('Ingested ') + [
        g.panel.table.fieldOverride.byName.new('receiver')
        + g.panel.table.fieldOverride.byRegexp.withProperty(
          'custom.cellOptions',
          { type: 'basic' }
        ),
        g.panel.table.fieldOverride.byRegexp.new('/.*refusal.*/')
        + g.panel.table.fieldOverride.byRegexp.withProperty(
          'color',
          { mode: 'fixed', fixedColor: 'red' }
        ),
      ]),

    ingestionRate: ratePanel('Ingestion statistics', [
      signals.receiver.metrics.asTarget(),
      signals.receiver.logs.asTarget(),
      signals.receiver.spans.asTarget(),
    ]),
    receiverCount:
      signals.receiver.count.asStat()
      + stat.options.withColorMode('background'),
    processorCount:
      signals.processor.count.asStat()
      + stat.options.withColorMode('background'),
    exporterCount:
      signals.exporter.count.asStat()
      + stat.options.withColorMode('background'),
    metricsReceiverStat:
      signals.receiver.metrics.asStat()
      + stat.standardOptions.color.withMode('fixed')
      + stat.standardOptions.color.withFixedColor(signalColors.metrics),
    logsReceiverStat:
      signals.receiver.logs.asStat()
      + stat.standardOptions.color.withMode('fixed')
      + stat.standardOptions.color.withFixedColor(signalColors.logs),
    spansReceiverStat:
      signals.receiver.spans.asStat(name='Spans')
      + stat.standardOptions.color.withMode('fixed')
      + stat.standardOptions.color.withFixedColor(signalColors.spans),
    metricsReceiverSuccessRate:
      signals.receiver.metricsSuccessRate.asGauge()
      + percentGauge(gaugeHighValuesGreen),
    logsReceiverSuccessRate:
      signals.receiver.logsSuccessRate.asGauge()
      + percentGauge(gaugeHighValuesGreen),
    spansReceiverSuccessRate:
      signals.receiver.spansSuccessRate.asGauge()
      + percentGauge(gaugeHighValuesGreen),
    downArrow:
      g.panel.text.new('')
      + g.panel.text.panelOptions.withTransparent(true)
      + g.panel.text.options.withContent(|||
        <div style="display: flex; justify-content: space-around; width: 100%; font-size: 2em; font-weight: bold">
          <span>↓</span>
          <span>↓</span>
          <span>↓</span>
          <span>↓</span>
          <span>↓</span>
        </div>
      |||),
    metricsByProcessor:
      signals.processor.incomingMetricsByProcessor.asTimeSeries()
      + incomingByProcessorStyle,
    logsByProcessor:
      signals.processor.incomingLogsByProcessor.asTimeSeries()
      + incomingByProcessorStyle,
    spansByProcessor:
      signals.processor.incomingTracesByProcessor.asTimeSeries()
      + incomingByProcessorStyle,
    processingRate: ratePanel('Processing rate', [
      signals.processor.metrics.asTarget(),
      signals.processor.logs.asTarget(),
      signals.processor.spans.asTarget(),
    ]),
    processorOverview:
      g.panel.table.new('Processors')
      + g.panel.table.panelOptions.withDescription('Processing rate breakdown by receiver')
      + g.panel.table.queryOptions.withDatasource('prometheus', '${datasource}')
      + g.panel.table.queryOptions.withTargets([
        // need to use separate queries here as the table transformations can't
        // group them in the way we want
        signals.processor.incomingMetricsByProcessor.asTarget(),
        signals.processor.incomingLogsByProcessor.asTarget(),
        signals.processor.incomingTracesByProcessor.asTarget(),
        signals.processor.outgoingMetricsByProcessor.asTarget(),
        signals.processor.outgoingLogsByProcessor.asTarget(),
        signals.processor.outgoingTracesByProcessor.asTarget(),
      ])
      + g.panel.table.fieldConfig.defaults.custom.withCellOptionsMixin({
        type: 'sparkline',
      })
      + g.panel.table.standardOptions.withUnit('cps')
      + g.panel.table.queryOptions.withTransformations(tableTimeSeriesTransforms + [
        orderFields(['processor', 'Incoming metrics', 'Outgoing metrics', 'Incoming logs', 'Outgoing logs']),
      ])
      + g.panel.table.standardOptions.withOverridesMixin(signalColorsOverrides() + [
        g.panel.table.fieldOverride.byName.new('processor')
        + g.panel.table.fieldOverride.byName.withProperty(
          'custom.cellOptions',
          { type: 'basic' }
        ),
        g.panel.table.fieldOverride.byRegexp.new('/.*refusal.*/')
        + g.panel.table.fieldOverride.byRegexp.withProperty(
          'color',
          { mode: 'fixed', fixedColor: 'red' }
        ),
      ]),

    metricsExporterStat:
      signals.exporter.metrics.asStat()
      + stat.standardOptions.color.withMode('fixed')
      + stat.standardOptions.color.withFixedColor(signalColors.metrics),
    logsExporterStat:
      signals.exporter.logs.asStat()
      + stat.standardOptions.color.withMode('fixed')
      + stat.standardOptions.color.withFixedColor(signalColors.logs),
    spansExporterStat:
      signals.exporter.spans.asStat()
      + stat.standardOptions.color.withMode('fixed')
      + stat.standardOptions.color.withFixedColor(signalColors.spans),
    metricsExporterSuccessRate:
      signals.exporter.metricsSuccessRate.asGauge()
      + percentGauge(gaugeHighValuesGreen),
    logsExporterSuccessRate:
      signals.exporter.logsSuccessRate.asGauge()
      + percentGauge(gaugeHighValuesGreen),
    spansExporterSuccessRate:
      signals.exporter.spansSuccessRate.asGauge()
      + percentGauge(gaugeHighValuesGreen),
    exportingRate: ratePanel('Exporting rate', [
      signals.exporter.metrics.asTarget(),
      signals.exporter.logs.asTarget(),
      signals.exporter.spans.asTarget(),
    ]),
    exporterOverview:
      g.panel.table.new('Exporters')
      + g.panel.table.panelOptions.withDescription('Exporting rate breakdown by exporter')
      + g.panel.table.queryOptions.withDatasource('prometheus', '${datasource}')
      + g.panel.table.queryOptions.withTargets([
        signals.exporter.metricsByExporter.asTarget(),
        signals.exporter.metricsFailedByExporter.asTarget(),
        signals.exporter.logsByExporter.asTarget(),
        signals.exporter.logsFailedByExporter.asTarget(),
        signals.exporter.spansByExporter.asTarget(),
        signals.exporter.spansFailedByExporter.asTarget(),
      ])
      + g.panel.table.fieldConfig.defaults.custom.withCellOptionsMixin({
        type: 'sparkline',
      })
      + g.panel.table.standardOptions.withUnit('cps')
      + g.panel.table.standardOptions.withNoValue('0')
      + g.panel.table.queryOptions.withTransformations(tableTimeSeriesTransforms)
      + g.panel.table.standardOptions.withOverridesMixin(signalColorsOverrides() + [
        g.panel.table.fieldOverride.byName.new('exporter')
        + g.panel.table.fieldOverride.byName.withProperty(
          'custom.cellOptions',
          { type: 'basic' }
        ),
        g.panel.table.fieldOverride.byRegexp.new('/failure/')
        + g.panel.table.fieldOverride.byRegexp.withProperty(
          'color',
          { mode: 'fixed', fixedColor: 'red' }
        ),
      ]),
    exporterQueueSize:
      g.panel.table.new('Queue Size')
      + g.panel.table.panelOptions.withDescription(|||
        **Note: This table only makes sense when selecting a single collector as queue sizes may differ**
        Shows metrics of the internal [sending queue](https://github.com/open-telemetry/opentelemetry-collector/blob/main/exporter/exporterhelper/README.md) per exporter
      |||)
      + g.panel.table.queryOptions.withDatasource('prometheus', '${datasource}')
      + g.panel.table.queryOptions.withTargets([
        signals.exporter.queueSizeByExporter.asTarget(),
        signals.exporter.queueCapacityByExporter.asTarget(),
        signals.exporter.enqueueMetricsFailedByExporter.asTarget(),
        signals.exporter.enqueueLogsFailedByExporter.asTarget(),
        signals.exporter.enqueueSpansFailedByExporter.asTarget(),
      ])
      + g.panel.table.fieldConfig.defaults.custom.withCellOptionsMixin({
        type: 'sparkline',
      })
      + g.panel.table.standardOptions.withUnit('short')
      + g.panel.table.standardOptions.withNoValue('0')
      + g.panel.table.queryOptions.withTransformations(tableTimeSeriesTransforms)
      + g.panel.table.standardOptions.color.withMode('palette-classic')
      + g.panel.table.standardOptions.withOverridesMixin([
        g.panel.table.fieldOverride.byName.new('exporter')
        + g.panel.table.fieldOverride.byName.withProperty(
          'custom.cellOptions',
          { type: 'basic' }
        ),
        g.panel.table.fieldOverride.byRegexp.new('/.*failures.*/')
        + g.panel.table.fieldOverride.byRegexp.withProperty(
          'color',
          { mode: 'fixed', fixedColor: 'red' }
        ),
      ]),
  },
}
