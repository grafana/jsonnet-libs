local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  this.signals.brokerReplicaManager {
    aggLevel: 'group',
    aggFunction: 'sum',
  }
