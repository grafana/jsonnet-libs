// PostgreSQL Settings Signals
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this): {
    local vars = this.config.dashboardVariables,
    local instanceLabels = this.config.instanceLabels,
    local queriesSelector = vars.queriesSelector,

    // All settings signal - for use with the settings table
    // This is handled specially in the panel since we need to extract metric names
    allSettings: {
      name: 'PostgreSQL Settings',
      description: 'All PostgreSQL configuration settings from pg_settings_* metrics',
      // Note: The actual query is constructed in the panel with regex filter support
    },
  },
}

