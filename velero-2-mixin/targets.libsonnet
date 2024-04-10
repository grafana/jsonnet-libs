local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;
local commonlib = import 'common-lib/common/main.libsonnet';
local lokiQuery = g.query.loki;
local utils = commonlib.utils {
  labelsToPanelLegend(labels): std.join(' - ', ['{{%s}}' % [label] for label in labels]),
};
{
  new(this): {
    local vars = this.grafana.variables,
    local config = this.config,

    succesfulBackups:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(increase(velero_backup_success_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('Backups'),

    failedBackups:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(increase(velero_backup_failure_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('Backups'),

    succesfulRestores:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(increase(velero_restore_success_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('Restores'),

    failedRestores:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(increase(velero_restore_failed_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('Restores'),

    topClustersByBackupSuccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, increase(velero_backup_success_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(this.config.legendLabels)),

    topClustersByBackupAttempt:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, increase(velero_backup_attempt_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - attempt' % utils.labelsToPanelLegend(this.config.legendLabels)),

    topClustersByBackupFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, increase(velero_backup_failure_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(this.config.legendLabels)),

    topClustersByRestoreSuccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, increase(velero_restore_success_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(this.config.legendLabels)),

    topClustersByRestoreAttempt:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, increase(velero_restore_success_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - attempt' % utils.labelsToPanelLegend(this.config.legendLabels)),


    topClustersByRestoreFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, increase(velero_restore_failed_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(this.config.legendLabels)),

    topClustersByBackupSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, velero_backup_tarball_size_bytes{%(queriesSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    topClustersByVolumeSnapshotSuccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, increase(velero_volume_snapshot_success_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(this.config.legendLabels)),

    topClustersByVolumeSnapshotFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, increase(velero_volume_snapshot_failure_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(this.config.legendLabels)),

    topClustersByVolumeSnapshotAttempt:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, increase(velero_volume_snapshot_attempt_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - attempt' % utils.labelsToPanelLegend(this.config.legendLabels)),

    topClustersByCSISnapshotSuccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, increase(velero_csi_snapshot_success_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(this.config.legendLabels)),

    topClustersByCSISnapshotAttempt:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, increase(velero_csi_snapshot_attempt_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - attempt' % utils.labelsToPanelLegend(this.config.legendLabels)),


    topClustersByCSISnapshotFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, increase(velero_csi_snapshot_failure_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(this.config.legendLabels)),

    lastBackupStatus:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'velero_backup_last_status{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('Backups'),

    restoreValidationFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(increase(velero_restore_validation_failed_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('failure'),
    backupSuccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(velero_backup_success_total{%(queriesSelector)s}[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(this.config.legendLabels)),
    backupAttempt:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(velero_backup_attempt_total{%(queriesSelector)s}[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - attempt' % utils.labelsToPanelLegend(this.config.legendLabels)),
    backupFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(velero_backup_failure_total{%(queriesSelector)s}[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(this.config.legendLabels)),
    backupSuccessRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(velero_backup_success_total{%(queriesSelector)s}[$__rate_interval]) / clamp_min(rate(velero_backup_attempt_total{%(queriesSelector)s}[$__rate_interval]),0.001)' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),
    backupSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'velero_backup_tarball_size_bytes{%(queriesSelector)s}' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    backupTime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(increase(velero_backup_duration_seconds_bucket{le!="+Inf"}[$__interval:])) by (le)' % vars
      ),

    restoreSuccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(velero_restore_success_total{%(queriesSelector)s}[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(this.config.legendLabels)),
    restoreFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(velero_restore_failed_total{%(queriesSelector)s}[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(this.config.legendLabels)),
    restoreAttempt:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(velero_restore_attempt_total{%(queriesSelector)s}[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - attempt' % utils.labelsToPanelLegend(this.config.legendLabels)),

    restoreSuccessRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(velero_restore_success_total{%(queriesSelector)s}[$__rate_interval]) / clamp_min(rate(velero_restore_attempt_total{%(queriesSelector)s}[$__rate_interval]),0.001)' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    volumeSnapshotSuccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(velero_volume_snapshot_success_total{%(queriesSelector)s}[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(this.config.legendLabels)),

    volumeSnapshotFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(velero_volume_snapshot_failure_total{%(queriesSelector)s}[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(this.config.legendLabels)),

    volumeSnapshotAttempt:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(velero_volume_snapshot_attempt_total{%(queriesSelector)s}[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - attempt' % utils.labelsToPanelLegend(this.config.legendLabels)),

    volumeSnapshotSuccessRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(velero_volume_snapshot_success_total{%(queriesSelector)s}[$__rate_interval]) / clamp_min(rate(velero_volume_snapshot_attempt_total{%(queriesSelector)s}[$__rate_interval]),0.001)' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    csiSnapshotSuccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(velero_csi_snapshot_success_total{%(queriesSelector)s}[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(this.config.legendLabels)),
    csiSnapshotFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(velero_csi_snapshot_success_total{%(queriesSelector)s}[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(this.config.legendLabels)),
    csiSnapshotAttempt:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(velero_csi_snapshot_attempt_total{%(queriesSelector)s}[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - attempt' % utils.labelsToPanelLegend(this.config.legendLabels)),

    csiSnapshotSuccessRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'rate(velero_csi_snapshot_success_total{%(queriesSelector)s}[$__rate_interval]) / clamp_min(rate(velero_csi_snapshot_attempt_total{%(queriesSelector)s}[$__rate_interval]),0.001) ' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

  },
}
