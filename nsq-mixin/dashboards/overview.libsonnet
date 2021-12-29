local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local prometheus = grafana.prometheus;

{

  grafanaDashboards+:: {

    local nsqSelector = 'job="$job", instance=~"$instance"',
    local nsqTopicSelector = nsqSelector + ',topic=~"$topic"',
    local nsqHeapMemory =
      grafana.graphPanel.new(
        'Heap memory',
        datasource='$datasource',
        description='Average memory usage if instance=All filter is selected'
      )
      .addTarget(prometheus.target(expr='avg by (job) (nsq_mem_heap_in_use_bytes{%s})' % nsqSelector, intervalFactor=2, legendFormat='{{ job }} heap in use'))
      .addTarget(prometheus.target(expr='avg by (job) (nsq_mem_heap_idle_bytes{%s})' % nsqSelector, intervalFactor=2, legendFormat='{{ job }} heap idle bytes'))
      .addTarget(prometheus.target(expr='avg by (job) (nsq_mem_heap_released_bytes{%s})' % nsqSelector, intervalFactor=2, legendFormat='{{ job }} heap bytes released'))
      + {
        type: 'timeseries',
        options+: {
          tooltip: {
            mode: 'multi',
          },
        },
        fieldConfig+: {
          defaults+: {
            custom+: {
              lineInterpolation: 'smooth',
              fillOpacity: 5,
              showPoints: 'never',
            },
            unit: 'decbytes',
          },
        },
      },
    local nsqHeapObjects =
      grafana.graphPanel.new(
        'Heap objects',
        datasource='$datasource'
      )
      .addTarget(prometheus.target(expr='nsq_mem_heap_objects{%s}' % nsqSelector, intervalFactor=2, legendFormat='{{ job }} {{ instance }}'))
      + {
        type: 'timeseries',
        options+: {
          tooltip: {
            mode: 'multi',
          },
        },
        fieldConfig+: {
          defaults+: {
            custom+: {
              lineInterpolation: 'smooth',
              fillOpacity: 5,
              showPoints: 'never',
            },
            unit: 'short',
          },
        },
      },
    local nsqNextGC =
      grafana.graphPanel.new(
        'Next GC in bytes',
        datasource='$datasource',
        description='The number used bytes at which the runtime plans to perform the next garbage collection'
      )
      .addTarget(prometheus.target(expr='nsq_mem_next_gc_bytes{%s}' % nsqSelector, intervalFactor=2, legendFormat='{{ job }} {{ instance }}'))
      + {
        type: 'timeseries',
        options+: {
          tooltip: {
            mode: 'multi',
          },
        },
        fieldConfig+: {
          defaults+: {
            custom+: {
              lineInterpolation: 'smooth',
              fillOpacity: 5,
              showPoints: 'never',
            },
            unit: 'decbytes',
          },
        },
      },
    local nsqGCpause =
      grafana.graphPanel.new(
        'GC pause time',
        datasource='$datasource',
        description='Max garbage collection pause time across all job instances, if instance=All filter is selected'
      )
      .addTarget(prometheus.target(expr='max by (job) (nsq_mem_gc_pause_usec_100{%s})' % nsqSelector, intervalFactor=2, legendFormat='p100 {{ job }} {{ instance }}'))
      .addTarget(prometheus.target(expr='max by (job) (nsq_mem_gc_pause_usec_99{%s})' % nsqSelector, intervalFactor=2, legendFormat='p99 {{ job }} {{ instance }}'))
      .addTarget(prometheus.target(expr='max by (job) (nsq_mem_gc_pause_usec_95{%s})' % nsqSelector, intervalFactor=2, legendFormat='p95 {{ job }} {{ instance }}'))

      + {
        type: 'timeseries',
        options+: {
          tooltip: {
            mode: 'multi',
          },
        },
        fieldConfig+: {
          defaults+: {
            custom+: {
              lineInterpolation: 'smooth',
              fillOpacity: 5,
              showPoints: 'never',
            },
            unit: 'µs',
          },
        },
      },

    local nsqTopics =
      grafana.graphPanel.new(
        'Topics',
        datasource='$datasource',
      )
      .addTarget(prometheus.target(expr='avg by (topic) (rate(nsq_topic_message_count{%s}[$__rate_interval]))' % nsqTopicSelector, intervalFactor=1, legendFormat='{{topic}} rps'))
      .addTarget(prometheus.target(expr='sum by () (rate(nsq_topic_message_count{%s}[$__rate_interval]))' % nsqTopicSelector, intervalFactor=1, legendFormat='selected topics Bps rate'))
      + {
        type: 'timeseries',
        options+: {
          tooltip: {
            mode: 'multi',
          },
        },
        fieldConfig+: {
          defaults+: {
            custom+: {
              lineInterpolation: 'smooth',
              fillOpacity: 0,
              showPoints: 'never',
            },
            unit: 'reqps',
          },
          overrides: [
            {
              matcher: {
                id: 'byRegexp',
                options: '.+ Bps rate',
              },
              properties: [
                {
                  id: 'custom.drawStyle',
                  value: 'bars',
                },
                {
                  id: 'custom.axisPlacement',
                  value: 'right',
                },
                {
                  id: 'custom.stacking',
                  value: {
                    mode: 'normal',
                    group: 'A',
                  },
                },
                {
                  id: 'color',
                  value: {
                    mode: 'fixed',
                    fixedColor: '#cef7913b',
                  },
                },
                {
                  id: 'unit',
                  value: 'Bps',
                },
                {
                  id: 'custom.barAlignment',
                  value: -1,
                },
                {
                  id: 'custom.fillOpacity',
                  value: 10,
                },
              ],
            },
          ],
        },
      },

    local nsqTopicsDepth =
      grafana.graphPanel.new(
        'Topics depth',
        datasource='$datasource',
      )
      .addTarget(prometheus.target(expr='nsq_topic_depth{%s}' % nsqTopicSelector, intervalFactor=1, legendFormat='{{ instance }} {{topic}} memory depth'))
      .addTarget(prometheus.target(expr='nsq_topic_backend_depth{%s}' % nsqTopicSelector, intervalFactor=1, legendFormat='{{ instance }} {{topic}} memory+disk depth'))
      + {
        type: 'timeseries',
        options+: {
          tooltip: {
            mode: 'multi',
          },
        },
        fieldConfig+: {
          defaults+: {
            custom+: {
              lineInterpolation: 'smooth',
              fillOpacity: 0,
              showPoints: 'never',
            },
            unit: 'short',
          },
        },
      },

    'nsq-overview.json':
      grafana.dashboard.new(
        '%s Overview' % $._config.dashboardNamePrefix,
        time_from='%s' % $._config.dashboardPeriod,
        editable=true,  // TODO change to false
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        graphTooltip='shared_crosshair',
        uid='nsq-overview'
      )
      .addTemplate(
        {
          current: {
            text: 'Prometheus',
            value: 'Prometheus',
          },
          hide: 0,
          label: 'Data Source',
          name: 'datasource',
          options: [],
          query: 'prometheus',
          refresh: 1,
          regex: '',
          type: 'datasource',
        }
      )
      .addTemplate(
        {
          hide: 0,
          label: null,
          name: 'job',
          options: [],
          query: 'label_values(nsq_topic_message_count, job)',
          refresh: 1,
          regex: '',
          type: 'query',
        },
      )
      .addTemplate(
        {
          hide: 0,
          label: null,
          name: 'instance',
          includeAll: true,
          multi: true,
          options: [],
          query: 'label_values(nsq_topic_message_count{job="$job"},instance)',
          refresh: 1,
          regex: '',
          type: 'query',
        },
      )
      .addTemplate(
        {
          hide: 0,
          label: null,
          name: 'topic',
          includeAll: true,
          multi: true,
          options: [],
          query: 'label_values(nsq_topic_message_count{job="$job",instance=~"$instance"},topic)',
          refresh: 1,
          regex: '',
          type: 'query',
        },
      )
      .addPanel(grafana.row.new(title='Topics'), gridPos={ x: 0, y: 0, w: 0, h: 0 })
      .addPanel(nsqTopics, gridPos={ x: 0, y: 0, w: 24, h: 12 })
      .addPanel(nsqTopicsDepth, gridPos={ x: 0, y: 12, w: 24, h: 12 })
      .addPanel(grafana.row.new(title='Memory'), gridPos={ x: 0, y: 24, w: 0, h: 0 })
      .addPanel(nsqHeapMemory, gridPos={ x: 0, y: 24, w: 12, h: 12 })
      .addPanel(nsqHeapObjects, gridPos={ x: 12, y: 36, w: 12, h: 12 })
      .addPanel(nsqNextGC, gridPos={ x: 0, y: 48, w: 12, h: 12 })
      .addPanel(nsqGCpause, gridPos={ x: 12, y: 60, w: 12, h: 12 }),

  },
}
