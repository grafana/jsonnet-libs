local commonlib = import './common-lib/common/main.libsonnet';
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    // agg by group, instance or none:
    aggLevel: 'instance',
    aggFunction: 'avg',
    discoveryMetric: {
      cadvisor: 'container_last_seen',
    },
    signals: {

      containersCount: {
        name: 'Containers',
        description: 'Total number of running containers last seen by the exporter.',
        type: 'raw',
        sources: {
          cadvisor: {
            expr: 'count(container_last_seen{%%(queriesSelector)s, %(containerSelector)s})' % {containerSelector: this.containerSelector},
          },
        },
      },
      imagesCount: {
        name: 'Images',
        description: 'Total number of distinct images found across running containers.',
        type: 'raw',
        sources: {
          cadvisor: {
            expr: 'count (sum by (image) (container_last_seen{%%(queriesSelector)s, %(containerSelector)s}))' % {containerSelector: this.containerSelector},
          },
        },
      },

      memoryReserved: {
        name: 'Memory reserved',
        description: 'Memory reserved by the containers on the machine.',
        type: 'raw',
        unit: 'percent',
        sources: {
          cadvisor: {
            expr: |||
              sum(
                container_spec_memory_reservation_limit_bytes{%%(queriesSelector)s, %(containerSelector)s}
                )
              / 
              avg(
                  machine_memory_bytes{%%(queriesSelector)s}
              ) * 100
            ||| % {containerSelector: this.containerSelector},
          },
        },
      },
      memoryUtilization: {
        name: 'Memory used',
        description: 'Memory used by all containers out of machine total.',
        type: 'raw',
        unit: 'percent',
        sources: {
          cadvisor: {
            expr: |||
              avg(
                sum by (instance) (container_memory_usage_bytes{%%(queriesSelector)s, %(containerSelector)s})
                /
                avg by (instance) (machine_memory_bytes{%%(queriesSelector)s})
              ) * 100
            ||| % {containerSelector: this.containerSelector},
          },
        },
      },
      cpuUsage: {
        name: 'CPU usage',
        description: 'Cpu time consumed in seconds by container.',
        type: 'raw',
        unit: 'percent',
        sources: {
          cadvisor: {
            expr: 'avg by (%%(agg)s, name) (rate(container_cpu_usage_seconds_total{%%(queriesSelector)s, %(containerSelector)s}[$__rate_interval])) * 100' % {containerSelector: this.containerSelector},
            legendCustomTemplate: commonlib.utils.labelsToPanelLegend(this.instanceLabels),
          },
        },
      },

    },
  }
