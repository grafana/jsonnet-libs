local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      databaseStatusPanel:
        g.panel.stat.new(title='Database status')
        + g.panel.stat.queryOptions.withTargets([
          signals.sessions.databaseStatus.asTarget(),
        ])
        + g.panel.stat.panelOptions.withDescription('Database status either Up or Down. Colored to be green when Up or red when Down.')
        + g.panel.stat.standardOptions.withMappings([
          {
            options: {
              '0': {
                index: 0,
                text: 'Down',
              },
              '1': {
                index: 1,
                text: 'OK',
              },
            },
            type: 'value',
          },
        ])
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.thresholdStep.withColor('red'),
          g.panel.stat.thresholdStep.withColor('green') + g.panel.stat.thresholdStep.withValue(1),
        ])
        + g.panel.stat.options.withColorMode('value')
        + g.panel.stat.options.withGraphMode('none'),

      sessionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Sessions',
          targets=[
            signals.sessions.sessions.asTarget(),
            signals.sessions.sessionsLimit.asTarget(),
          ],
          description='Number of sessions.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      processesPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Processes',
          targets=[
            signals.sessions.processes.asTarget() { interval: '1m' },
            signals.sessions.processesLimit.asTarget() { interval: '1m' },
          ],
          description='Number of processes.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      applicationWaitTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Application wait time',
          targets=[signals.waittimes.applicationWaitTime.asTarget() { interval: '1m' }],
          description='Application wait time, in seconds, waiting for wait events.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      commitWaitTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Commit wait time',
          targets=[signals.waittimes.commitWaitTime.asTarget() { interval: '1m' }],
          description='Commit wait time, in seconds, waiting for wait events.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      concurrencyWaitTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Concurrency wait time',
          targets=[signals.waittimes.concurrencyWaitTime.asTarget() { interval: '1m' }],
          description='Concurrency wait time, in seconds, waiting for wait events.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      configurationWaitTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Configuration wait time',
          targets=[signals.waittimes.configurationWaitTime.asTarget() { interval: '1m' }],
          description='Configuration wait time, in seconds, waiting for wait events.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      networkWaitTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Network wait time',
          targets=[signals.waittimes.networkWaitTime.asTarget() { interval: '1m' }],
          description='Network wait time, in seconds, waiting for wait events.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      schedulerWaitTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Scheduler wait time',
          targets=[signals.waittimes.schedulerWaitTime.asTarget() { interval: '1m' }],
          description='Scheduler wait time, in seconds, waiting for wait events.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      systemIOWaitTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'System I/O wait time',
          targets=[signals.waittimes.systemIOWaitTime.asTarget() { interval: '1m' }],
          description='System I/O wait time, in seconds, waiting for wait events.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      userIOWaitTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'User I/O wait time',
          targets=[signals.waittimes.userIOWaitTime.asTarget() { interval: '1m' }],
          description='User I/O wait time, in seconds, waiting for wait events.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      tablespaceSizePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Tablespace size',
          targets=[
            signals.tablespace.tablespaceUsed.asTarget(),
            signals.tablespace.tablespaceFree.asTarget(),
            signals.tablespace.tablespaceMax.asTarget(),
          ],
          description='Shows the size over time for the tablespace.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),
    },
}
