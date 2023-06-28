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

    local logsVolumeInit(targets, title='Logs volume') =
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
          for o in
            [
              { regex: 'err.*|ERR.*', color: 'red' },
              { regex: 'warn.*|WARN.*|wrn|WRN', color: 'yellow' },
              { regex: 'dbg.*|DBG.*|DEBUG|debug', color: 'blue' },
              { regex: 'inf.*|INF.*', color: 'green' },
              { regex: 'unknown', color: 'text' },
            ]
        ]
      ),

    local logsInit(targets, title='Logs') =
      logsPanel.new(title)
      + logsPanel.withTargets(targets)
      + logsPanel.options.withDedupStrategy('signature')  //"none", "exact", "numbers", "signature"
      + logsPanel.options.withEnableLogDetails(true)
      + logsPanel.options.withShowTime(true)
      + logsPanel.options.withWrapLogMessage(true)
      + logsPanel.options.withPrettifyLogMessage(true),

    logsVolume: logsVolumeInit(logsVolumeTarget),
    logs: logsInit(logsTarget),

  }
