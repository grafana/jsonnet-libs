// PostgreSQL Settings Signals
{
  new(this): {
    // All settings signal - for use with the settings table
    // This is handled specially in the panel since we need to extract metric names
    allSettings: {
      name: 'PostgreSQL Settings',
      description: 'All PostgreSQL configuration settings from pg_settings_* metrics',
      // Note: The actual query is constructed in the panel with regex filter support
    },
  },
}


