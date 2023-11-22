{
  grafanaDashboards+:: {
    'nomad-jobs.json':
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
        description: 'Nomad jobs metrics',
        editable: true,
        fiscalYearStartMonth: 0,
        gnetId: 6281,
        graphTooltip: 0,
        id: 10,
        links: [],
        liveNow: false,
        panels: [
          {
            collapsed: false,
            datasource: {
              type: 'prometheus',
              uid: 'grafanacloud-prom',
            },
            gridPos: {
              h: 1,
              w: 24,
              x: 0,
              y: 0,
            },
            id: 9,
            panels: [],
            repeat: 'instance',
            targets: [
              {
                datasource: {
                  type: 'prometheus',
                  uid: 'grafanacloud-prom',
                },
                refId: 'A',
              },
            ],
            title: '$instance',
            type: 'row',
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
                unit: 'percent',
              },
              overrides: [],
            },
            gridPos: {
              h: 6,
              w: 12,
              x: 0,
              y: 1,
            },
            id: 2,
            links: [],
            options: {
              legend: {
                calcs: [],
                displayMode: 'list',
                placement: 'bottom',
                showLegend: true,
              },
              tooltip: {
                mode: 'multi',
                sort: 'desc',
              },
            },
            pluginVersion: '8.4.7',
            targets: [
              {
                datasource: {
                  uid: '$datasource',
                },
                expr: 'avg(nomad_client_allocs_cpu_total_percent{job=~"$job", instance=~"$instance"}) by(exported_job, task)',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: '{{task}}',
                refId: 'A',
              },
            ],
            title: 'CPU usage',
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
                unit: 'timeticks',
              },
              overrides: [],
            },
            gridPos: {
              h: 6,
              w: 12,
              x: 12,
              y: 1,
            },
            id: 3,
            links: [],
            options: {
              legend: {
                calcs: [],
                displayMode: 'list',
                placement: 'bottom',
                showLegend: true,
              },
              tooltip: {
                mode: 'multi',
                sort: 'desc',
              },
            },
            pluginVersion: '8.4.7',
            targets: [
              {
                datasource: {
                  type: 'prometheus',
                  uid: '1_UFfQJGk',
                },
                exemplar: true,
                expr: 'avg(nomad_client_allocs_cpu_total_ticks{job=~"$job", instance=~"$instance"}) by (exported_job, task)',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: '{{task}}',
                refId: 'A',
              },
            ],
            title: 'CPU total ticks',
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
                unit: 'decbytes',
              },
              overrides: [],
            },
            gridPos: {
              h: 6,
              w: 12,
              x: 0,
              y: 7,
            },
            id: 6,
            links: [],
            options: {
              legend: {
                calcs: [],
                displayMode: 'list',
                placement: 'bottom',
                showLegend: true,
              },
              tooltip: {
                mode: 'multi',
                sort: 'desc',
              },
            },
            pluginVersion: '8.4.7',
            targets: [
              {
                datasource: {
                  uid: '$datasource',
                },
                expr: 'avg(nomad_client_allocs_memory_rss{job=~"$job", instance=~"$instance"}) by(exported_job, task)',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: '{{task}}',
                refId: 'A',
              },
            ],
            title: 'RSS',
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
                unit: 'decbytes',
              },
              overrides: [],
            },
            gridPos: {
              h: 6,
              w: 12,
              x: 12,
              y: 7,
            },
            id: 7,
            links: [],
            options: {
              legend: {
                calcs: [],
                displayMode: 'list',
                placement: 'bottom',
                showLegend: true,
              },
              tooltip: {
                mode: 'multi',
                sort: 'desc',
              },
            },
            pluginVersion: '8.4.7',
            targets: [
              {
                datasource: {
                  type: 'prometheus',
                  uid: '1_UFfQJGk',
                },
                exemplar: true,
                expr: 'avg(nomad_client_allocs_memory_cache{job=~"$job", instance=~"$instance"}) by (exported_job, task)',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: '{{task}}',
                refId: 'A',
              },
            ],
            title: 'Memory cache',
            type: 'timeseries',
          },
        ],
        refresh: '30s',
        schemaVersion: 37,
        style: 'dark',
        tags: [
          'nomad-integration',
        ],
        templating: {
          list: [
            {
              allValue: '.+',
              current: {
                selected: false,
                text: 'All',
                value: '$__all',
              },
              datasource: {
                type: 'prometheus',
                uid: '${datasource}',
              },
              definition: 'label_values(nomad_client_uptime, job)',
              hide: 0,
              includeAll: true,
              label: 'Job',
              multi: true,
              name: 'job',
              options: [],
              query: {
                query: 'label_values(nomad_client_uptime, job)',
                refId: 'StandardVariableQuery',
              },
              refresh: 1,
              regex: '',
              skipUrlSync: false,
              sort: 0,
              type: 'query',
            },
            {
              current: {
                selected: false,
                text: 'default',
                value: 'default',
              },
              hide: 0,
              includeAll: false,
              label: 'Data source',
              multi: false,
              name: 'datasource',
              options: [],
              query: 'prometheus',
              refresh: 1,
              regex: '(?!grafanacloud-usage|grafanacloud-ml-metrics).+',
              skipUrlSync: false,
              type: 'datasource',
            },
            {
              current: {
                isNone: true,
                selected: false,
                text: 'None',
                value: '',
              },
              datasource: {
                uid: '$datasource',
              },
              definition: 'label_values(nomad_client_uptime, datacenter)',
              hide: 0,
              includeAll: false,
              label: 'DC',
              multi: false,
              name: 'datacenter',
              options: [],
              query: {
                query: 'label_values(nomad_client_uptime, datacenter)',
                refId: 'StandardVariableQuery',
              },
              refresh: 1,
              regex: '',
              skipUrlSync: false,
              sort: 0,
              tagValuesQuery: '',
              tagsQuery: '',
              type: 'query',
              useTags: false,
            },
            {
              allValue: '.+',
              current: {
                selected: true,
                text: [
                  'All',
                ],
                value: [
                  '$__all',
                ],
              },
              datasource: {
                uid: '$datasource',
              },
              definition: '',
              hide: 0,
              includeAll: true,
              label: 'Instance',
              multi: true,
              name: 'instance',
              options: [],
              query: {
                query: 'label_values(nomad_client_uptime{datacenter=~"$datacenter"}, instance)',
                refId: 'prometheus-instance-Variable-Query',
              },
              refresh: 2,
              regex: '',
              skipUrlSync: false,
              sort: 0,
              tagValuesQuery: '',
              tagsQuery: '',
              type: 'query',
              useTags: false,
            },
          ],
        },
        time: {
          from: 'now-30m',
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
        timezone: '',
        title: 'Nomad jobs',
        uid: 'TvqbbhViz',
        version: 2,
        weekStart: '',
      },
  },
}
