{
  grafanaDashboards+:: {
    'nomad-cluster.json':
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
        editable: true,
        fiscalYearStartMonth: 0,
        graphTooltip: 1,
        id: 8,
        links: [],
        liveNow: false,
        panels: [
          {
            collapsed: false,
            datasource: {
              type: 'prometheus',
              uid: '$datasource',
            },
            gridPos: {
              h: 1,
              w: 24,
              x: 0,
              y: 0,
            },
            id: 24,
            panels: [],
            targets: [
              {
                datasource: {
                  type: 'prometheus',
                  uid: '$datasource',
                },
                refId: 'A',
              },
            ],
            title: 'Allocations',
            type: 'row',
          },
          {
            datasource: {
              uid: '$datasource',
            },
            description: 'CPU allocated on $instance',
            fieldConfig: {
              defaults: {
                color: {
                  mode: 'thresholds',
                },
                mappings: [],
                max: 100,
                min: 0,
                thresholds: {
                  mode: 'absolute',
                  steps: [
                    {
                      color: 'green',
                      value: null,
                    },
                    {
                      color: 'yellow',
                      value: 80,
                    },
                    {
                      color: 'red',
                      value: 90,
                    },
                  ],
                },
                unit: 'percent',
              },
              overrides: [],
            },
            gridPos: {
              h: 5,
              w: 5,
              x: 0,
              y: 1,
            },
            id: 33,
            links: [],
            maxDataPoints: 100,
            options: {
              minVizHeight: 75,
              minVizWidth: 75,
              orientation: 'horizontal',
              reduceOptions: {
                calcs: [
                  'lastNotNull',
                ],
                fields: '',
                values: false,
              },
              showThresholdLabels: false,
              showThresholdMarkers: true,
              text: {},
            },
            pluginVersion: '10.2.1',
            repeat: 'instance',
            repeatDirection: 'v',
            targets: [
              {
                datasource: {
                  uid: '$datasource',
                },
                expr: 'nomad_client_allocated_cpu{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"}/(nomad_client_unallocated_cpu{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"}+nomad_client_allocated_cpu{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"})*100',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: '',
                refId: 'A',
              },
            ],
            title: 'CPU allocated',
            type: 'gauge',
          },
          {
            datasource: {
              uid: '$datasource',
            },
            description: 'Memory allocated on $instance',
            fieldConfig: {
              defaults: {
                color: {
                  mode: 'thresholds',
                },
                mappings: [],
                max: 100,
                min: 0,
                thresholds: {
                  mode: 'absolute',
                  steps: [
                    {
                      color: 'green',
                      value: null,
                    },
                    {
                      color: 'yellow',
                      value: 80,
                    },
                    {
                      color: 'red',
                      value: 90,
                    },
                  ],
                },
                unit: 'percent',
              },
              overrides: [],
            },
            gridPos: {
              h: 5,
              w: 5,
              x: 5,
              y: 1,
            },
            id: 40,
            links: [],
            maxDataPoints: 100,
            options: {
              minVizHeight: 75,
              minVizWidth: 75,
              orientation: 'horizontal',
              reduceOptions: {
                calcs: [
                  'lastNotNull',
                ],
                fields: '',
                values: false,
              },
              showThresholdLabels: false,
              showThresholdMarkers: true,
              text: {},
            },
            pluginVersion: '10.2.1',
            repeat: 'instance',
            repeatDirection: 'v',
            targets: [
              {
                datasource: {
                  uid: '$datasource',
                },
                expr: 'nomad_client_allocated_memory{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"}/(nomad_client_unallocated_memory{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"}+nomad_client_allocated_memory{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"})*100',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: '',
                refId: 'A',
              },
            ],
            title: 'Memory allocated',
            type: 'gauge',
          },
          {
            datasource: {
              uid: '$datasource',
            },
            description: 'Disk allocated on $instance',
            fieldConfig: {
              defaults: {
                color: {
                  mode: 'thresholds',
                },
                decimals: 2,
                mappings: [],
                max: 100,
                min: 0,
                thresholds: {
                  mode: 'absolute',
                  steps: [
                    {
                      color: 'green',
                      value: null,
                    },
                    {
                      color: 'yellow',
                      value: 80,
                    },
                    {
                      color: 'red',
                      value: 90,
                    },
                  ],
                },
                unit: 'percent',
              },
              overrides: [],
            },
            gridPos: {
              h: 5,
              w: 5,
              x: 10,
              y: 1,
            },
            id: 48,
            links: [],
            maxDataPoints: 100,
            options: {
              minVizHeight: 75,
              minVizWidth: 75,
              orientation: 'horizontal',
              reduceOptions: {
                calcs: [
                  'lastNotNull',
                ],
                fields: '',
                values: false,
              },
              showThresholdLabels: false,
              showThresholdMarkers: true,
              text: {},
            },
            pluginVersion: '10.2.1',
            repeat: 'instance',
            repeatDirection: 'v',
            targets: [
              {
                datasource: {
                  uid: '$datasource',
                },
                expr: 'nomad_client_allocated_disk{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"}/(nomad_client_unallocated_disk{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"}+nomad_client_allocated_disk{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"})*100',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: '',
                refId: 'A',
              },
            ],
            title: 'Disk allocated',
            type: 'gauge',
          },
          {
            datasource: {
              type: 'prometheus',
              uid: '${datasource}',
            },
            fieldConfig: {
              defaults: {
                color: {
                  mode: 'continuous-GrYlRd',
                },
                custom: {
                  fillOpacity: 70,
                  hideFrom: {
                    legend: false,
                    tooltip: false,
                    viz: false,
                  },
                  insertNulls: false,
                  lineWidth: 1,
                  spanNulls: false,
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
                unit: 'allocs',
              },
              overrides: [],
            },
            gridPos: {
              h: 5,
              w: 9,
              x: 15,
              y: 1,
            },
            id: 58,
            links: [],
            options: {
              alignValue: 'left',
              legend: {
                displayMode: 'list',
                placement: 'bottom',
                showLegend: false,
              },
              mergeValues: true,
              rowHeight: 0.95,
              showValue: 'auto',
              tooltip: {
                mode: 'single',
                sort: 'none',
              },
            },
            repeat: 'instance',
            repeatDirection: 'v',
            targets: [
              {
                datasource: {
                  type: 'prometheus',
                  uid: '${datasource}',
                },
                exemplar: true,
                expr: 'sum by (datacenter) (nomad_client_allocations_migrating{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"})',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: 'Migrating',
                refId: 'A',
              },
              {
                datasource: {
                  type: 'prometheus',
                  uid: '${datasource}',
                },
                exemplar: true,
                expr: 'sum by (datacenter) (nomad_client_allocations_blocked{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"})',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: 'Blocked',
                refId: 'B',
              },
              {
                datasource: {
                  type: 'prometheus',
                  uid: '${datasource}',
                },
                exemplar: true,
                expr: 'sum by (datacenter) (nomad_client_allocations_pending{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"})',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: 'Pending',
                refId: 'C',
              },
              {
                datasource: {
                  type: 'prometheus',
                  uid: '${datasource}',
                },
                exemplar: true,
                expr: 'sum by (datacenter)  (nomad_client_allocations_running{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"})',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: 'Running',
                refId: 'D',
              },
              {
                datasource: {
                  type: 'prometheus',
                  uid: '${datasource}',
                },
                exemplar: true,
                expr: 'sum by (datacenter)  (nomad_client_allocations_terminal{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"})',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: 'Terminal',
                refId: 'E',
              },
            ],
            title: 'Summary',
            type: 'state-timeline',
          },
          {
            collapsed: false,
            datasource: {
              type: 'prometheus',
              uid: '$datasource',
            },
            gridPos: {
              h: 1,
              w: 24,
              x: 0,
              y: 6,
            },
            id: 2,
            panels: [],
            targets: [
              {
                datasource: {
                  type: 'prometheus',
                  uid: '$datasource',
                },
                refId: 'A',
              },
            ],
            title: 'Nomad clients',
            type: 'row',
          },
          {
            datasource: {
              uid: '$datasource',
            },
            fieldConfig: {
              defaults: {
                color: {
                  mode: 'thresholds',
                },
                decimals: 1,
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
                unit: 'dtdurations',
              },
              overrides: [],
            },
            gridPos: {
              h: 5,
              w: 4,
              x: 0,
              y: 7,
            },
            id: 4,
            links: [],
            maxDataPoints: 100,
            options: {
              colorMode: 'none',
              graphMode: 'none',
              justifyMode: 'auto',
              orientation: 'horizontal',
              reduceOptions: {
                calcs: [
                  'lastNotNull',
                ],
                fields: '',
                values: false,
              },
              text: {},
              textMode: 'auto',
              wideLayout: true,
            },
            pluginVersion: '10.2.1',
            repeat: 'instance',
            repeatDirection: 'v',
            targets: [
              {
                datasource: {
                  uid: '$datasource',
                },
                expr: 'nomad_client_uptime{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"}',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: '',
                refId: 'A',
              },
            ],
            title: 'Uptime',
            type: 'stat',
          },
          {
            datasource: {
              uid: '$datasource',
            },
            fieldConfig: {
              defaults: {
                color: {
                  mode: 'thresholds',
                },
                mappings: [],
                max: 100,
                min: 0,
                thresholds: {
                  mode: 'absolute',
                  steps: [
                    {
                      color: 'green',
                      value: null,
                    },
                    {
                      color: 'yellow',
                      value: 80,
                    },
                    {
                      color: 'red',
                      value: 90,
                    },
                  ],
                },
                unit: 'percent',
              },
              overrides: [],
            },
            gridPos: {
              h: 5,
              w: 5,
              x: 4,
              y: 7,
            },
            id: 7,
            links: [],
            maxDataPoints: 100,
            options: {
              minVizHeight: 75,
              minVizWidth: 75,
              orientation: 'horizontal',
              reduceOptions: {
                calcs: [
                  'lastNotNull',
                ],
                fields: '',
                values: false,
              },
              showThresholdLabels: false,
              showThresholdMarkers: true,
              text: {},
            },
            pluginVersion: '10.2.1',
            repeat: 'instance',
            repeatDirection: 'v',
            targets: [
              {
                datasource: {
                  uid: '$datasource',
                },
                expr: '100-sum(nomad_client_host_cpu_idle{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"}) / count(nomad_client_host_cpu_idle{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"})',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: '',
                refId: 'A',
              },
            ],
            title: 'CPU usage',
            type: 'gauge',
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
                  axisBorderShow: false,
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
                  insertNulls: false,
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
                links: [],
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
              h: 5,
              w: 5,
              x: 9,
              y: 7,
            },
            id: 11,
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
                sort: 'none',
              },
            },
            pluginVersion: '10.2.1',
            repeat: 'instance',
            repeatDirection: 'v',
            targets: [
              {
                datasource: {
                  uid: '$datasource',
                },
                expr: 'nomad_client_host_memory_total{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"}',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: 'Total',
                refId: 'B',
              },
              {
                datasource: {
                  uid: '$datasource',
                },
                expr: 'nomad_client_host_memory_free{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"}',
                format: 'time_series',
                instant: false,
                interval: '',
                intervalFactor: 1,
                legendFormat: 'Free',
                refId: 'A',
              },
              {
                datasource: {
                  uid: '$datasource',
                },
                expr: 'nomad_client_host_memory_used{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"}',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: 'Used',
                refId: 'C',
              },
              {
                datasource: {
                  uid: '$datasource',
                },
                expr: 'nomad_client_host_memory_available{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"}',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: 'Available',
                refId: 'D',
              },
            ],
            title: 'Memory',
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
                  axisBorderShow: false,
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
                  insertNulls: false,
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
                decimals: 0,
                links: [],
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
              h: 5,
              w: 5,
              x: 14,
              y: 7,
            },
            id: 13,
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
                sort: 'none',
              },
            },
            pluginVersion: '10.2.1',
            repeat: 'instance',
            repeatDirection: 'v',
            targets: [
              {
                datasource: {
                  uid: '$datasource',
                },
                expr: 'max(nomad_client_host_disk_size{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"}) by (disk)',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: 'Total - {{disk}}',
                refId: 'B',
              },
              {
                datasource: {
                  uid: '$datasource',
                },
                expr: 'avg(nomad_client_host_disk_available{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"}) by (disk)',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: 'Available - {{disk}}',
                refId: 'A',
              },
            ],
            title: 'Disk usage',
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
                  axisBorderShow: false,
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
                  insertNulls: false,
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
                links: [],
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
              h: 5,
              w: 5,
              x: 19,
              y: 7,
            },
            id: 15,
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
                sort: 'none',
              },
            },
            pluginVersion: '10.2.1',
            repeat: 'instance',
            repeatDirection: 'v',
            targets: [
              {
                datasource: {
                  uid: '$datasource',
                },
                expr: 'avg(nomad_client_host_disk_inodes_percent{job=~"$job", datacenter=~"$datacenter", instance=~"$instance"}) by (disk)',
                format: 'time_series',
                interval: '',
                intervalFactor: 1,
                legendFormat: '{{disk}}',
                refId: 'A',
              },
            ],
            title: 'Disk inodes',
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
              allValue: '.+',
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
                isNone: true,
                selected: false,
                text: 'None',
                value: '',
              },
              datasource: {
                type: 'prometheus',
                uid: '${datasource}',
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
              current: {
                selected: false,
                text: 'All',
                value: '$__all',
              },
              datasource: {
                type: 'prometheus',
                uid: '${datasource}',
              },
              definition: 'label_values(nomad_client_uptime{datacenter="$datacenter"}, instance)',
              hide: 0,
              includeAll: true,
              allValue: '.+',
              label: 'Instance',
              multi: true,
              name: 'instance',
              options: [],
              query: {
                query: 'label_values(nomad_client_uptime{datacenter="$datacenter"}, instance)',
                refId: 'prometheus-instance-Variable-Query',
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
        title: 'Nomad cluster',
        uid: 'CiP3mZVik',
        version: 4,
        weekStart: '',
      },
  },
}
