local config = (import '../config.libsonnet');
local g = import '../g.libsonnet';
local var = import '../variables.libsonnet';
local commonvars = var.new(
  varMetric='kafka_log_log_size',
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
          datasource: '-- Grafana --',
          enable: true,
          hide: true,
          iconColor: 'rgba(0, 211, 255, 1)',
          name: 'Annotations & Alerts',
          type: 'dashboard',
        },
      ],
    },
    editable: true,
    gnetId: null,
    graphTooltip: 0,
    id: 3,
    iteration: 1623181859642,
    links: [],
    panels: [
      {
        aliasColors: {},
        bars: false,
        dashLength: 10,
        dashes: false,
        datasource: '${datasource}',
        fieldConfig: {
          defaults: {},
          overrides: [],
        },
        fill: 1,
        fillGradient: 0,
        gridPos: {
          h: 9,
          w: 24,
          x: 0,
          y: 0,
        },
        hiddenSeries: false,
        id: 2,
        legend: {
          alignAsTable: true,
          avg: true,
          current: true,
          max: true,
          min: false,
          rightSide: false,
          show: true,
          sort: 'current',
          sortDesc: true,
          total: false,
          values: true,
        },
        lines: true,
        linewidth: 1,
        nullPointMode: 'null',
        options: {
          alertThreshold: true,
        },
        percentage: false,
        pluginVersion: '7.5.6',
        pointradius: 2,
        points: false,
        renderer: 'flot',
        seriesOverrides: [],
        spaceLength: 10,
        stack: false,
        steppedLine: false,
        targets: [
          {
            expr: 'sum without(instance) (rate(kafka_server_brokertopicmetrics_messagesinpersec{' + commonvars.queriesSelector + ',topic=~"$topic"}[$__rate_interval]))',
            interval: '',
            legendFormat: '{{topic}}',
            refId: 'A',
          },
        ],
        thresholds: [],
        timeFrom: null,
        timeRegions: [],
        timeShift: null,
        title: 'Messages In',
        tooltip: {
          shared: true,
          sort: 0,
          value_type: 'individual',
        },
        type: 'graph',
        xaxis: {
          buckets: null,
          mode: 'time',
          name: null,
          show: true,
          values: [],
        },
        yaxes: [
          {
            format: 'short',
            label: null,
            logBase: 1,
            max: null,
            min: '0',
            show: true,
          },
          {
            format: 'short',
            label: null,
            logBase: 1,
            max: null,
            min: null,
            show: true,
          },
        ],
        yaxis: {
          align: false,
          alignLevel: null,
        },
      },
      {
        aliasColors: {},
        bars: false,
        dashLength: 10,
        dashes: false,
        datasource: '${datasource}',
        fieldConfig: {
          defaults: {},
          overrides: [],
        },
        fill: 1,
        fillGradient: 0,
        gridPos: {
          h: 9,
          w: 12,
          x: 0,
          y: 9,
        },
        hiddenSeries: false,
        id: 3,
        legend: {
          alignAsTable: true,
          avg: true,
          current: true,
          max: true,
          min: false,
          show: true,
          sort: 'current',
          sortDesc: true,
          total: false,
          values: true,
        },
        lines: true,
        linewidth: 1,
        nullPointMode: 'null',
        options: {
          alertThreshold: true,
        },
        percentage: false,
        pluginVersion: '7.5.6',
        pointradius: 2,
        points: false,
        renderer: 'flot',
        seriesOverrides: [],
        spaceLength: 10,
        stack: false,
        steppedLine: false,
        targets: [
          {
            expr: 'sum without(instance) (rate(kafka_server_brokertopicmetrics_bytesinpersec{' + commonvars.queriesSelector + ',topic=~"$topic"}[$__rate_interval]))',
            interval: '',
            legendFormat: '{{topic}}',
            refId: 'A',
          },
        ],
        thresholds: [],
        timeFrom: null,
        timeRegions: [],
        timeShift: null,
        title: 'Bytes In',
        tooltip: {
          shared: true,
          sort: 0,
          value_type: 'individual',
        },
        type: 'graph',
        xaxis: {
          buckets: null,
          mode: 'time',
          name: null,
          show: true,
          values: [],
        },
        yaxes: [
          {
            format: 'binBps',
            label: null,
            logBase: 1,
            max: null,
            min: null,
            show: true,
          },
          {
            format: 'short',
            label: null,
            logBase: 1,
            max: null,
            min: null,
            show: true,
          },
        ],
        yaxis: {
          align: false,
          alignLevel: null,
        },
      },
      {
        aliasColors: {},
        bars: false,
        dashLength: 10,
        dashes: false,
        datasource: '${datasource}',
        fieldConfig: {
          defaults: {},
          overrides: [],
        },
        fill: 1,
        fillGradient: 0,
        gridPos: {
          h: 9,
          w: 12,
          x: 12,
          y: 9,
        },
        hiddenSeries: false,
        id: 4,
        legend: {
          alignAsTable: true,
          avg: true,
          current: true,
          hideZero: false,
          max: true,
          min: false,
          show: true,
          sort: 'current',
          sortDesc: true,
          total: false,
          values: true,
        },
        lines: true,
        linewidth: 1,
        nullPointMode: 'null',
        options: {
          alertThreshold: true,
        },
        percentage: false,
        pluginVersion: '7.5.6',
        pointradius: 2,
        points: false,
        renderer: 'flot',
        seriesOverrides: [],
        spaceLength: 10,
        stack: false,
        steppedLine: false,
        targets: [
          {
            expr: 'sum without(instance) (rate(kafka_server_brokertopicmetrics_bytesoutpersec{' + commonvars.queriesSelector + ',topic=~"$topic"}[$__rate_interval]))',
            interval: '',
            legendFormat: '{{topic}}',
            refId: 'A',
          },
        ],
        thresholds: [],
        timeFrom: null,
        timeRegions: [],
        timeShift: null,
        title: 'Bytes Out',
        tooltip: {
          shared: true,
          sort: 0,
          value_type: 'individual',
        },
        type: 'graph',
        xaxis: {
          buckets: null,
          mode: 'time',
          name: null,
          show: true,
          values: [],
        },
        yaxes: [
          {
            format: 'binBps',
            label: null,
            logBase: 1,
            max: null,
            min: null,
            show: true,
          },
          {
            format: 'short',
            label: null,
            logBase: 1,
            max: null,
            min: null,
            show: true,
          },
        ],
        yaxis: {
          align: false,
          alignLevel: null,
        },
      },
      {
        datasource: '${datasource}',
        description: '',
        fieldConfig: {
          defaults: {
            custom: {
              align: null,
              filterable: false,
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
          },
          overrides: [
            {
              matcher: {
                id: 'byName',
                options: 'partition',
              },
              properties: [
                {
                  id: 'custom.width',
                  value: 103,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'offset',
              },
              properties: [
                {
                  id: 'custom.width',
                  value: 226,
                },
              ],
            },
          ],
        },
        gridPos: {
          h: 8,
          w: 12,
          x: 0,
          y: 18,
        },
        id: 6,
        options: {
          showHeader: true,
          sortBy: [
            {
              desc: false,
              displayName: 'partition',
            },
          ],
        },
        pluginVersion: '7.5.6',
        targets: [
          {
            expr: 'kafka_log_log_logstartoffset{' + commonvars.queriesSelector + ',topic=~"$topic"}',
            format: 'table',
            instant: true,
            interval: '',
            legendFormat: '',
            refId: 'A',
          },
        ],
        timeFrom: null,
        timeShift: null,
        title: 'Start Offset',
        transformations: [
          {
            id: 'organize',
            options: {
              excludeByName: {
                Time: true,
                __name__: true,
                env: true,
                instance: false,
                job: true,
              },
              indexByName: {
                Time: 0,
                Value: 7,
                __name__: 1,
                env: 2,
                instance: 3,
                job: 4,
                partition: 6,
                topic: 5,
              },
              renameByName: {
                Value: 'offset',
              },
            },
          },
        ],
        type: 'table',
      },
      {
        datasource: '${datasource}',
        description: '',
        fieldConfig: {
          defaults: {
            custom: {
              align: null,
              filterable: false,
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
          },
          overrides: [
            {
              matcher: {
                id: 'byName',
                options: 'partition',
              },
              properties: [
                {
                  id: 'custom.width',
                  value: 103,
                },
              ],
            },
            {
              matcher: {
                id: 'byName',
                options: 'offset',
              },
              properties: [
                {
                  id: 'custom.width',
                  value: 226,
                },
              ],
            },
          ],
        },
        gridPos: {
          h: 8,
          w: 12,
          x: 12,
          y: 18,
        },
        id: 7,
        options: {
          showHeader: true,
          sortBy: [
            {
              desc: false,
              displayName: 'partition',
            },
          ],
        },
        pluginVersion: '7.5.6',
        targets: [
          {
            expr: 'kafka_log_log_logendoffset{' + commonvars.queriesSelector + ',topic=~"$topic"}',
            format: 'table',
            instant: true,
            interval: '',
            legendFormat: '',
            refId: 'A',
          },
        ],
        timeFrom: null,
        timeShift: null,
        title: 'End Offset',
        transformations: [
          {
            id: 'organize',
            options: {
              excludeByName: {
                Time: true,
                __name__: true,
                env: true,
                instance: false,
                job: true,
              },
              indexByName: {
                Time: 0,
                Value: 7,
                __name__: 1,
                env: 2,
                instance: 3,
                job: 4,
                partition: 6,
                topic: 5,
              },
              renameByName: {
                Value: 'offset',
              },
            },
          },
        ],
        type: 'table',
      },
    ],
    refresh: '1m',
    schemaVersion: 27,
    style: 'dark',
    tags: [],
    time: {
      from: 'now-6h',
      to: 'now',
    },
    timepicker: {},
    timezone: '',
    title: 'Kafka Topics',
    uid: 'vQT4b1-Mz',
    version: 4,
  }
  +
  g.dashboard.withVariables(
    // multiInstance: allow multiple selector for instance labels
    commonvars.multiInstance
    +
    [
      {
        allValue: '.+',
        current: {},
        datasource: '${datasource}',
        definition: 'label_values(kafka_log_log_size{' + commonvars.queriesSelector + '},topic)',
        description: null,
        'error': null,
        hide: 0,
        includeAll: true,
        label: 'Topic name',
        multi: true,
        name: 'topic',
        options: [],
        query: {
          query: 'label_values(kafka_log_log_size{' + commonvars.queriesSelector + '},topic)',
          refId: 'StandardVariableQuery',
        },
        refresh: 2,
        regex: '',
        skipUrlSync: false,
        sort: 0,
        tagValuesQuery: '',
        tags: [],
        tagsQuery: '',
        type: 'query',
        useTags: false,
      },
    ]
  );

{
  grafanaDashboards+::
    {
      'kafka-topics.json': dashboard,
    },
}
