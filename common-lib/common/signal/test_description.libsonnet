// Tests for description rendering: wrapDescription(), renderDescription(), and
// _descriptionsAccumulator behaviour for table columns, panel mixins, and common().
local signal = import './signal.libsonnet';
local test = import 'jsonnetunit/test.libsonnet';

local init = signal.init(
  filteringSelector=['job="abc"'],
  interval='5m',
  aggLevel='instance',
  aggFunction='max',
);

local signal1 = init.addSignal(
  name='CPU usage',
  nameShort='CPU',
  type='counter',
  unit='percent',
  description='CPU usage across instances.',
  sourceMaps=[
    {
      expr: 'cpu_usage{%(queriesSelector)s}',
      rangeFunction: 'rate',
      aggKeepLabels: [],
      legendCustomTemplate: null,
      infoLabel: null,
    },
  ],
);

local signal2 = init.addSignal(
  name='Memory usage',
  nameShort='Memory',
  type='gauge',
  unit='bytes',
  description='Memory usage.',
  sourceMaps=[
    {
      expr: 'memory_usage{%(queriesSelector)s}',
      rangeFunction: 'rate',
      aggKeepLabels: [],
      legendCustomTemplate: null,
      infoLabel: null,
    },
  ],
);

{
  wrapDescriptionFormat: {
    testResult: test.suite({
      testWrappedFormat: {
        actual: signal1.wrapDescription(),
        expect: 'CPU (max): CPU usage across instances.',
      },
      testWrappedFormatDifferentAgg: {
        actual: signal1.withAggFunction('avg').wrapDescription(),
        expect: 'CPU (avg): CPU usage across instances.',
      },
    }),
  },

  singleDescriptionTableColumn: {
    local raw = signal1.asTableColumn(),
    testResult: test.suite({
      testDescriptionHasTrailingNewline: {
        actual: raw.description,
        expect: 'CPU (max): CPU usage across instances.  \n',
      },
      testDescriptionSingleEntry: {
        actual: std.length(raw._descriptionsAccumulator),
        expect: 1,
      },
    }),
  },

  singleDescriptionTimeSeries: {
    local raw = signal1.asTimeSeries(),
    testResult: test.suite({
      testDescriptionFromCommon: {
        actual: raw.description,
        expect: 'CPU usage across instances.',
      },
    }),
  },

  multipleDescriptionsPanelMixin: {
    // Panel gets first signal's common() then second signal's asPanelMixin(),
    // so _descriptionsAccumulator has two entries and renderDescription() joins them.
    local panel = signal1.asTimeSeries() + signal2.asPanelMixin(),
    testResult: test.suite({
      testDescriptionJoinedWithDoubleNewline: {
        actual: panel.description,
        expect: 'CPU (max): CPU usage across instances.  \n\nMemory (max): Memory usage.',
      },
      testAccumulatorHasTwoEntries: {
        actual: std.length(panel._descriptionsAccumulator),
        expect: 2,
      },
    }),
  },

  tableSingleColumnDescription: {
    local raw = signal1.asTable(),
    testResult: test.suite({
      testTableDescriptionNotDuplicated: {
        actual: raw.description,
        expect: 'CPU (max): CPU usage across instances.  \n',
      },
    }),
  },
}
