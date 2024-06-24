{
  _config+:: {
    local this = self,
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',
    signals:
      {
        blobstore: (import './signals/blobstore.libsonnet')(this),
      },
  },
}
