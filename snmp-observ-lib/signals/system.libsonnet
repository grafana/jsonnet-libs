local commonlib = import 'common-lib/common/main.libsonnet';
local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: {
      prometheus: 'sysUpTime',
    },
    signals: {
      uptime: {
        name: 'Uptime',
        description: |||
          The time since the network management portion of the system was last re-initialized.
        |||,
        type: 'gauge',
        unit: 'dtdurations',
        sources: {
          prometheus:
            {
              expr: 'sysUpTime{%(queriesSelector)s}',
              //ticks to seconds
              exprWrappers: [['(', ')/100']],
            },
        },
      },
      sysName: {
        name: 'System name',
        description: |||
          System name.
        |||,
        type: 'info',
        sources: {
          prometheus:
            {
              expr: 'sysName{%(queriesSelector)s}',
              infoLabel: 'sysName',
            },
        },
      },
    },
  }
