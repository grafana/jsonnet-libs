local g = import 'github.com/grafana/dashboard-spec/_gen/7.0/jsonnet/grafana.libsonnet';

{
  // Opinionated label matchers for Prometheus queries.
  _config+:: {
    instanceMatcher: 'instance=~"$instance"',
    jobMatcher: 'job=~"$job"',
    frontendMatcher: 'proxy=~"$frontend"',
    backendMatcher: 'proxy=~"$backend"',
    serverMatcher: 'server=~"$server"',
    baseMatchers: std.join(',', [self.instanceMatcher, self.jobMatcher]),
    frontendMatchers: std.join(',', [self.baseMatchers, self.frontendMatcher]),
    backendMatchers: std.join(',', [self.baseMatchers, self.backendMatcher]),
    serverMatchers: std.join(',', [self.backendMatchers, self.serverMatcher]),
  },

  util:: {
    // section is used to group multiple panels with common dimensions under a single uncollapsed row.
    section(panels, row, prevSection=null, panelSize={ h: 4, w: 6 })::
      local y = if prevSection != null then prevSection[std.length(prevSection) - 1].gridPos.y + 1 else 0;
      local id = if prevSection != null then prevSection[std.length(prevSection) - 1].id + 1 else 0;
      local dashboardWidth = 24;
      [
        row {
          collapsed: false,
          gridPos: { x: 0, y: y, h: 1, w: dashboardWidth },
          id: id,
        },
      ]
      + std.mapWithIndex(function(i, panel) panel {
        gridPos: {
          x: i * panelSize.w % dashboardWidth,
          y: y + (std.floor(i * panelSize.w / dashboardWidth) * panelSize.h),
          w: panelSize.w,
          h: panelSize.h,
        },
        id: id + i + 1,
      }, panels),
  },

  // queries is a map of Prometheus queries as functions that take a label set as input so that they can be individually configured and composed.
  queries:: {
    processUptime(matchers=$._config.baseMatchers):: 'time() - haproxy_process_start_time_seconds{%s}' % matchers,
    processCurrentConnectionsCount(matchers=$._config.baseMatchers):: 'haproxy_process_current_connections{%s}' % matchers,
    processMemoryAllocated(matchers=$._config.baseMatchers):: 'haproxy_process_pool_allocated_bytes{%s}' % matchers,
    processMemoryUsed(matchers=$._config.baseMatchers):: 'haproxy_process_pool_used_bytes{%s}' % matchers,
    processThreadCount(matchers=$._config.baseMatchers):: 'haproxy_process_nbthread{%s}' % matchers,
    processCount(matchers=$._config.baseMatchers):: 'haproxy_process_nbproc{%s}' % matchers,
    processMaxConnectionsCount(matchers=$._config.baseMatchers):: 'haproxy_process_max_connections{%s}' % matchers,
    processMaxFDs(matchers=$._config.baseMatchers):: 'haproxy_process_max_fds{%s}' % matchers,
    processMaxMemory(matchers=$._config.baseMatchers):: 'haproxy_process_max_memory_bytes{%s}' % matchers,
    processMaxSockets(matchers=$._config.baseMatchers):: 'haproxy_process_max_sockets{%s}' % matchers,
    backendStatus(matchers=$._config.baseMatchers):: 'haproxy_backend_status{%s}' % matchers,
    frontendStatus(matchers=$._config.baseMatchers):: 'haproxy_frontend_status{%s}' % matchers,
  },

  // panels composes queries into panels with best practice configuration.
  panels:: {
    stat:: {
      // new creates a new stat panel from a data source and array of queries.
      new(datasource, queries=[])::
        g.panel.stat.new(datasource, queries) + {
          targets:
            local A = std.codepoint('A');
            std.mapWithIndex(function(i, query) { expr: query, refID: std.char(A + i) }, queries),
        },

      // infoMixin colors stat panel fields blue so as to represent information that has neutral connotations.
      infoMixin:: {
        fieldConfig: {
          defaults: {
            thresholds: {
              mode: 'absolute',
              steps: [{ color: 'blue', value: null }],
            },
          },
        },
      },
    },

    processUptime(datasource, queries=[$.queries.processUptime()])::
      $.panels.stat.new(datasource, queries)
      + $.panels.stat.infoMixin {
        title: 'Uptime',
        description: 'Process uptime',
        fieldConfig+: {
          defaults+: {
            unit: 's',
          },
        },
      },

    processCurrentConnections(datasource, queries=[$.queries.processCurrentConnectionsCount()])::
      $.panels.stat.new(datasource, queries) + {
        title: 'Current connections',
        description: 'Number of active sessions',
      },

    processMemoryAllocated(datasource, queries=[$.queries.processMemoryAllocated()])::
      $.panels.stat.new(datasource, queries)
      + $.panels.stat.infoMixin {
        title: 'Memory allocated',
        description: 'Total amount of memory allocated in pools',
        fieldConfig+: {
          defaults+: {
            unit: 'bytes',
          },
        },
      },

    processMemoryUsed(datasource, queries=[$.queries.processMemoryUsed()])::
      $.panels.stat.new(datasource, queries)
      + $.panels.stat.infoMixin {
        title: 'Memory used',
        description: 'Total amount of memory used in pools',
        fieldConfig+: {
          defaults+: {
            unit: 'bytes',
          },
        },
      },

    processThreads(datasource, queries=[$.queries.processThreadCount()])::
      $.panels.stat.new(datasource, queries)
      + $.panels.stat.infoMixin {
        title: 'Threads',
        description: 'Configured number of threads',
      },

    processCount(datasource, queries=[$.queries.processCount()])::
      $.panels.stat.new(datasource, queries)
      + $.panels.stat.infoMixin {
        title: 'Processes',
        description: 'Configured number of processes',
      },

    processConnectionsLimit(datasource, queries=[$.queries.processMaxConnectionsCount()])::
      $.panels.stat.new(datasource, queries)
      + $.panels.stat.infoMixin {
        title: 'Connections limit',
        description: 'Configured maximum number of concurrent connections',
        options+: { graphMode: 'none' },
      },

    processMemoryLimit(datasource, queries=[$.queries.processMaxMemory()])::
      $.panels.stat.new(datasource, queries)
      + $.panels.stat.infoMixin {
        title: 'Memory limit',
        description: 'Per-process memory limit',
        fieldConfig+: {
          defaults+: {
            unit: 'bytes',
            mappings: [{ id: 1, type: 1, text: 'unset', value: 0 }],
          },
        },
        options+: { graphMode: 'none' },
      },

    processFDLimit(datasource, queries=[$.queries.processMaxFDs()])::
      $.panels.stat.new(datasource, queries)
      + $.panels.stat.infoMixin {
        title: 'File descriptors limit',
        description: 'Maximum number of open file descriptors',
        fieldConfig+: {
          defaults+: {
            mappings: [{ id: 1, type: 1, text: 'unset', value: '0' }],
          },
        },
        options+: { graphMode: 'none' },
      },

    processSocketLimit(datasource, queries=[$.queries.processMaxSockets()])::
      $.panels.stat.new(datasource, queries)
      + $.panels.stat.infoMixin {
        title: 'Socket limit',
        description: 'Maximum number of open sockets',
      },

    frontendStatus(datasource): g.panel.table.new(datasource) {
      datasource: 'prometheus',
      fieldConfig: {
        defaults: {
          links: [{
            title: 'Frontend',
            url: '/d/HAProxyFrontend/haproxy-frontend?${__all_variables}&var-frontend=${__data.fields.Frontend}',
          }],
        },
        overrides: [{
          matcher: { id: 'byName', options: 'Status' },
          properties: [
            {
              id: 'mappings',
              value: [
                { id: 1, type: 1, text: 'Down', value: '0' },
                { id: 2, type: 1, text: 'Up', value: '1' },
              ],
            },
            {
              id: 'custom.displayMode',
              value: 'color-background',
            },
            {
              id: 'thresholds',
              value: {
                mode: 'absolute',
                steps: [
                  { color: 'rgba(0,0,0,0)', value: null },
                  { color: 'red', value: 0 },
                  { color: 'green', value: 1 },
                ],
              },
            },
          ],
        }],
      },
      options: { sortBy: [{ displayName: 'Status', desc: false }] },
      targets: [{
        expr: $.queries.frontendStatus(),
        refId: 'A',
        format: 'table',
        instant: true,
      }],
      transformations: [
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              __name__: true,
            },
            renameByName: {
              instance: 'Instance',
              job: 'Job',
              proxy: 'Frontend',
              Value: 'Status',
            },
          },
        },
      ],
    },

    backendStatus(datasource):: g.panel.table.new(datasource) {
      datasource: 'prometheus',
      fieldConfig: {
        defaults: {
          links: [{
            title: 'Backend',
            url: '/d/HAProxyBackend/haproxy-backend?${__all_variables}&var-backend=${__data.fields.Backend}',
          }],
        },
        overrides: [{
          matcher: { id: 'byName', options: 'Status' },
          properties: [
            {
              id: 'mappings',
              value: [
                { id: 1, type: 1, text: 'Down', value: '0' },
                { id: 2, type: 1, text: 'Up', value: '1' },
              ],
            },
            {
              id: 'custom.displayMode',
              value: 'color-background',
            },
            {
              id: 'thresholds',
              value: {
                mode: 'absolute',
                steps: [
                  { color: 'rgba(0,0,0,0)', value: null },
                  { color: 'red', value: 0 },
                  { color: 'green', value: 1 },
                ],
              },
            },
          ],
        }],
      },
      targets: [{
        expr: $.queries.backendStatus(),
        refId: 'A',
        format: 'table',
        instant: true,
      }],
      transformations: [
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              __name__: true,
            },
            renameByName: {
              instance: 'Instance',
              job: 'Job',
              proxy: 'Backend',
              Value: 'Status',
            },
          },
        },
      ],
    },
  },

  // templates can be used as Grafana template variables.
  templates:: {
    datasource: g.template.datasource.new() + {
      name: 'datasource',
      query: 'prometheus',
      current: {
        selected: true,
        text: 'prometheus',
        value: 'prometheus',
      },
    },
    instance: g.template.query.new() + {
      name: 'instance',
      datasource: 'prometheus',
      definition: 'label_values(haproxy_process_start_time_seconds, instance)',
      includeAll: true,
      multi: true,
      query: 'label_values(haproxy_process_start_time_seconds, instance)',
      refresh: 1,
    },
    job: g.template.query.new() + {
      name: 'job',
      datasource: 'prometheus',
      definition: 'label_values(haproxy_process_start_time_seconds, job)',
      includeAll: true,
      multi: true,
      query: 'label_values(haproxy_process_start_time_seconds, job)',
      refresh: 1,
    },
  },
}
