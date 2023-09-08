local g = import '../../../g.libsonnet';
local base = import '../../all/table/base.libsonnet';
local table = g.panel.table;
local fieldOverride = g.panel.table.fieldOverride;
local custom = table.fieldConfig.defaults.custom;
local defaults = table.fieldConfig.defaults;
local options = table.options;
base {
  new(
    title='Disk space usage',
    totalTarget,
    usageTarget,
    groupLabel,
    description=''
  ): 
    // validate inputs
    std.prune(
      {
        checks: [
          if !(std.objectHas(totalTarget, 'format') && std.assertEqual(totalTarget.format, 'table')) then error 'totalTarget format must be "table"',
          if !(std.objectHas(totalTarget, 'instant') && std.assertEqual(totalTarget.instant, true)) then error 'totalTarget must be type instant',
          if !(std.objectHas(usageTarget, 'format') && std.assertEqual(usageTarget.format, 'table')) then error 'usageTarget format must be "table"',
          if !(std.objectHas(usageTarget, 'instant') && std.assertEqual(usageTarget.instant, true)) then error 'usageTarget must be type instant',
          // if std.length(std.findSubstr(groupLabel, totalTarget.expr)) == 0 then error 'totalTarget expression must be grouped by groupLabel "%s", current expression is %s' % [groupLabel, totalTarget.expr],
          // if std.length(std.findSubstr(groupLabel, usageTarget.expr)) == 0 then error 'usageTarget expression must be grouped by groupLabel "%s", current expression is %s' % [groupLabel, totalTarget.expr],
        ]
      }
    ) +
    super.new(
      title=title,
      targets=[
        totalTarget {"refId": "TOTAL"},
        usageTarget {"refId": "USAGE"},
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
+ fieldOverride.byName.withProperty('custom.width','80'),
fieldOverride.byName.new('Used')
+ fieldOverride.byName.withProperty('custom.width','80'),
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
+ table.standardOptions.withUnit('bytes')
+ table.queryOptions.withTransformationsMixin(
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
                  [groupLabel]: {
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
                  [groupLabel]: 'Mounted on',
                },
              },
            },
            self.transformations.sortBy('Mounted on')
          ]),
}
