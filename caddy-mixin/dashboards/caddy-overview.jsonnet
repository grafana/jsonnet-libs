{
  local matcher = 'job=~"$job", server=~"$service", instance=~"$instance"',
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
        limit: 100,
        name: 'Annotations & Alerts',
        showIn: 0,
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
  gnetId: 13460,
  graphTooltip: 0,
  id: 10,
  iteration: 1633116262227,
  links: [],
  panels: [
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
            lineWidth: 2,
            pointSize: 5,
            scaleDistribution: {
              log: 10,
              type: 'log',
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
        h: 11,
        w: 12,
        x: 0,
        y: 0,
      },
      id: 2,
      options: {
        legend: {
          calcs: [],
          displayMode: 'list',
          placement: 'bottom',
          showLegend: false,
        },
        tooltip: {
          mode: 'multi',
          sort: 'none',
        },
      },
      pluginVersion: '10.2.0',
      targets: [
        {
          datasource: {
            uid: '$datasource',
          },
          expr: 'sum(rate(caddy_http_requests_total{' + matcher + '}[$__rate_interval])) by (handler)',
          interval: '',
          legendFormat: '{{handler}}',
          refId: 'A',
        },
      ],
      title: 'Requests',
      type: 'timeseries',
    },
    {
      datasource: {
        uid: '$datasource',
      },
      description: '',
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
            lineWidth: 2,
            pointSize: 5,
            scaleDistribution: {
              type: 'linear',
            },
            showPoints: 'never',
            spanNulls: false,
            stacking: {
              group: 'A',
              mode: 'normal',
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
        h: 11,
        w: 12,
        x: 12,
        y: 0,
      },
      id: 7,
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
      pluginVersion: '10.2.0',
      targets: [
        {
          datasource: {
            uid: '$datasource',
          },
          expr: 'sum(irate(caddy_http_request_duration_seconds_count{' + matcher + '}[$__rate_interval])) by (code)',
          interval: '',
          legendFormat: '{{code}}',
          refId: 'A',
        },
      ],
      title: 'Requests by Response Code',
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
            lineWidth: 2,
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
        h: 9,
        w: 12,
        x: 0,
        y: 11,
      },
      id: 8,
      options: {
        legend: {
          calcs: [],
          displayMode: 'list',
          placement: 'bottom',
          showLegend: false,
        },
        tooltip: {
          mode: 'multi',
          sort: 'none',
        },
      },
      pluginVersion: '10.2.0',
      targets: [
        {
          datasource: {
            uid: '$datasource',
          },
          expr: 'avg(avg_over_time(caddy_http_requests_in_flight{' + matcher + '}[$__rate_interval])) by (handler)',
          hide: false,
          interval: '',
          legendFormat: '{{handler}}',
          refId: 'E',
        },
      ],
      title: 'Requests In Flight',
      type: 'timeseries',
    },
    {
      datasource: {
        uid: '$datasource',
      },
      description: '',
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
            drawStyle: 'bars',
            fillOpacity: 100,
            gradientMode: 'none',
            hideFrom: {
              legend: false,
              tooltip: false,
              viz: false,
            },
            insertNulls: false,
            lineInterpolation: 'linear',
            lineWidth: 2,
            pointSize: 5,
            scaleDistribution: {
              type: 'linear',
            },
            showPoints: 'never',
            spanNulls: false,
            stacking: {
              group: 'A',
              mode: 'normal',
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
          unit: 'none',
        },
        overrides: [],
      },
      gridPos: {
        h: 9,
        w: 12,
        x: 12,
        y: 11,
      },
      id: 5,
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
      pluginVersion: '10.2.0',
      targets: [
        {
          datasource: {
            uid: '$datasource',
          },
          expr: 'sum(irate(caddy_http_request_duration_seconds_count{' + matcher + '}[$__rate_interval])) by (code)',
          interval: '',
          legendFormat: '{{code}}',
          refId: 'A',
        },
      ],
      title: 'Requests by Response Code (%)',
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
            lineWidth: 2,
            pointSize: 5,
            scaleDistribution: {
              log: 2,
              type: 'log',
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
          unit: 's',
        },
        overrides: [],
      },
      gridPos: {
        h: 9,
        w: 12,
        x: 0,
        y: 20,
      },
      id: 4,
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
      pluginVersion: '10.2.0',
      targets: [
        {
          datasource: {
            uid: '$datasource',
          },
          expr: 'histogram_quantile(0.99, sum(rate(caddy_http_request_duration_seconds_bucket{' + matcher + '}[$__rate_interval])) by (le))',
          interval: '',
          legendFormat: 'p99',
          refId: 'A',
        },
        {
          datasource: {
            uid: '$datasource',
          },
          expr: 'histogram_quantile(0.95, sum(rate(caddy_http_request_duration_seconds_bucket{' + matcher + '}[$__rate_interval])) by (le))',
          interval: '',
          legendFormat: 'p95',
          refId: 'B',
        },
        {
          datasource: {
            uid: '$datasource',
          },
          expr: 'histogram_quantile(0.90, sum(rate(caddy_http_request_duration_seconds_bucket{' + matcher + '}[$__rate_interval])) by (le))',
          interval: '',
          legendFormat: 'p90',
          refId: 'C',
        },
        {
          datasource: {
            uid: '$datasource',
          },
          expr: 'histogram_quantile(0.75, sum(rate(caddy_http_request_duration_seconds_bucket{' + matcher + '}[$__rate_interval])) by (le))',
          interval: '',
          legendFormat: 'p75',
          refId: 'D',
        },
        {
          datasource: {
            uid: '$datasource',
          },
          expr: 'histogram_quantile(0.5, sum(rate(caddy_http_request_duration_seconds_bucket{' + matcher + '}[$__rate_interval])) by (le))',
          interval: '',
          legendFormat: 'p50',
          refId: 'E',
        },
      ],
      title: 'Request Duration (percentile)',
      type: 'timeseries',
    },
    {
      cards: {},
      color: {
        cardColor: '#b4ff00',
        colorScale: 'linear',
        colorScheme: 'interpolateInferno',
        exponent: 0.5,
        mode: 'spectrum',
      },
      dataFormat: 'tsbuckets',
      datasource: {
        uid: '$datasource',
      },
      fieldConfig: {
        defaults: {
          custom: {
            hideFrom: {
              legend: false,
              tooltip: false,
              viz: false,
            },
            scaleDistribution: {
              type: 'linear',
            },
          },
        },
        overrides: [],
      },
      gridPos: {
        h: 9,
        w: 12,
        x: 12,
        y: 20,
      },
      heatmap: {},
      hideZeroBuckets: true,
      highlightCards: true,
      id: 6,
      interval: '',
      legend: {
        show: true,
      },
      maxDataPoints: 25,
      options: {
        calculate: false,
        calculation: {},
        cellGap: 2,
        cellValues: {},
        color: {
          exponent: 0.5,
          fill: '#b4ff00',
          mode: 'scheme',
          reverse: false,
          scale: 'exponential',
          scheme: 'Inferno',
          steps: 128,
        },
        exemplars: {
          color: 'rgba(255,0,255,0.7)',
        },
        filterValues: {
          le: 1e-9,
        },
        legend: {
          show: true,
        },
        rowsFrame: {
          layout: 'auto',
        },
        showValue: 'never',
        tooltip: {
          show: true,
          yHistogram: false,
        },
        yAxis: {
          axisPlacement: 'left',
          reverse: false,
          unit: 's',
        },
      },
      pluginVersion: '10.2.0',
      reverseYBuckets: false,
      targets: [
        {
          datasource: {
            uid: '$datasource',
          },
          expr: 'sum(increase(caddy_http_request_duration_seconds_bucket{' + matcher + '}[$__rate_interval])) by (le)',
          format: 'heatmap',
          interval: '',
          legendFormat: '{{le}}',
          refId: 'A',
        },
      ],
      title: 'Request Duration (heatmap)',
      tooltip: {
        show: true,
        showHistogram: false,
      },
      type: 'heatmap',
      xAxis: {
        show: true,
      },
      yAxis: {
        format: 's',
        logBase: 1,
        show: true,
      },
      yBucketBound: 'auto',
    },
  ],
  refresh: '30s',
  schemaVersion: 38,
  style: 'dark',
  tags: [
    'caddy-integration',
  ],
  templating: {
    list: [
      {
        current: {
          selected: false,
          text: 'Prometheus',
          value: 'Prometheus',
        },
        hide: 0,
        includeAll: false,
        label: 'Data source',
        multi: false,
        name: 'datasource',
        options: [],
        query: 'prometheus',
        queryValue: '',
        refresh: 1,
        regex: '(?!grafanacloud-usage|grafanacloud-ml-metrics).+',
        skipUrlSync: false,
        type: 'datasource',
      },
      {
        allValue: '.+',
        current: {
          selected: false,
          text: 'All',
          value: '$__all',
        },
        datasource: {
          uid: '$datasource',
        },
        definition: '',
        hide: 0,
        includeAll: true,
        label: 'Job',
        multi: true,
        name: 'job',
        options: [],
        query: 'label_values(caddy_http_requests_total, job)',
        refresh: 2,
        regex: '',
        skipUrlSync: false,
        sort: 1,
        tagValuesQuery: '',
        tags: [],
        tagsQuery: '',
        type: 'query',
        useTags: false,
      },
      {
        allValue: '.+',
        current: {
          selected: false,
          text: 'All',
          value: '$__all',
        },
        datasource: {
          uid: '$datasource',
        },
        definition: "label_values(caddy_http_requests_total{job=~\"'$job'\"} server)",
        hide: 0,
        includeAll: true,
        label: 'service',
        multi: true,
        name: 'service',
        options: [],
        query: {
          qryType: 1,
          query: "label_values(caddy_http_requests_total{job=~\"'$job'\"}, server)",
          refId: 'PrometheusVariableQueryEditor-VariableQuery',
        },
        refresh: 2,
        regex: '',
        skipUrlSync: false,
        sort: 1,
        tagValuesQuery: '',
        tags: [],
        tagsQuery: '',
        type: 'query',
        useTags: false,
      },
      {
        allValue: '.+',
        current: {
          selected: false,
          text: 'All',
          value: '$__all',
        },
        datasource: {
          uid: '$datasource',
        },
        definition: "label_values(caddy_http_requests_total{job=~\"'$job'\", server=~\"$service\"}, instance)",
        hide: 0,
        includeAll: true,
        label: 'Instance',
        multi: true,
        name: 'instance',
        options: [],
        query: {
          qryType: 1,
          query: "label_values(caddy_http_requests_total{job=~\"'$job'\", server=~\"$service\"}, instance)",
          refId: 'PrometheusVariableQueryEditor-VariableQuery',
        },
        refresh: 2,
        regex: '',
        skipUrlSync: false,
        sort: 1,
        tagValuesQuery: '',
        tags: [],
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
  },
  timezone: '',
  title: 'Caddy Overview',
  uid: '9B0qPnfMz',
  version: 9,
}
