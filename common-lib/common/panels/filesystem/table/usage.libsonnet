local g = import '../../../g.libsonnet';
local base = import '../../all/table/base.libsonnet';
local table = g.panel.table;
local fieldOverride = g.panel.table.fieldOverride;
local custom = table.fieldConfig.defaults.custom;
local defaults = table.fieldConfig.defaults;
local options = table.options;
base {
  new(
    title,
    totalTarget,
    usageTarget,
    description=''
  ):
    super.new(
      title=title,
      targets=[
        totalTarget {"refId": "TOTAL"}, 
        usageTarget {"refId": "USAGE"}
      ],
      description=description,
    )
+ table.standardOptions.thresholds.withSteps(
  [
    table.thresholdStep.withColor('light-blue')
  + table.thresholdStep.withValue(null),
  table.thresholdStep.withColor('light-yellow')
  + table.thresholdStep.withValue(0.8),
  table.thresholdStep.withColor('light-red')
  + table.thresholdStep.withValue(0.9)
  ]
)

+ table.standardOptions.withOverrides([
fieldOverride.byName.new('Mounted on')
+ fieldOverride.byName.withProperty('custom.width','260'),
fieldOverride.byName.new('Size')
+ fieldOverride.byName.withProperty('custom.width','72'),
fieldOverride.byName.new('Used')
+ fieldOverride.byName.withProperty('custom.width','72'),
fieldOverride.byName.new('Available')
+ fieldOverride.byName.withProperty('custom.width','80'),
fieldOverride.byName.new('Used, %')
+ fieldOverride.byName.withProperty('custom.displayMode','basic')
+ fieldOverride.byName.withPropertiesFromOptions(
  table.standardOptions.withMax(1)
  + table.standardOptions.withMin(0)
  + table.standardOptions.withUnit('percentunit')
)
])
+ table.standardOptions.withUnit('decbytes')
+ table.withTransformationsMixin(
          [
            {
              id: 'groupBy',
              options: {
                fields: {
                  'Value #TOTAL': {
                    aggregations: [
                      'lastNotNull',
                    ],
                    operation: 'aggregate',
                  },
                  'Value #USAGE': {
                    aggregations: [
                      'lastNotNull',
                    ],
                    operation: 'aggregate',
                  },
                  mountpoint: {
                    aggregations: [],
                    operation: 'groupby',
                  },
                },
              },
            },
            {
              id: 'merge',
              options: {},
            },
            {
              id: 'calculateField',
              options: {
                alias: 'Used',
                binary: {
                  left: 'Value #TOTAL (lastNotNull)',
                  operator: '-',
                  reducer: 'sum',
                  right: 'Value #USAGE (lastNotNull)',
                },
                mode: 'binary',
                reduce: {
                  reducer: 'sum',
                },
              },
            },
            {
              id: 'calculateField',
              options: {
                alias: 'Used, %',
                binary: {
                  left: 'Used',
                  operator: '/',
                  reducer: 'sum',
                  right: 'Value #TOTAL (lastNotNull)',
                },
                mode: 'binary',
                reduce: {
                  reducer: 'sum',
                },
              },
            },
            {
              id: 'organize',
              options: {
                excludeByName: {},
                indexByName: {},
                renameByName: {
                  'Value #TOTAL (lastNotNull)': 'Size',
                  'Value #USAGE (lastNotNull)': 'Available',
                  mountpoint: 'Mounted on',
                },
              },
            },
            self.transformations.sortBy('Mounted on')
          ]),
}
