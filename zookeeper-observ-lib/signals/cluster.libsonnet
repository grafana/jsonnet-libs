local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: [],
    aggLevel: 'group',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'num_alive_connections',
      grafanacloud: 'zookeeper_numaliveconnections',
    },
    signals: {
      // used in status map
      role: {
        name: 'Current zookeeper role',
        description: |||
          0 - zookeeper, 1 - zookeeper(leader).
        |||,
        type: 'raw',
        unit: 'short',
        aggFunction: 'sum',
        sources: {
          grafanacloud:
            {
              expr: 'clamp_max(zookeeper_leaderuptime{%(queriesSelector)s}, 1) or clamp_max(zookeeper_numaliveconnections{%(queriesSelector)s}, 0)',
              legendCustomTemplate: '{{ %s }}' % this.instanceLabels[0],
              aggKeepLabels: this.instanceLabels,
              valueMappings: [
                {
                  type: 'value',
                  options: {
                    '0': {
                      color: 'light-yellow',
                      index: 0,
                      text: 'zookeeper',
                    },
                    '1': {
                      color: 'light-orange',
                      index: 0,
                      text: 'zookeeper(leader)',
                    },
                  },
                },
              ],
            },
          prometheus:
            {
              expr: 'clamp_max(leader_uptime{%(queriesSelector)s}, 1) or clamp_max(num_alive_connections{%(queriesSelector)s}, 0)',
              aggKeepLabels: this.instanceLabels,
              legendCustomTemplate: '{{ %s }}' % this.instanceLabels[0],
              valueMappings: [
                {
                  type: 'value',
                  options: {
                    '0': {
                      color: 'light-yellow',
                      index: 0,
                      text: 'zookeeper',
                    },
                    '1': {
                      color: 'light-orange',
                      index: 0,
                      text: 'zookeeper(leader)',
                    },
                  },
                },
              ],
            },
        },
      },
    },
  }
