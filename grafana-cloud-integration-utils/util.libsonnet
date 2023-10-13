local g = import 'grafonnet-latest/main.libsonnet';
local grafana = (import 'grafonnet/grafana.libsonnet');
local statusPanels = import 'status-panels-lib/status-panels/main.libsonnet';

local debug(obj) =
  std.trace(std.toString(obj), obj);

local notNull(i) = i != null;
local flatten(acc, i) = acc + i;
local join(a) = std.foldl(flatten, std.filter(notNull, a), []);

local setGridPos(h, w, x, y) = {
  gridPos: {
    h: h,
    w: w,
    x: x,
    y: y,
  },
};

// Required for jsonnet dashboards with older schema
local setSpan(w) = {
  span: w / 2,
};

local integration_status_row_internal(height, width, xPos, yPos) =
  grafana.row.new(title='Integration Status') +
  setGridPos(height, width, xPos, yPos) +
  setSpan(width);

local integration_status_panel(statusPanelQuery, statusPanelDataSource, height, width, xPos, yPos, setId) =
  grafana.statPanel.new(
    'Integration Status',
    description='Shows the status of the integration.',
    datasource=statusPanelDataSource,
    unit='string',
    colorMode='background',
    graphMode='none',
    noValue='No Data',
    reducerFunction='lastNotNull',
    timeFrom='now/d',
  )
  .addMappings(
    [
      {
        options: {
          from: 1,
          result: {
            color: 'green',
            index: 0,
            text: 'Agent Configured - Sending Metrics',
          },
          to: 10000000000000,
        },
        type: 'range',
      },
      {
        options: {
          from: 0,
          result: {
            color: 'red',
            index: 1,
            text: 'No Data',
          },
          to: 0,
        },
        type: 'range',
      },
    ]
  )
  .addTarget(
    grafana.prometheus.target(
      statusPanelQuery,
      instant=true
    )
  ) +
  setGridPos(height, width, xPos, yPos) +
  setSpan(width) + (if setId then {
                      id: 1001,
                    } else {});

local latest_metric_panel(statusPanelQuery, statusPanelDataSource, height, width, xPos, yPos, setId) =
  grafana.statPanel.new(
    'Latest Metric Received',
    description='Shows the latest timestamp at which the metrics were received for this integration.',
    datasource=statusPanelDataSource,
    unit='dateTimeAsIso',
    colorMode='background',
    fields='Time',
    graphMode='none',
    noValue='No Data',
    reducerFunction='lastNotNull',
    timeFrom='now/d',
  )
  .addTarget(
    grafana.prometheus.target(statusPanelQuery)
  ) +
  setGridPos(height, width, xPos, yPos) +
  setSpan(width) + (if setId then {
                      id: 1002,
                    } else {});

local integration_version_panel(version, statusPanelDataSource, height, width, xPos, yPos, setId) =
  grafana.statPanel.new(
    'Integration Version',
    description='Shows the installed version of this integration.',
    unit='string',
    datasource=statusPanelDataSource,
    noValue=version,
  ) +
  setGridPos(height, width, xPos, yPos) +
  setSpan(width) + (if setId then {
                      id: 1003,
                    } else {});

{
  decorate_dashboard(dashboard, tags, refresh='30s', timeFrom='now-30m')::
    dashboard {
      editable: false,
      id: null,  // If id is set the grafana client will try to update instead of create
      tags: tags,
      refresh: refresh,
      time: {
        from: timeFrom,
        to: 'now',
      },
      templating: {
        list+: [
          if t.type == 'datasource' then
            if t.query == 'prometheus' then
              t { regex: '(?!grafanacloud-usage|grafanacloud-ml-metrics).+' }
            else if t.query == 'loki' then
              t { regex: '(?!grafanacloud.+usage-insights|grafanacloud.+alert-state-history).+' }
            else t
          else if t.type == 'query' then
            t { refresh: 2 }
          else t
          for t in dashboard.templating.list
        ],
      },
    },
  prepare_dashboards(dashboards, tags, folderName, ignoreDashboards=[], refresh='30s', timeFrom='now-30m'):: {
    [k]: {
      dashboard: $.decorate_dashboard(dashboards[k], tags, refresh, timeFrom),
      folderId: 0,
      overwrite: true,
      folderName: folderName,
    }
    for k in std.objectFields(dashboards)
    if !std.member(ignoreDashboards, k)
  },
  prepare_alerts(namespace, prometheusAlerts, ignoreAlerts=[], ignoreAlertGroups=[])::
    {
      namespace: namespace,
    } +
    prometheusAlerts + {
      groups:
        std.map(function(el) el {
          rules:
            std.filter(function(r) !std.member(ignoreAlerts, r.alert), super.rules),
        }, std.filter(function(g) !std.member(ignoreAlertGroups, g.name), super.groups)),
    },
  prepare_rules(namespace, rules, ignoreRules=[], ignoreRuleGroups=[])::
    {
      namespace: namespace,
    } +
    rules + {
      groups:
        std.map(function(rr) rr {
          rules:
            std.filter(function(r) !std.member(ignoreRules, r.record), super.rules),
        }, std.filter(function(g) !std.member(ignoreRuleGroups, g.name), super.groups)),
    },
  integration_status_panels(config, version, setId)::
    [
      integration_status_panel(
        config.statusPanelQuery,
        config.statusPanelDataSource,
        config.statusPanelGridPos[0],
        config.statusPanelGridPos[1],
        config.statusPanelGridPos[2],
        config.statusPanelGridPos[3],
        setId,
      ),
      latest_metric_panel(
        config.statusPanelQuery,
        config.statusPanelDataSource,
        config.statusPanelGridPos[0],
        config.statusPanelGridPos[1],
        config.statusPanelGridPos[2] + 1 * config.statusPanelGridPos[1],
        config.statusPanelGridPos[3],
        setId,
      ),
      integration_version_panel(
        version,
        config.statusPanelDataSource,
        config.statusPanelGridPos[0],
        config.statusPanelGridPos[1],
        config.statusPanelGridPos[2] + 2 * config.statusPanelGridPos[1],
        config.statusPanelGridPos[3],
        setId,
      ),
    ],
  integration_status_row(dashboard, config, version)::
    if std.isArray(dashboard.panels) && std.length(dashboard.panels) > 0 then
      {
        panels: [
                  integration_status_row_internal(
                    config.statusPanelGridPos[0],
                    config.statusPanelGridPos[1],
                    config.statusPanelGridPos[2],
                    config.statusPanelGridPos[3],
                  ),
                ] +
                $.integration_status_panels(config, version, false) +
                [
                  panel {
                    gridPos: {
                      h: panel.gridPos.h,
                      w: panel.gridPos.w,
                      x: panel.gridPos.x,
                      y: panel.gridPos.y + config.statusPanelGridPos[0],
                    },
                  }
                  for panel in dashboard.panels
                ],
      }
    else
      {
        rows: [
          integration_status_row_internal(
            config.statusPanelGridPos[0],
            config.statusPanelGridPos[1],
            config.statusPanelGridPos[2],
            config.statusPanelGridPos[3],
          ) + {
            panels: $.integration_status_panels(config, version, true),
          },
        ] + dashboard.rows,
      },
  add_status_panels(dashboard, config, version)::
    if std.member(config.statusPanelDashboards, dashboard.title) then
      $.integration_status_row(dashboard, config, version)
    else {},
  integration_status_row_lib(type, dashboard, config)::
    if std.isArray(dashboard.panels) && std.length(dashboard.panels) > 0 then
      {
        panels: join(
          [
            (statusPanels.new(
               'Integration Status',
               type=type,
               statusPanelsQueryMetrics=config.statusPanelsQueryMetrics,
               datasourceNameMetrics=config.statusPanelsDatasourceNameMetrics,
               statusPanelsQueryLogs=config.statusPanelsQueryLogs,
               datasourceNameLogs=config.statusPanelsDatasourceNameLogs,
               showIntegrationVersion=true,
               integrationVersion=config.statusPanelsIntegrationVersion,
               panelsHeight=config.statusPanelsGridPos[0],
               panelsWidth=config.statusPanelsGridPos[1],
               rowPositionY=config.statusPanelsGridPos[3],
               withRow=(if std.objectHas(config, 'statusPanelsWithRow') then config.statusPanelsWithRow else true),
             )).panels.statusPanels,
            [
              panel {
                gridPos+: {
                  y: if std.objectHas(panel, 'gridPos') && std.objectHas(panel.gridPos, 'y') then
                    panel.gridPos.y + config.statusPanelsGridPos[0] + 1
                  else config.statusPanelsGridPos[0] + 1,
                },
              }
              for panel in dashboard.panels
            ],
          ]
        ),
      }
    else
      {
        rows: dashboard.rows,
      },
  add_status_panels_lib(dashboard, config)::
    if std.member(config.statusPanelsDashboardsMetrics, dashboard.title) then
      $.integration_status_row_lib('metrics', dashboard, config)
    else if std.member(config.statusPanelsDashboardsLogs, dashboard.title) then
      $.integration_status_row_lib('logs', dashboard, config)
    else if std.member(config.statusPanelsDashboardsBoth, dashboard.title) then
      $.integration_status_row_lib('both', dashboard, config)
    else {},

  // adds links by integration tag.
  add_links_by_tag(tags, title='Integration dashboards', asDropdown=false, includeVars=true):: {
    links+: [
      g.dashboard.link.dashboards.new(title=title, tags=tags)
      + g.dashboard.link.dashboards.options.withIncludeVars(includeVars)
      + g.dashboard.link.dashboards.options.withKeepTime(true)
      + g.dashboard.link.dashboards.options.withAsDropdown(asDropdown),
    ],
  },
}
