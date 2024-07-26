{
  _config+:: {
    local this = self,
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',
    signals:
      {
        blobstore: (import './signals/blobstore.libsonnet')(this),
        azureelasticpool: (import './signals/azureelasticpool.libsonnet')(this),
        azuresqldb: (import './signals/azuresqldb.libsonnet')(this),
      },
    blobStorage: {
      enableAvailability: false,
    },
  },
}
