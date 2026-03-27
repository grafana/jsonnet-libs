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
    indexByName: std.foldl(function(asc, opts)
      local field = opts.field;
      local idx = opts.idx;
      asc {
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
    value: 90,
  },
  {
    color: 'green',
    value: 95,
  },
];

local ratePanel = function(name, targets)
  commonlib.panels.generic.stat.base.new(name, targets, 'Per-signal rates of incoming data')
  + stat.options.withColorMode('background')
  + stat.panelOptions.withTransparent(true)
  + stat.queryOptions.withDatasource('prometheus', '${datasource}')
  + stat.queryOptions.withTargets(targets)
  + stat.standardOptions.withUnit('cps')
  + stat.standardOptions.withOverridesMixin(signalColorsOverrides());

local incomingByProcessorStyle =
  commonlib.panels.generic.timeSeries.base.stylize()
  + g.panel.timeSeries.options.withLegend({ calcs: [], displayMode: 'table', placement: 'right' });

{
  new(signals, process):: {
    // Without any data, this panel shows an error because the `joinByField` transforms fails on empty data
    // There is no way to work around this as of grafana 12.4.2
    fleetOverview:
      commonlib.panels.generic.table.base.new(
        'Fleet overview',
        targets=[
          process.signals.process.uptime.asTableTarget(),
          signals.exporter.saturationByCollector.asTableTarget(),
        ]
      )
      + commonlib.panels.generic.table.percentage.stylizeByName('Queue saturation')
      + g.panel.table.panelOptions.withDescription('List of collectors and their queue saturation')
      + g.panel.table.standardOptions.withUnit('s')
      + g.panel.table.queryOptions.withDatasource('prometheus', '${datasource}')
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
        + g.panel.table.fieldOverride.byRegexp.withProperty('color', { mode: 'thresholds' }),
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
      + commonlib.panels.generic.stat.base.stylize(),
    processorCount:
      signals.processor.count.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
    exporterCount:
      signals.exporter.count.asStat()
      + commonlib.panels.generic.stat.base.stylize(),
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
      + commonlib.panels.generic.stat.percentage.stylize()
      + g.panel.gauge.standardOptions.color.withMode('thresholds')
      + g.panel.gauge.standardOptions.thresholds.withSteps(gaugeHighValuesGreen),
    logsReceiverSuccessRate:
      signals.receiver.logsSuccessRate.asGauge()
      + commonlib.panels.generic.stat.percentage.stylize()
      + g.panel.gauge.standardOptions.color.withMode('thresholds')
      + g.panel.gauge.standardOptions.thresholds.withSteps(gaugeHighValuesGreen),
    spansReceiverSuccessRate:
      signals.receiver.spansSuccessRate.asGauge()
      + commonlib.panels.generic.stat.percentage.stylize()
      + g.panel.gauge.standardOptions.color.withMode('thresholds')
      + g.panel.gauge.standardOptions.thresholds.withSteps(gaugeHighValuesGreen),
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
      commonlib.panels.generic.table.base.new(
        'Processors',
        targets=[
          // need to use separate queries here as the table transformations can't
          // group them in the way we want
          signals.processor.incomingMetricsByProcessor.asTarget(),
          signals.processor.incomingLogsByProcessor.asTarget(),
          signals.processor.incomingTracesByProcessor.asTarget(),
          signals.processor.outgoingMetricsByProcessor.asTarget(),
          signals.processor.outgoingLogsByProcessor.asTarget(),
          signals.processor.outgoingTracesByProcessor.asTarget(),
        ]
      )
      + g.panel.table.panelOptions.withDescription('Processing rate breakdown by receiver')
      + g.panel.table.queryOptions.withDatasource('prometheus', '${datasource}')
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
      + commonlib.panels.generic.stat.base.stylize()
      + stat.standardOptions.color.withMode('fixed')
      + stat.standardOptions.color.withFixedColor(signalColors.metrics),
    logsExporterStat:
      signals.exporter.logs.asStat()
      + commonlib.panels.generic.stat.base.stylize()
      + stat.standardOptions.color.withMode('fixed')
      + stat.standardOptions.color.withFixedColor(signalColors.logs),
    spansExporterStat:
      signals.exporter.spans.asStat()
      + commonlib.panels.generic.stat.base.stylize()
      + stat.standardOptions.color.withMode('fixed')
      + stat.standardOptions.color.withFixedColor(signalColors.spans),
    metricsExporterSuccessRate:
      signals.exporter.metricsSuccessRate.asGauge()
      + commonlib.panels.generic.stat.percentage.stylize()
      + g.panel.gauge.standardOptions.color.withMode('thresholds')
      + g.panel.gauge.standardOptions.thresholds.withSteps(gaugeHighValuesGreen),
    logsExporterSuccessRate:
      signals.exporter.logsSuccessRate.asGauge()
      + commonlib.panels.generic.stat.percentage.stylize()
      + g.panel.gauge.standardOptions.color.withMode('thresholds')
      + g.panel.gauge.standardOptions.thresholds.withSteps(gaugeHighValuesGreen),
    spansExporterSuccessRate:
      signals.exporter.spansSuccessRate.asGauge()
      + commonlib.panels.generic.stat.percentage.stylize()
      + g.panel.gauge.standardOptions.color.withMode('thresholds')
      + g.panel.gauge.standardOptions.thresholds.withSteps(gaugeHighValuesGreen),
    exportingRate: ratePanel('Exporting rate', [
      signals.exporter.metrics.asTarget(),
      signals.exporter.logs.asTarget(),
      signals.exporter.spans.asTarget(),
    ]),
    exporterOverview:
      commonlib.panels.generic.table.base.new(
        'Exporters',
        description='Exporting rate breakdown by exporter',
        targets=[
          signals.exporter.metricsByExporter.asTarget(),
          signals.exporter.metricsFailedByExporter.asTarget(),
          signals.exporter.logsByExporter.asTarget(),
          signals.exporter.logsFailedByExporter.asTarget(),
          signals.exporter.spansByExporter.asTarget(),
          signals.exporter.spansFailedByExporter.asTarget(),

        ]
      )
      + g.panel.table.queryOptions.withDatasource('prometheus', '${datasource}')
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
      commonlib.panels.generic.table.base.new(
        'Queue size',
        description=|||
          **Note: This table only makes sense when selecting a single collector as queue sizes may differ**
          Shows metrics of the internal [sending queue](https://github.com/open-telemetry/opentelemetry-collector/blob/main/exporter/exporterhelper/README.md) per exporter
        |||,
        targets=[
          signals.exporter.queueSizeByExporter.asTarget(),
          signals.exporter.queueCapacityByExporter.asTarget(),
          signals.exporter.enqueueMetricsFailedByExporter.asTarget(),
          signals.exporter.enqueueLogsFailedByExporter.asTarget(),
          signals.exporter.enqueueSpansFailedByExporter.asTarget(),
        ],
      )
      + g.panel.table.queryOptions.withDatasource('prometheus', '${datasource}')
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
