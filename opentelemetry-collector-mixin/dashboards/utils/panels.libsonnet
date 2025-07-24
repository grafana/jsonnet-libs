local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
{
  timeSeries: {
    local timeSeries = g.panel.timeSeries,
    local fieldOverride = g.panel.timeSeries.fieldOverride,
    local custom = timeSeries.fieldConfig.defaults.custom,
    local options = timeSeries.options,

    base(title, targets):
      timeSeries.new(title)
      + timeSeries.queryOptions.withTargets(targets)
      + timeSeries.queryOptions.withInterval('1m')
      + options.legend.withDisplayMode('table')
      + options.legend.withCalcs([
        'lastNotNull',
        'max',
      ])
      + custom.withFillOpacity(10)
      + custom.withShowPoints('never')
      + timeSeries.panelOptions.withDescription(title),

    short(title, targets):
      self.base(title, targets)
      + timeSeries.standardOptions.withUnit('short')
      + timeSeries.standardOptions.withDecimals(0),

    seconds(title, targets):
      self.base(title, targets)
      + timeSeries.standardOptions.withUnit('s')
      + custom.scaleDistribution.withType('log')
      + custom.scaleDistribution.withLog(10),

    cpuUsage: self.seconds,

    bytes(title, targets):
      self.base(title, targets,)
      + timeSeries.standardOptions.withUnit('bytes')
      + custom.scaleDistribution.withType('log')
      + custom.scaleDistribution.withLog(2),

    memoryUsage(title, targets):
      self.bytes(title, targets)
      + timeSeries.standardOptions.withOverrides([
        fieldOverride.byRegexp.new('/(virtual|resident)/i')
        + fieldOverride.byRegexp.withProperty(
          'custom.fillOpacity',
          0
        )
        + fieldOverride.byRegexp.withProperty(
          'custom.lineWidth',
          2
        )
        + fieldOverride.byRegexp.withProperty(
          'custom.lineStyle',
          {
            dash: [10, 10],
            fill: 'dash',
          }
        ),
      ]),

    durationQuantile(title, targets):
      self.base(title, targets)
      + timeSeries.standardOptions.withUnit('s')
      + custom.withDrawStyle('bars')
      + timeSeries.standardOptions.withOverrides([
        fieldOverride.byRegexp.new('/mean/i')
        + fieldOverride.byRegexp.withProperty(
          'custom.fillOpacity',
          0
        )
        + fieldOverride.byRegexp.withProperty(
          'custom.lineStyle',
          {
            dash: [8, 10],
            fill: 'dash',
          }
        ),
      ]),

    milliseconds(title, targets):
      self.base(title, targets)
      + timeSeries.standardOptions.withUnit('ms'),

    cps(title, targets):
      self.base(title, targets)
      + timeSeries.standardOptions.withUnit('cps'),
  },

  heatmap: {
    local heatmap = g.panel.heatmap,
    local options = heatmap.options,

    base(title, targets):
      heatmap.new(title)
      + heatmap.queryOptions.withTargets(targets)
      + heatmap.queryOptions.withInterval('1m')

      + options.withCalculate()
      + options.calculation.xBuckets.withMode('size')
      + options.calculation.xBuckets.withValue('1min')
      + options.withCellGap(2)
      + options.color.withMode('scheme')
      + options.color.withScheme('Spectral')
      + options.color.withSteps(128)
      + options.yAxis.withDecimals(0)
      + options.yAxis.withUnit('short')
      + heatmap.panelOptions.withDescription(title),
  },

  stat: {
    local stat = g.panel.stat,
    local options = stat.options,

    base(title, targets):
      stat.new(title)
      + stat.queryOptions.withTargets(targets)

      + options.withColorMode('value')
      + options.withGraphMode('none')
      + options.withJustifyMode('center')
      + options.withOrientation('auto')
      + options.reduceOptions.withCalcs(['lastNotNull'])
      + options.reduceOptions.withFields('')
      + options.reduceOptions.withValues(false)
      + options.withShowPercentChange(false)
      + options.withTextMode('auto')
      + options.withWideLayout(true)
      + stat.standardOptions.withUnit('none')
      + stat.panelOptions.withDescription(title),
  },

  table: {
    local table = g.panel.table,
    local options = table.options,

    base(title, targets):
      table.new(title)
      + table.queryOptions.withTargets(targets)
      + table.queryOptions.withInterval('1m')

      + options.withCellHeight('sm')
      + options.withFrameIndex(0)
      + options.withShowHeader(true)
      + options.footer.withShow(false)
      + options.footer.withCountRows(false)
      + options.footer.withFields('')
      + options.footer.withReducer(['sum'])
      + table.panelOptions.withDescription(title),

    uptime(title, targets):
      self.base(title, targets)
      + table.standardOptions.withUnit('s')
      + table.queryOptions.withTransformations([
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              job: true,
              __name__: true,
            },
            includeByName: {
              cluster: true,
              namespace: true,
              instance: true,
              service_version: true,
              version: true,
              Value: true,
            },
            indexByName: {
              cluster: 0,
              namespace: 1,
              instance: 2,
              service_version: 3,
              version: 3,
              Value: 4,
            },
            renameByName: {
              Value: 'Uptime',
            },
          },
        },
      ])
      + table.standardOptions.withOverrides([
        {
          matcher: {
            id: 'byName',
            options: 'Uptime',
          },
          properties: [
            {
              id: 'custom.displayMode',
              value: 'basic',
            },
          ],
        },
      ])
      + table.options.withSortBy([
        {
          displayName: 'Uptime',
          desc: true,
        },
      ]),

  },
}
