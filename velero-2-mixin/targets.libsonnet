local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;
local commonlib = import 'common-lib/common/main.libsonnet';
local lokiQuery = g.query.loki;

{
  new(this): {
    local vars = this.grafana.variables,
    local config = this.config,

    succesfulBackups:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(increase(velero_backup_success_total{%(queriesSelector)s})[$__rate_interval:])' % vars
      ),
    failedBackups:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(increase(velero_backup_failure_total{%(queriesSelector)s})[$__rate_interval:])' % vars
      ),
    succesfulRestores:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(increase(velero_restore_success_total{%(queriesSelector)s})[$__rate_interval:])' % vars
      ),
     failedRestores:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(increase(velero_restore_failed_total{%(queriesSelector)s})[$__rate_interval:])' % vars
      ),

		topClustersByBackupSuccess:
		 prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(velero_cluster)($top_cluster_count, increase(velero_backup_success_total{%(queriesSelector)s}[$__interval]))' % vars
      ),
		topClustersByBackupFailure:
		 prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(velero_cluster)($top_cluster_count, increase(velero_backup_failure_total{%(queriesSelector)s}[$__interval]))' % vars
      ),

		topClustersByRestoreSuccess:
		 prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(velero_cluster)($top_cluster_count, increase(velero_restore_success_total{%(queriesSelector)s}[$__interval]))' % vars
      ),
		topClustersByRestoreFailure:
		 prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(velero_cluster)($top_cluster_count, increase(velero_restore_failed_total{%(queriesSelector)s}[$__interval]))' % vars
      ),
		
		topClustersByBackupSize:
		 prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(velero_cluster)($top_cluster_count, velero_backup_tarball_size_bytes{%(queriesSelector)s})' % vars
      ),

		topClustersByVolumeSnapshotSuccess:
		 prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(velero_cluster)($top_cluster_count, increase(velero_volume_snapshot_success_total{%(queriesSelector)s}[$__interval]))' % vars
      ),
		topClustersByVolumeSnapshotFailure:
		 prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(velero_cluster)($top_cluster_count, increase(velero_volume_snapshot_failure_total{%(queriesSelector)s}[$__interval]))' % vars
      ),
		topClustersByCSISnapshotSuccess:
		 prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(velero_cluster)($top_cluster_count, increase(velero_csi_snapshot_success_total{%(queriesSelector)s}[$__interval]))' % vars
      ),
		topClustersByCSISnapshotFailure:
		 prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(velero_cluster)($top_cluster_count, increase(velero_csi_snapshot_failure_total{%(queriesSelector)s}[$__interval]))' % vars
      ),

		},
}
