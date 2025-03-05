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
        gcploadbalancer: (import './signals/gcploadbalancer.libsonnet')(this),
        gcpoadbalancerBackend: (import './signals/gcpoadbalancerBackend.libsonnet')(this),
        azureloadbalancer: (import './signals/azureloadbalancer.libsonnet')(this),
        azurevirtualnetwork: (import './signals/azurevirtualnetwork.libsonnet')(this),
        azurevm: (import './signals/azurevm.libsonnet')(this),
        azurevmOverview: (import './signals/azurevmOverview.libsonnet')(this),
        azurequeuestore: (import './signals/azurequeuestore.libsonnet')(this),
        gcpce: (import './signals/gcpce.libsonnet')(this),
        gcpceOverview: (import './signals/gcpceOverview.libsonnet')(this),
        gcpvpc: (import './signals/gcpvpc.libsonnet')(this),
        azurefrontdoorOverview: (import './signals/azurefrontdoorOverview.libsonnet')(this),
        azurefrontdoor: (import './signals/azurefrontdoor.libsonnet')(this),
      },
    blobStorage: {
      enableAvailability: false,
    },
  },
}
