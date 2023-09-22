{
  new(this): {
    local variables = this.variables,
    local config = this.config,
    cpu_usage_percent:
      {
        query: '100 - (avg without (mode,core) (rate(windows_cpu_time_total{mode="idle", %(queriesSelector)s}[$__rate_interval])*100))' % variables,
        alertRule: '100 - (avg without (mode,core) (rate(windows_cpu_time_total{mode="idle", %(filteringSelector)s}[5m])*100))' % config,
        thresholds: {
          critical: '90',
          warning: '80',
        },
      },
  },
}
