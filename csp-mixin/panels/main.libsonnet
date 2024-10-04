{
  new(this):: {
    azureelasticpool: (import './azureelasticpool.libsonnet').new(this),
    azureloadbalancer: (import './azureloadbalancer.libsonnet').new(this),
    azurequeuestore: (import './azurequeuestore.libsonnet').new(this),
    azuresqldb: (import './azuresqldb.libsonnet').new(this),
    azurevirtualnetwork: (import './azurevirtualnetwork.libsonnet').new(this),
    azurevm: (import './azurevm.libsonnet').new(this),
    blobstore: (import './blobstore.libsonnet').new(this),
    gcploadbalancer: (import './gcploadbalancer.libsonnet').new(this),
    gcpce: (import './gcpce.libsonnet').new(this),
    gcpvpc: (import './gcpvpc.libsonnet').new(this),
  },
}
