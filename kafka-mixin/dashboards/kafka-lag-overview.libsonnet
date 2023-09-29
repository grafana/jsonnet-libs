local config = (import '../config.libsonnet');
local g = import '../g.libsonnet';
local var = import '../variables.libsonnet';
local commonvars = var.new(
  varMetric='kafka_topic_partition_current_offset',
  filteringSelector=config._config.kafkaFilteringSelector,
  groupLabels=config._config.groupLabels,
  instanceLabels=config._config.instanceLabels,
);

local dashboard =
  {
    annotations: {
      list: [
        {
          builtIn: 1,
          datasource: {
            type: 'datasource',
            uid: 'grafana',
          },
          enable: true,
          hide: true,
          iconColor: 'rgba(0, 211, 255, 1)',
          name: 'Annotations & Alerts',
          target: {
            limit: 100,
            matchAny: false,
            tags: [],
            type: 'dashboard',
          },
          type: 'dashboard',
        },
      ],
    },
    description: 'Kafka lag overview',
    editable: true,
    fiscalYearStartMonth: 0,
    gnetId: 7589,
    graphTooltip: 0,
    id: 52,
    links: [],
    liveNow: false,
    panels: [
      {
        datasource: {
          uid: '${datasource}',
        },
        fieldConfig: {
          defaults: {
            color: {
              mode: 'palette-classic',
            },
            custom: {
              axisCenteredZero: false,
              axisColorMode: 'text',
              axisLabel: '',
              axisPlacement: 'auto',
              barAlignment: 0,
              drawStyle: 'line',
              fillOpacity: 0,
              gradientMode: 'none',
              hideFrom: {
                legend: false,
                tooltip: false,
                viz: false,
              },
              lineInterpolation: 'linear',
              lineWidth: 1,
              pointSize: 5,
              scaleDistribution: {
                type: 'linear',
              },
              showPoints: 'never',
              spanNulls: true,
              stacking: {
                group: 'A',
                mode: 'none',
              },
              thresholdsStyle: {
                mode: 'off',
              },
            },
            mappings: [],
            min: 0,
            thresholds: {
              mode: 'absolute',
              steps: [
                {
                  color: 'green',
                  value: null,
                },
                {
                  color: 'red',
                  value: 80,
                },
              ],
            },
            unit: 'short',
          },
          overrides: [],
        },
        gridPos: {
          h: 10,
          w: 12,
          x: 0,
          y: 0,
        },
        id: 14,
        links: [],
        options: {
          legend: {
            calcs: [
              'lastNotNull',
              'max',
            ],
            displayMode: 'table',
            placement: 'bottom',
            showLegend: true,
            width: 480,
          },
          tooltip: {
            mode: 'multi',
            sort: 'none',
          },
        },
        pluginVersion: '9.2.7',
        targets: [
          {
            datasource: {
              uid: '${datasource}',
            },
            exemplar: true,
            expr: 'sum(rate(kafka_topic_partition_current_offset{' + commonvars.queriesSelector + ', topic=~"$topic"}[$__rate_interval])) by (topic)',
            format: 'time_series',
            interval: '',
            intervalFactor: 1,
            legendFormat: '{{topic}}',
            refId: 'B',
          },
        ],
        title: 'Message in per second',
        type: 'timeseries',
      },
      {
        datasource: {
          uid: '${datasource}',
        },
        fieldConfig: {
          defaults: {
            color: {
              mode: 'palette-classic',
            },
            custom: {
              axisCenteredZero: false,
              axisColorMode: 'text',
              axisLabel: '',
              axisPlacement: 'auto',
              barAlignment: 0,
              drawStyle: 'line',
              fillOpacity: 0,
              gradientMode: 'none',
              hideFrom: {
                legend: false,
                tooltip: false,
                viz: false,
              },
              lineInterpolation: 'linear',
              lineWidth: 1,
              pointSize: 5,
              scaleDistribution: {
                type: 'linear',
              },
              showPoints: 'never',
              spanNulls: true,
              stacking: {
                group: 'A',
                mode: 'none',
              },
              thresholdsStyle: {
                mode: 'off',
              },
            },
            mappings: [],
            thresholds: {
              mode: 'absolute',
              steps: [
                {
                  color: 'green',
                  value: null,
                },
                {
                  color: 'red',
                  value: 80,
                },
              ],
            },
            unit: 'short',
          },
          overrides: [],
        },
        gridPos: {
          h: 10,
          w: 12,
          x: 12,
          y: 0,
        },
        id: 16,
        links: [],
        options: {
          legend: {
            calcs: [
              'lastNotNull',
              'max',
            ],
            displayMode: 'table',
            placement: 'bottom',
            showLegend: true,
            width: 480,
          },
          tooltip: {
            mode: 'multi',
            sort: 'none',
          },
        },
        pluginVersion: '9.2.7',
        targets: [
          {
            datasource: {
              uid: '${datasource}',
            },
            exemplar: true,
            expr: 'sum(increase(kafka_topic_partition_current_offset{' + commonvars.queriesSelector + ',  topic=~"$topic"}[5m])/5) by (topic)',
            format: 'time_series',
            interval: '',
            intervalFactor: 1,
            legendFormat: '{{topic}}',
            refId: 'A',
          },
        ],
        title: 'Message in per minute',
        type: 'timeseries',
      },
      {
        datasource: {
          uid: '$datasource',
        },
        fieldConfig: {
          defaults: {
            color: {
              mode: 'palette-classic',
            },
            custom: {
              axisCenteredZero: false,
              axisColorMode: 'text',
              axisLabel: '',
              axisPlacement: 'auto',
              barAlignment: 0,
              drawStyle: 'line',
              fillOpacity: 10,
              gradientMode: 'none',
              hideFrom: {
                legend: false,
                tooltip: false,
                viz: false,
              },
              lineInterpolation: 'linear',
              lineWidth: 1,
              pointSize: 5,
              scaleDistribution: {
                type: 'linear',
              },
              showPoints: 'never',
              spanNulls: false,
              stacking: {
                group: 'A',
                mode: 'none',
              },
              thresholdsStyle: {
                mode: 'off',
              },
            },
            mappings: [],
            thresholds: {
              mode: 'absolute',
              steps: [
                {
                  color: 'green',
                  value: null,
                },
                {
                  color: 'red',
                  value: 80,
                },
              ],
            },
            unit: 'short',
          },
          overrides: [],
        },
        gridPos: {
          h: 10,
          w: 12,
          x: 0,
          y: 10,
        },
        id: 20,
        options: {
          legend: {
            calcs: [
              'lastNotNull',
              'max',
            ],
            displayMode: 'table',
            placement: 'bottom',
            showLegend: true,
          },
          tooltip: {
            mode: 'multi',
            sort: 'none',
          },
        },
        pluginVersion: '9.2.7',
        targets: [
          {
            datasource: {
              uid: '$datasource',
            },
            exemplar: true,
            expr: 'sum(rate(kafka_consumergroup_current_offset{' + commonvars.queriesSelector + ', topic=~"$topic"}[$__rate_interval])) by (consumergroup, topic)',
            interval: '',
            legendFormat: '{{consumergroup}} (topic: {{topic}})',
            refId: 'A',
          },
        ],
        title: 'Message consume per second',
        type: 'timeseries',
      },
      {
        datasource: {
          uid: '${datasource}',
        },
        fieldConfig: {
          defaults: {
            color: {
              mode: 'palette-classic',
            },
            custom: {
              axisCenteredZero: false,
              axisColorMode: 'text',
              axisLabel: '',
              axisPlacement: 'auto',
              barAlignment: 0,
              drawStyle: 'line',
              fillOpacity: 0,
              gradientMode: 'none',
              hideFrom: {
                legend: false,
                tooltip: false,
                viz: false,
              },
              lineInterpolation: 'linear',
              lineWidth: 1,
              pointSize: 5,
              scaleDistribution: {
                type: 'linear',
              },
              showPoints: 'never',
              spanNulls: true,
              stacking: {
                group: 'A',
                mode: 'none',
              },
              thresholdsStyle: {
                mode: 'off',
              },
            },
            mappings: [],
            thresholds: {
              mode: 'absolute',
              steps: [
                {
                  color: 'green',
                  value: null,
                },
                {
                  color: 'red',
                  value: 80,
                },
              ],
            },
            unit: 'short',
          },
          overrides: [],
        },
        gridPos: {
          h: 10,
          w: 12,
          x: 12,
          y: 10,
        },
        id: 18,
        links: [],
        options: {
          legend: {
            calcs: [
              'lastNotNull',
              'max',
            ],
            displayMode: 'table',
            placement: 'bottom',
            showLegend: true,
            width: 480,
          },
          tooltip: {
            mode: 'multi',
            sort: 'none',
          },
        },
        pluginVersion: '9.2.7',
        targets: [
          {
            datasource: {
              uid: '${datasource}',
            },
            exemplar: true,
            expr: 'sum(increase(kafka_consumergroup_current_offset{' + commonvars.queriesSelector + ', topic=~"$topic"}[5m])/5) by (consumergroup, topic)',
            format: 'time_series',
            interval: '',
            intervalFactor: 1,
            legendFormat: '{{consumergroup}} (topic: {{topic}})',
            refId: 'A',
          },
        ],
        title: 'Message consume per minute',
        type: 'timeseries',
      },
      {
        datasource: {
          uid: '$datasource',
        },
        fieldConfig: {
          defaults: {
            color: {
              mode: 'palette-classic',
            },
            custom: {
              axisCenteredZero: false,
              axisColorMode: 'text',
              axisLabel: '',
              axisPlacement: 'auto',
              barAlignment: 0,
              drawStyle: 'line',
              fillOpacity: 10,
              gradientMode: 'none',
              hideFrom: {
                legend: false,
                tooltip: false,
                viz: false,
              },
              lineInterpolation: 'linear',
              lineWidth: 1,
              pointSize: 5,
              scaleDistribution: {
                type: 'linear',
              },
              showPoints: 'never',
              spanNulls: false,
              stacking: {
                group: 'A',
                mode: 'none',
              },
              thresholdsStyle: {
                mode: 'off',
              },
            },
            mappings: [],
            thresholds: {
              mode: 'absolute',
              steps: [
                {
                  color: 'green',
                  value: null,
                },
                {
                  color: 'red',
                  value: 80,
                },
              ],
            },
            unit: 'short',
          },
          overrides: [],
        },
        gridPos: {
          h: 10,
          w: 12,
          x: 0,
          y: 20,
        },
        id: 22,
        options: {
          legend: {
            calcs: [
              'lastNotNull',
              'max',
            ],
            displayMode: 'table',
            placement: 'bottom',
            showLegend: true,
          },
          tooltip: {
            mode: 'multi',
            sort: 'none',
          },
        },
        pluginVersion: '9.2.7',
        targets: [
          {
            datasource: {
              uid: '$datasource',
            },
            exemplar: true,
            expr: 'avg(kafka_consumer_lag_millis{' + commonvars.queriesSelector + ', topic=~"$topic"}/1000) by (consumergroup, topic)',
            interval: '',
            legendFormat: '{{consumergroup}} (topic: {{topic}})',
            refId: 'A',
          },
        ],
        title: 'Lag by consumer group in seconds',
        type: 'timeseries',
      },
      {
        datasource: {
          uid: '${datasource}',
        },
        fieldConfig: {
          defaults: {
            color: {
              mode: 'palette-classic',
            },
            custom: {
              axisCenteredZero: false,
              axisColorMode: 'text',
              axisLabel: '',
              axisPlacement: 'auto',
              barAlignment: 0,
              drawStyle: 'line',
              fillOpacity: 0,
              gradientMode: 'none',
              hideFrom: {
                legend: false,
                tooltip: false,
                viz: false,
              },
              lineInterpolation: 'linear',
              lineWidth: 1,
              pointSize: 5,
              scaleDistribution: {
                type: 'linear',
              },
              showPoints: 'never',
              spanNulls: true,
              stacking: {
                group: 'A',
                mode: 'none',
              },
              thresholdsStyle: {
                mode: 'off',
              },
            },
            mappings: [],
            min: 0,
            thresholds: {
              mode: 'absolute',
              steps: [
                {
                  color: 'green',
                  value: null,
                },
                {
                  color: 'red',
                  value: 80,
                },
              ],
            },
            unit: 'short',
          },
          overrides: [],
        },
        gridPos: {
          h: 10,
          w: 12,
          x: 12,
          y: 20,
        },
        id: 12,
        links: [],
        options: {
          legend: {
            calcs: [
              'lastNotNull',
              'max',
            ],
            displayMode: 'table',
            placement: 'bottom',
            showLegend: true,
            width: 480,
          },
          tooltip: {
            mode: 'multi',
            sort: 'desc',
          },
        },
        pluginVersion: '9.2.7',
        targets: [
          {
            datasource: {
              uid: '${datasource}',
            },
            exemplar: true,
            expr: 'avg(kafka_consumergroup_uncommitted_offsets{' + commonvars.queriesSelector + ', topic=~"$topic"}) by (consumergroup, topic)',
            format: 'time_series',
            instant: false,
            interval: '',
            intervalFactor: 1,
            legendFormat: '{{consumergroup}} (topic: {{topic}})',
            refId: 'A',
          },
        ],
        title: 'Lag by consumer group',
        type: 'timeseries',
      },
      {
        datasource: {
          type: 'prometheus',
          uid: '$datasource',
        },
        fieldConfig: {
          defaults: {
            color: {
              mode: 'palette-classic',
            },
            custom: {
              axisCenteredZero: false,
              axisColorMode: 'text',
              axisLabel: '',
              axisPlacement: 'auto',
              fillOpacity: 80,
              gradientMode: 'none',
              hideFrom: {
                legend: false,
                tooltip: false,
                viz: false,
              },
              lineWidth: 1,
              scaleDistribution: {
                type: 'linear',
              },
            },
            mappings: [],
            thresholds: {
              mode: 'absolute',
              steps: [
                {
                  color: 'green',
                  value: null,
                },
              ],
            },
          },
          overrides: [],
        },
        gridPos: {
          h: 6,
          w: 24,
          x: 0,
          y: 30,
        },
        id: 8,
        links: [],
        options: {
          barRadius: 0,
          barWidth: 0.85,
          groupWidth: 0.7,
          legend: {
            calcs: [],
            displayMode: 'list',
            placement: 'bottom',
            showLegend: false,
          },
          orientation: 'auto',
          showValue: 'auto',
          stacking: 'none',
          tooltip: {
            mode: 'single',
            sort: 'none',
          },
          xTickLabelRotation: 0,
          xTickLabelSpacing: 0,
        },
        pluginVersion: '9.2.7',
        targets: [
          {
            datasource: {
              uid: '$datasource',
            },
            exemplar: true,
            expr: 'sum by(topic) (kafka_topic_partitions{' + commonvars.queriesSelector + ', topic=~"$topic"})',
            format: 'table',
            instant: true,
            interval: '',
            intervalFactor: 1,
            legendFormat: '{{topic}}',
            refId: 'A',
          },
        ],
        title: 'Partitions per topic',
        type: 'barchart',
      },
    ],
    refresh: '30s',
    schemaVersion: 37,
    style: 'dark',
    tags: [
      'kafka-integration',
    ],
    time: {
      from: 'now-1h',
      to: 'now',
    },
    timepicker: {
      refresh_intervals: [
        '5s',
        '10s',
        '30s',
        '1m',
        '5m',
        '15m',
        '30m',
        '1h',
        '2h',
        '1d',
      ],
      time_options: [
        '5m',
        '15m',
        '1h',
        '6h',
        '12h',
        '24h',
        '2d',
        '7d',
        '30d',
      ],
    },
    timezone: 'browser',
    title: 'Kafka lag overview',
    uid: 'jwPKIsniz',
    version: 6,
  }
  +
  g.dashboard.withVariables(
    // multiInstance: allow multiple selector for instance labels
    commonvars.multiInstance
    +
    [
      {
        allValue: '.+',
        current: {
          selected: false,
          text: 'All',
          value: '$__all',
        },
        datasource: {
          uid: '${datasource}',
        },
        definition: 'label_values(kafka_topic_partition_current_offset{' + commonvars.queriesSelector + ", topic!='__consumer_offsets',topic!='--kafka'}, topic)",
        hide: 0,
        includeAll: true,
        label: 'Topic',
        multi: true,
        name: 'topic',
        options: [],
        query: {
          query: 'label_values(kafka_topic_partition_current_offset{' + commonvars.queriesSelector + ", topic!='__consumer_offsets',topic!='--kafka'}, topic)",
          refId: 'StandardVariableQuery',
        },
        refresh: 2,
        regex: '',
        skipUrlSync: false,
        sort: 1,
        tagValuesQuery: '',
        type: 'query',
        useTags: false,
      },
    ]
  );


{
  grafanaDashboards+::
    {
      'kafka-lag-overview.json': dashboard,
    },
}
