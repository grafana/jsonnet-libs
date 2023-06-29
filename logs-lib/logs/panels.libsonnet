local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local timeSeries = g.panel.timeSeries;
local logsPanel = g.panel.logs;
local defaults = timeSeries.fieldConfig.defaults;
local custom = timeSeries.fieldConfig.defaults.custom;
local options = timeSeries.options;
local fieldConfig = timeSeries.fieldConfig;
function(
  logsVolumeTarget,
  logsTarget,
)

  {
    local this = self,

    logsVolumeInit(targets, title='Logs volume')::
      timeSeries.new(title)
      + timeSeries.withTargets(targets)
      + custom.withDrawStyle('bars')
      + custom.stacking.withMode('normal')
      + custom.withFillOpacity(50)
      + timeSeries.withInterval('30s')  // must be set , otherwise interval is around 1ms
      + options.tooltip.withMode('multi')
      + timeSeries.withTransformationsMixin(
        {
          id: 'renameByRegex',
          options: {
            regex: 'Value',
            renamePattern: 'unknown',
          },
        }
      )
      + fieldConfig.withOverridesMixin(
        [
          {
            matcher: {
              id: 'byRegexp',
              options: o.regex,
            },
            properties: [
              {
                id: 'color',
                value: {
                  mode: 'fixed',
                  fixedColor: o.color,
                },
              },
            ],
          }
          // https://grafana.com/docs/grafana/latest/explore/logs-integration/#log-level
          for o in
            [
              { regex: 'emerg|fatal|alert|crit.*', color: 'purple' },
              { regex: 'err.*|ERR.*', color: 'red' },
              { regex: 'warn.*|WARN.*|wrn|WRN', color: 'yellow' },
              { regex: 'notice|inf.*|INF.*', color: 'green' },
              { regex: 'dbg.*|DBG.*|DEBUG|debug', color: 'blue' },
              { regex: 'trace|TRACE', color: 'light-blue' },
              { regex: 'unknown', color: 'text' },
            ]
        ]
      ),

    logsInit(targets, title='Logs')::
      logsPanel.new(title)
      + logsPanel.withTargets(targets)
      + logsPanel.options.withDedupStrategy('exact')  //"none", "exact", "numbers", "signature"
      + logsPanel.options.withEnableLogDetails(true)
      + logsPanel.options.withShowTime(true)
      + logsPanel.options.withWrapLogMessage(true)
      + logsPanel.options.withPrettifyLogMessage(true),

    logsVolume: self.logsVolumeInit(logsVolumeTarget),
    logs: self.logsInit(logsTarget),

  }
