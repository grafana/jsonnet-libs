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
        'sum by (cluster) ((increase(velero_backup_success_total{%(clusterQuerySelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('Backups'),

    failedBackups:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (cluster) ((increase(velero_backup_failure_total{%(clusterQuerySelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('Backups'),

    succesfulRestores:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (cluster) ((increase(velero_restore_success_total{%(clusterQuerySelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('Restores'),

    failedRestores:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (cluster) ((increase(velero_restore_failed_total{%(clusterQuerySelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('Restores'),

    topClustersByBackupSuccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, sum by (cluster) (increase(velero_backup_success_total{%(clusterQuerySelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(this.config.clusterLegendLabels)),

    topClustersByBackupAttempt:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, sum by (cluster) (increase(velero_backup_attempt_total{%(clusterQuerySelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - attempt' % utils.labelsToPanelLegend(this.config.clusterLegendLabels)),

    topClustersByBackupFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, sum by (cluster) (increase(velero_backup_failure_total{%(clusterQuerySelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(this.config.clusterLegendLabels)),

    topClustersByRestoreSuccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, sum by (cluster) (increase(velero_restore_success_total{%(clusterQuerySelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(this.config.clusterLegendLabels)),

    topClustersByRestoreAttempt:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, sum by (cluster) (increase(velero_restore_success_total{%(clusterQuerySelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - attempt' % utils.labelsToPanelLegend(this.config.clusterLegendLabels)),

    topClustersByRestoreFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, sum by (cluster) (increase(velero_restore_failed_total{%(clusterQuerySelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(this.config.clusterLegendLabels)),

    topClustersByBackupSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, sum by (cluster) (velero_backup_tarball_size_bytes{%(clusterQuerySelector)s}))' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.clusterLegendLabels)),

    topClustersByVolumeSnapshotSuccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, sum by (cluster) (increase(velero_volume_snapshot_success_total{%(clusterQuerySelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(this.config.clusterLegendLabels)),

    topClustersByVolumeSnapshotFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, sum by (cluster) (increase(velero_volume_snapshot_failure_total{%(clusterQuerySelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(this.config.clusterLegendLabels)),

    topClustersByVolumeSnapshotAttempt:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, sum by (cluster) (increase(velero_volume_snapshot_attempt_total{%(clusterQuerySelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - attempt' % utils.labelsToPanelLegend(this.config.clusterLegendLabels)),

    topClustersByCSISnapshotSuccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, sum by (cluster) (increase(velero_csi_snapshot_success_total{%(clusterQuerySelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(this.config.clusterLegendLabels)),

    topClustersByCSISnapshotAttempt:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, sum by (cluster) (increase(velero_csi_snapshot_attempt_total{%(clusterQuerySelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - attempt' % utils.labelsToPanelLegend(this.config.clusterLegendLabels)),

    topClustersByCSISnapshotFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, sum by (cluster) (increase(velero_csi_snapshot_failure_total{%(clusterQuerySelector)s}[$__interval:])))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(this.config.clusterLegendLabels)),

    restoreValidationFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(increase(label_replace(velero_restore_validation_failed_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('failure'),

    backupValidationFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(increase(label_replace(velero_backup_validation_failure_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('failure'),

    succesfulBackupsStat:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(increase(velero_backup_success_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('Backups'),

    failedBackupsStat:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(increase(velero_backup_failure_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('Backups'),

    backupSuccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(label_replace(velero_backup_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(this.config.legendLabels)),
    backupAttempt:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(label_replace(velero_backup_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - attempt' % utils.labelsToPanelLegend(this.config.legendLabels)),
    backupFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(label_replace(velero_backup_failure_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(this.config.legendLabels)),
    backupSuccessRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(label_replace(velero_backup_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__rate_interval:]) / clamp_min(rate(label_replace(velero_backup_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__rate_interval:]),1)' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),
    backupSuccessRateGauge:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (instance) (label_replace(increase(velero_backup_success_total{job=~"$job",cluster=~"$cluster",instance=~"$instance",schedule=~"$schedule"}[1h]), "schedule", "none", "schedule", "^$") / label_replace(increase(velero_backup_attempt_total{job=~"$job",cluster=~"$cluster",instance=~"$instance",schedule=~"$schedule"}[1h]), "schedule", "none", "schedule", "^$") >  0)' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    backupSize:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'label_replace(velero_backup_tarball_size_bytes{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    backupTime:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum(increase(label_replace(velero_backup_duration_seconds_bucket{le!="+Inf", %(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])) by (le)' % vars
      ),

    restoreSuccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(label_replace(velero_restore_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(this.config.legendLabels)),
    restoreFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(label_replace(velero_restore_failed_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(this.config.legendLabels)),
    restoreAttempt:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(label_replace(velero_restore_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - attempt' % utils.labelsToPanelLegend(this.config.legendLabels)),

    restoreSuccessRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(label_replace(velero_restore_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]) / clamp_min(increase(label_replace(velero_restore_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]),1)' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    restoreSuccessRateGauge:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'avg by (instance) (label_replace(increase(velero_restore_success_total{job=~"$job",cluster=~"$cluster",instance=~"$instance",schedule=~"$schedule"}[1h]), "schedule", "none", "schedule", "^$") / label_replace(increase(velero_restore_attempt_total{job=~"$job",cluster=~"$cluster",instance=~"$instance",schedule=~"$schedule"}[1h]), "schedule", "none", "schedule", "^$") >  0)' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    volumeSnapshotSuccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(label_replace(velero_volume_snapshot_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(this.config.legendLabels)),

    volumeSnapshotFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(label_replace(velero_volume_snapshot_failure_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(this.config.legendLabels)),

    volumeSnapshotAttempt:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(label_replace(velero_volume_snapshot_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('%s - attempt' % utils.labelsToPanelLegend(this.config.legendLabels)),

    volumeSnapshotSuccessRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(label_replace(velero_volume_snapshot_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]) / clamp_min(increase(label_replace(velero_volume_snapshot_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]),1)' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

    csiSnapshotSuccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (schedule) (increase(label_replace(velero_csi_snapshot_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(this.config.legendLabels)),
    csiSnapshotFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (schedule) (increase(label_replace(velero_csi_snapshot_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(this.config.legendLabels)),
    csiSnapshotAttempt:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (schedule) (increase(label_replace(velero_csi_snapshot_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - attempt' % utils.labelsToPanelLegend(this.config.legendLabels)),

    csiSnapshotSuccessRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (schedule) (increase(label_replace(velero_csi_snapshot_success_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]) / clamp_min(increase(label_replace(velero_csi_snapshot_attempt_total{%(queriesSelector)s}, "schedule", "none", "schedule", "^$")[$__interval:]),1)) ' % vars
      )
      + prometheusQuery.withLegendFormat('%s' % utils.labelsToPanelLegend(this.config.legendLabels)),

  },
}
