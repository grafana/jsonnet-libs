local grafana = import 'github.com/grafana/grafonnet-lib/grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local dashboardUid = 'apache-http';
local matcher = 'job=~"$job", instance=~"$instance"';

{
  grafanaDashboards+:: {

    'apache-http.json':
      dashboard.new(
        'Apache HTTP server',
        time_from='%s' % $._config.dashboardPeriod,
        editable=false,
        tags=($._config.dashboardTags),
        timezone='%s' % $._config.dashboardTimezone,
        refresh='%s' % $._config.dashboardRefresh,
        graphTooltip='shared_crosshair',
        uid=dashboardUid,
      )
      .addLink(grafana.link.dashboards(
        asDropdown=false,
        title='Other Apache HTTP dashboards',
        includeVars=true,
        keepTime=true,
        tags=($._config.dashboardTags),
      )).addTemplates(
        [
          {
            hide: 0,
            label: 'Data source',
            name: 'prometheus_datasource',
            query: 'prometheus',
            refresh: 1,
            regex: '',
            type: 'datasource',
          },
          template.new(
            name='job',
            label='job',
            datasource='$prometheus_datasource',
            query='label_values(apache_up, job)',
            current='',
            refresh=2,
            includeAll=true,
            multi=true,
            allValues='.+',
            sort=1
          ),
          template.new(
            name='instance',
            label='instance',
            datasource='$prometheus_datasource',
            query='label_values(apache_up{job=~"$job"}, instance)',
            current='',
            refresh=2,
            includeAll=false,
            sort=1
          ),
        ]
      )
      .addPanels([
        {
          datasource: {
            uid: '${prometheus_datasource}',
          },
          fieldConfig: {
            defaults: {
              color: {
                mode: 'thresholds',
              },
              decimals: 1,
              mappings: [
                {
                  options: {
                    match: 'null',
                    result: {
                      text: 'N/A',
                    },
                  },
                  type: 'special',
                },
              ],
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
              unit: 's',
            },
            overrides: [],
          },
          gridPos: {
            h: 3,
            w: 4,
            x: 0,
            y: 0,
          },
          id: 8,
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
            textMode: 'auto',
          },
          pluginVersion: '8.4.5',
          targets: [
            {
              expr: 'apache_uptime_seconds_total{' + matcher + '}',
              format: 'time_series',
              intervalFactor: 1,
              refId: 'A',
              step: 240,
            },
          ],
          title: 'Uptime',
          type: 'stat',
        },
        {
          id: 9,
          gridPos: {
            h: 3,
            w: 4,
            x: 4,
            y: 0,
          },
          type: 'stat',
          title: 'Version',
          datasource: {
            uid: '${prometheus_datasource}',
            type: 'prometheus',
          },
          pluginVersion: '8.4.5',
          maxDataPoints: 100,
          links: [],
          fieldConfig: {
            defaults: {
              mappings: [
                {
                  options: {
                    match: 'null',
                    result: {
                      text: 'N/A',
                    },
                  },
                  type: 'special',
                },
              ],
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
              color: {
                mode: 'thresholds',
              },
              decimals: 1,
              unit: 'none',
            },
            overrides: [],
          },
          options: {
            reduceOptions: {
              values: false,
              calcs: [
                'lastNotNull',
              ],
              fields: '',
            },
            orientation: 'horizontal',
            textMode: 'auto',
            colorMode: 'none',
            graphMode: 'none',
            justifyMode: 'auto',
          },
          targets: [
            {
              expr: 'apache_version{' + matcher + '}',
              legendFormat: '',
              interval: '',
              exemplar: true,
              format: 'time_series',
              intervalFactor: 1,
              refId: 'A',
              step: 240,
            },
          ],
        },
        {
          id: 5,
          gridPos: {
            h: 3,
            w: 16,
            x: 8,
            y: 0,
          },
          type: 'state-timeline',
          title: 'Apache Up / Down',
          datasource: {
            uid: '${prometheus_datasource}',
            type: 'prometheus',
          },
          pluginVersion: '8.4.5',
          links: [],
          options: {
            mergeValues: false,
            showValue: 'never',
            alignValue: 'left',
            rowHeight: 0.9,
            legend: {
              displayMode: 'list',
              placement: 'right',
            },
            tooltip: {
              mode: 'single',
              sort: 'none',
            },
          },
          targets: [
            {
              expr: 'apache_up{' + matcher + '}',
              legendFormat: 'Apache up',
              interval: '',
              exemplar: true,
              format: 'time_series',
              intervalFactor: 1,
              refId: 'A',
              step: 240,
            },
          ],
          fieldConfig: {
            defaults: {
              custom: {
                lineWidth: 0,
                fillOpacity: 70,
                spanNulls: false,
              },
              color: {
                mode: 'continuous-GrYlRd',
              },
              mappings: [
                {
                  type: 'value',
                  options: {
                    '0': {
                      text: 'Down',
                      color: 'red',
                      index: 1,
                    },
                    '1': {
                      text: 'Up',
                      color: 'green',
                      index: 0,
                    },
                  },
                },
              ],
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
          timeFrom: null,
          timeShift: null,
        },
        {
          id: 3,
          gridPos: {
            h: 7,
            w: 12,
            x: 12,
            y: 3,
          },
          type: 'timeseries',
          title: 'Response time',
          datasource: {
            uid: '${prometheus_datasource}',
          },
          pluginVersion: '8.4.5',
          links: [],
          fieldConfig: {
            defaults: {
              custom: {
                drawStyle: 'line',
                lineInterpolation: 'linear',
                barAlignment: 0,
                lineWidth: 1,
                fillOpacity: 10,
                gradientMode: 'none',
                spanNulls: true,
                showPoints: 'never',
                pointSize: 5,
                stacking: {
                  mode: 'none',
                  group: 'A',
                },
                axisPlacement: 'auto',
                axisLabel: '',
                scaleDistribution: {
                  type: 'linear',
                },
                hideFrom: {
                  tooltip: false,
                  viz: false,
                  legend: false,
                },
                thresholdsStyle: {
                  mode: 'off',
                },
              },
              color: {
                mode: 'palette-classic',
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
              unit: 'ms',
            },
            overrides: [],
          },
          options: {
            tooltip: {
              mode: 'multi',
              sort: 'none',
            },
            legend: {
              displayMode: 'table',
              placement: 'bottom',
              calcs: [
                'mean',
                'lastNotNull',
                'max',
                'min',
              ],
            },
          },
          targets: [
            {
              expr: 'increase(apache_duration_ms_total{' + matcher + '}[$__rate_interval])/increase(apache_accesses_total{' + matcher + '}[$__rate_interval])',
              legendFormat: 'Average response time',
              interval: '',
              exemplar: false,
              format: 'time_series',
              intervalFactor: 1,
              refId: 'A',
              step: 240,
              datasource: {
                uid: '${prometheus_datasource}',
                type: 'prometheus',
              },
            },
          ],
          timeFrom: null,
          timeShift: null,
        },
        {
          id: 6,
          gridPos: {
            h: 7,
            w: 12,
            x: 0,
            y: 3,
          },
          type: 'timeseries',
          title: 'Load',
          datasource: {
            uid: '${prometheus_datasource}',
          },
          pluginVersion: '8.4.5',
          links: [],
          fieldConfig: {
            defaults: {
              custom: {
                drawStyle: 'line',
                lineInterpolation: 'linear',
                barAlignment: 0,
                lineWidth: 1,
                fillOpacity: 10,
                gradientMode: 'none',
                spanNulls: true,
                showPoints: 'never',
                pointSize: 5,
                stacking: {
                  mode: 'none',
                  group: 'A',
                },
                axisPlacement: 'auto',
                axisLabel: '',
                scaleDistribution: {
                  type: 'linear',
                },
                hideFrom: {
                  tooltip: false,
                  viz: false,
                  legend: false,
                },
                thresholdsStyle: {
                  mode: 'off',
                },
                lineStyle: {
                  fill: 'solid',
                },
              },
              color: {
                mode: 'palette-classic',
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
              unit: 'reqps',
            },
            overrides: [
              {
                matcher: {
                  id: 'byName',
                  options: 'Bytes sent',
                },
                properties: [
                  {
                    id: 'custom.axisPlacement',
                    value: 'right',
                  },
                  {
                    id: 'custom.drawStyle',
                    value: 'bars',
                  },
                  {
                    id: 'unit',
                    value: 'Bps',
                  },
                ],
              },
            ],
          },
          options: {
            tooltip: {
              mode: 'multi',
              sort: 'none',
            },
            legend: {
              displayMode: 'table',
              placement: 'bottom',
              calcs: [
                'mean',
                'lastNotNull',
                'max',
                'min',
              ],
            },
          },
          targets: [
            {
              expr: 'rate(apache_accesses_total{' + matcher + '}[$__rate_interval])',
              legendFormat: 'Calls',
              interval: '',
              exemplar: false,
              format: 'time_series',
              intervalFactor: 1,
              refId: 'A',
              step: 240,
              datasource: {
                type: 'prometheus',
                uid: '${prometheus_datasource}',
              },
            },
            {
              expr: 'rate(apache_sent_kilobytes_total{' + matcher + '}[$__rate_interval]) * 1000',
              legendFormat: 'Bytes sent',
              interval: '',
              exemplar: false,
              datasource: {
                uid: '${prometheus_datasource}',
                type: 'prometheus',
              },
              refId: 'B',
              hide: false,
            },
          ],
          timeFrom: null,
          timeShift: null,
          description: '',
        },
        {
          id: 2,
          gridPos: {
            h: 10,
            w: 24,
            x: 0,
            y: 13,
          },
          type: 'timeseries',
          title: 'Apache scoreboard statuses',
          datasource: {
            uid: '${prometheus_datasource}',
          },
          pluginVersion: '8.4.5',
          links: [],
          options: {
            tooltip: {
              mode: 'multi',
              sort: 'desc',
            },
            legend: {
              displayMode: 'table',
              placement: 'right',
              calcs: [
                'mean',
                'lastNotNull',
                'max',
                'min',
              ],
              sortBy: 'Last *',
              sortDesc: true,
            },
          },
          targets: [
            {
              expr: 'apache_scoreboard{' + matcher + '}',
              format: 'time_series',
              intervalFactor: 1,
              legendFormat: '{{ state }}',
              refId: 'A',
              step: 240,
            },
          ],
          fieldConfig: {
            defaults: {
              custom: {
                drawStyle: 'line',
                lineInterpolation: 'stepAfter',
                barAlignment: 0,
                lineWidth: 1,
                fillOpacity: 10,
                gradientMode: 'none',
                spanNulls: true,
                showPoints: 'never',
                pointSize: 5,
                stacking: {
                  mode: 'normal',
                  group: 'A',
                },
                axisPlacement: 'auto',
                axisLabel: '',
                scaleDistribution: {
                  type: 'linear',
                },
                hideFrom: {
                  tooltip: false,
                  viz: false,
                  legend: false,
                },
                thresholdsStyle: {
                  mode: 'off',
                },
              },
              color: {
                mode: 'palette-classic',
              },
              mappings: [],
              thresholds: {
                mode: 'absolute',
                steps: [
                  {
                    value: null,
                    color: 'green',
                  },
                  {
                    value: 80,
                    color: 'red',
                  },
                ],
              },
              unit: 'short',
            },
            overrides: [],
          },
          timeFrom: null,
          timeShift: null,
        },
        {
          id: 7,
          gridPos: {
            h: 10,
            w: 12,
            x: 0,
            y: 23,
          },
          type: 'timeseries',
          title: 'Apache worker statuses',
          datasource: {
            uid: '${prometheus_datasource}',
          },
          pluginVersion: '8.4.5',
          links: [],
          options: {
            tooltip: {
              mode: 'multi',
              sort: 'none',
            },
            legend: {
              displayMode: 'table',
              placement: 'bottom',
              calcs: [
                'mean',
                'lastNotNull',
                'max',
                'min',
              ],
            },
          },
          targets: [
            {
              expr: 'apache_workers{' + matcher + '}\n',
              format: 'time_series',
              intervalFactor: 1,
              legendFormat: '{{ state }}',
              refId: 'A',
              step: 240,
            },
          ],
          fieldConfig: {
            defaults: {
              custom: {
                drawStyle: 'line',
                lineInterpolation: 'stepAfter',
                barAlignment: 0,
                lineWidth: 1,
                fillOpacity: 10,
                gradientMode: 'none',
                spanNulls: true,
                showPoints: 'never',
                pointSize: 5,
                stacking: {
                  mode: 'normal',
                  group: 'A',
                },
                axisPlacement: 'auto',
                axisLabel: '',
                scaleDistribution: {
                  type: 'linear',
                },
                hideFrom: {
                  tooltip: false,
                  viz: false,
                  legend: false,
                },
                thresholdsStyle: {
                  mode: 'off',
                },
              },
              color: {
                mode: 'palette-classic',
              },
              mappings: [],
              thresholds: {
                mode: 'absolute',
                steps: [
                  {
                    value: null,
                    color: 'green',
                  },
                  {
                    value: 80,
                    color: 'red',
                  },
                ],
              },
              unit: 'short',
            },
            overrides: [],
          },
          timeFrom: null,
          timeShift: null,
        },
        {
          id: 8,
          gridPos: {
            h: 10,
            w: 12,
            x: 12,
            y: 23,
          },
          type: 'timeseries',
          title: 'Apache CPU load',
          datasource: {
            uid: '${prometheus_datasource}',
          },
          pluginVersion: '8.4.5',
          links: [],
          options: {
            tooltip: {
              mode: 'multi',
              sort: 'none',
            },
            legend: {
              displayMode: 'table',
              placement: 'bottom',
              calcs: [
                'mean',
                'lastNotNull',
                'max',
                'min',
              ],
            },
          },
          targets: [
            {
              expr: 'apache_cpuload{' + matcher + '}',
              format: 'time_series',
              intervalFactor: 1,
              legendFormat: 'Load',
              refId: 'A',
              step: 240,
            },
          ],
          fieldConfig: {
            defaults: {
              custom: {
                drawStyle: 'line',
                lineInterpolation: 'linear',
                barAlignment: 0,
                lineWidth: 1,
                fillOpacity: 10,
                gradientMode: 'none',
                spanNulls: true,
                showPoints: 'never',
                pointSize: 5,
                stacking: {
                  mode: 'none',
                  group: 'A',
                },
                axisPlacement: 'auto',
                axisLabel: '',
                scaleDistribution: {
                  type: 'linear',
                },
                hideFrom: {
                  tooltip: false,
                  viz: false,
                  legend: false,
                },
                thresholdsStyle: {
                  mode: 'off',
                },
              },
              color: {
                mode: 'palette-classic',
              },
              mappings: [],
              thresholds: {
                mode: 'absolute',
                steps: [
                  {
                    value: null,
                    color: 'green',
                  },
                  {
                    value: 80,
                    color: 'red',
                  },
                ],
              },
              unit: 'short',
              min: 0,
            },
            overrides: [],
          },
          timeFrom: null,
          timeShift: null,
        },
      ]),

  },
}
