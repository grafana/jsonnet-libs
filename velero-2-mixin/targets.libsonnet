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

    topClustersByCSISnapshotSuccess:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, increase(velero_csi_snapshot_success_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - success' % utils.labelsToPanelLegend(this.config.legendLabels)),

    topClustersByCSISnapshotFailure:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'topk by(cluster)($top_cluster_count, increase(velero_csi_snapshot_failure_total{%(queriesSelector)s}[$__interval:]))' % vars
      )
      + prometheusQuery.withLegendFormat('%s - failure' % utils.labelsToPanelLegend(this.config.legendLabels)),

  },
}
