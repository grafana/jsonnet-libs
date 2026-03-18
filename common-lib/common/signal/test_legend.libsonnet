// Tests for legend generation: wrapLegend(), aggLegend, keepLabelsLegend,
// legendBase, and the effect of aggLevel, aggKeepLabels, and legendCustomTemplate.
local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local init = signal.init(
  filteringSelector=['job="abc"'],
  interval='5m',
  groupLabels=['job'],
  instanceLabels=['instance'],
  aggFunction='avg',
);

{
  legendGroupLevel: {
    local s = init { aggLevel:: 'group' }.addSignal(
      name='CPU total',
      nameShort='CPU',
      type='gauge',
      unit='percent',
      description='CPU.',
      sourceMaps=[{ expr: 'cpu{%(queriesSelector)s}', rangeFunction: null, aggKeepLabels: [], legendCustomTemplate: null, infoLabel: null }],
    ),
    testResult: test.suite({
      testLegendFormat: {
        actual: s.asTarget().legendFormat,
        expect: '{{job}}: CPU',
      },
    }),
  },

  legendInstanceLevel: {
    local s = init { aggLevel:: 'instance' }.addSignal(
      name='Requests',
      nameShort='Req',
      type='counter',
      unit='rps',
      description='Request rate.',
      sourceMaps=[{ expr: 'requests{%(queriesSelector)s}', rangeFunction: 'rate', aggKeepLabels: [], legendCustomTemplate: null, infoLabel: null }],
    ),
    testResult: test.suite({
      testLegendFormat: {
        actual: s.asTarget().legendFormat,
        expect: '{{instance}}: Req',
      },
    }),
  },

  legendNoneLevel: {
    local s = init { aggLevel:: 'none' }.addSignal(
      name='Up',
      nameShort='Up',
      type='gauge',
      unit='short',
      description='Up.',
      sourceMaps=[{ expr: 'up{%(queriesSelector)s}', rangeFunction: null, aggKeepLabels: [], legendCustomTemplate: null, infoLabel: null }],
    ),
    testResult: test.suite({
      testLegendFormat: {
        actual: s.asTarget().legendFormat,
        expect: '{{instance}}: Up',
      },
    }),
  },

  legendWithAggKeepLabels: {
    local s = init { aggLevel:: 'group' }.addSignal(
      name='Latency by handler',
      nameShort='Latency',
      type='counter',
      unit='seconds',
      description='Latency.',
      sourceMaps=[{
        expr: 'http_request_duration_seconds{%(queriesSelector)s}',
        rangeFunction: 'rate',
        aggKeepLabels: ['handler'],
        legendCustomTemplate: null,
        infoLabel: null,
      }],
    ),
    testResult: test.suite({
      testLegendFormat: {
        actual: s.asTarget().legendFormat,
        expect: '{{job}}: Latency ({{handler}})',
      },
    }),
  },

  legendWithMultipleAggKeepLabels: {
    local s = init { aggLevel:: 'instance' }.addSignal(
      name='Traffic',
      nameShort='Tx',
      type='counter',
      unit='Bps',
      description='Traffic.',
      sourceMaps=[{
        expr: 'traffic_bytes{%(queriesSelector)s}',
        rangeFunction: 'rate',
        aggKeepLabels: ['direction', 'protocol'],
        legendCustomTemplate: null,
        infoLabel: null,
      }],
    ),
    testResult: test.suite({
      testLegendFormat: {
        actual: s.asTarget().legendFormat,
        expect: '{{instance}}: Tx ({{direction}} {{protocol}})',
      },
    }),
  },

  legendCustomTemplate: {
    local s = init { aggLevel:: 'group' }.addSignal(
      name='Custom',
      nameShort='C',
      type='gauge',
      unit='short',
      description='Custom.',
      sourceMaps=[{
        expr: 'up{%(queriesSelector)s}',
        rangeFunction: null,
        aggKeepLabels: [],
        legendCustomTemplate: '{{job}} / {{instance}}: custom series',
        infoLabel: null,
      }],
    ),
    testResult: test.suite({
      testLegendFormat: {
        actual: s.asTarget().legendFormat,
        expect: '{{job}} / {{instance}}: custom series',
      },
    }),
  },

  legendAggKeepLabelsLevel: {
    // aggLevel 'aggKeepLabels' -> no agg prefix, only nameShort and optional keepLabels suffix
    local s = init { aggLevel:: 'aggKeepLabels' }.addSignal(
      name='By path',
      nameShort='Path',
      type='gauge',
      unit='short',
      description='By path.',
      sourceMaps=[{
        expr: 'by_path{%(queriesSelector)s}',
        rangeFunction: null,
        aggKeepLabels: ['path'],
        legendCustomTemplate: null,
        infoLabel: null,
      }],
    ),
    testResult: test.suite({
      testLegendFormat: {
        actual: s.asTarget().legendFormat,
        expect: 'Path ({{path}})',
      },
    }),
  },

  legendHideNameInLegend: {
    local s = init { aggLevel:: 'instance' }.addSignal(
      name='Hidden name',
      nameShort='Visible',
      type='gauge',
      unit='short',
      description='Desc.',
      sourceMaps=[{ expr: 'up{%(queriesSelector)s}', rangeFunction: null, aggKeepLabels: [], legendCustomTemplate: null, infoLabel: null }],
    ).withHideNameInLegend(true),
    testResult: test.suite({
      testLegendFormat: {
        actual: s.asTarget().legendFormat,
        expect: '{{instance}}',
      },
    }),
  },
}
