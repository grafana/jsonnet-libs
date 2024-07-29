local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'sum',
    aggKeepLabels: ['level'],
    discoveryMetric: {
      java_micrometer: 'logback_events_total',
      // prometheus: '?',
      // otel: '?',
      // prometheus_old: '?',
    },
    signals: {
      events: {
        name: 'Logback events',
        description: 'Logback events.',
        type: 'counter',  // counter
        unit: 'short',
        optional: true,
        sources: {
          java_micrometer: {
            expr: |||
              logback_events_total{%(queriesSelector)s}
            |||,
            exprWrappers: [
              ['topk(10,', ')'],
            ],
          },
          //   prometheus: {
          //     expr: '?{%(queriesSelector)s}',
          //   },
          //   otel: {
          //     expr: '?{%(queriesSelector)s}',
          //   },
        },
      },
      errors: {
        name: 'Logback events (errors)',
        description: 'Logback events with error level.',
        type: 'counter',  // counter
        unit: 'short',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'logback_events_total{level="error", %(queriesSelector)s}',
            exprWrappers: [
              ['topk(10,', ')'],
            ],
          },
          //   prometheus: {
          //     expr: '?{%(queriesSelector)s}',
          //   },
          //   otel: {
          //     expr: '?{%(queriesSelector)s}',
          //   },
        },
      },

    },
  }
