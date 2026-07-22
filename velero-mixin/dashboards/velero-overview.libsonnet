local commonlib = import 'common-lib/common/main.libsonnet';

// Wires the signal definitions into the legacy dashboard layout: panel bodies,
// templating and layout come verbatim from velero-overview.json; only the
// panel targets are generated from signals.
function(this)
  local base = import 'velero-overview.json';

  // The dashboard's template variables are unscoped (label_values(job) etc.),
  // so signals are unmarshalled without the static filteringSelector to keep
  // panel queries functionally identical to the legacy dashboard.
  local signals = {
    [sig]: commonlib.signals.unmarshallJsonMulti(
      this.signals[sig] { filteringSelector: '' },
      type=this.metricsSource,
    )
    for sig in std.objectFields(this.signals)
  };

  // The schedule variable exists only on this dashboard, so it is applied at
  // the call site rather than baked into the signal expressions.
  local schedule = 'schedule=~"$schedule"';

  local targetsByPanelId = {
    // stat panels
    '1': [signals.backups.backupTotal.withFilteringSelectorMixin(schedule).withLegendFormat('').asTarget()],
    '5': [signals.backups.backupSuccessTotal.withFilteringSelectorMixin(schedule).withLegendFormat('').asTarget()],
    '6': [signals.backups.backupItems.withFilteringSelectorMixin(schedule).withLegendFormat('').asTarget()],
    '24': [signals.restores.restoreTotal.withFilteringSelectorMixin(schedule).withLegendFormat('').asTarget()],
    '23': [signals.restores.restoreSuccessTotal.withFilteringSelectorMixin(schedule).withLegendFormat('').asTarget()],
    '10': [signals.backups.backupDeletionAttemptTotal.withFilteringSelectorMixin(schedule).withLegendFormat('').asTarget()],
    '4': [signals.system.veleroUp.withLegendFormat('__auto').asTarget()],

    // timeseries panels
    '29': [
      signals.backups.backupAttempts.withFilteringSelectorMixin(schedule).asTarget(),
      signals.backups.backupSuccesses.withFilteringSelectorMixin(schedule).asTarget(),
      signals.backups.backupFailures.withFilteringSelectorMixin(schedule).asTarget(),
    ],
    '22': [
      signals.restores.restoreAttempts.withFilteringSelectorMixin(schedule).asTarget(),
      signals.restores.restoreSuccesses.withFilteringSelectorMixin(schedule).asTarget(),
      signals.restores.restoreFailures.withFilteringSelectorMixin(schedule).asTarget(),
    ],
    '30': [
      signals.backups.backupDeletionAttempts.withFilteringSelectorMixin(schedule).asTarget(),
      signals.backups.backupDeletionSuccesses.withFilteringSelectorMixin(schedule).asTarget(),
      signals.backups.backupDeletionFailures.withFilteringSelectorMixin(schedule).asTarget(),
    ],
    '13': [
      signals.snapshots.volumeSnapshotAttempts.withFilteringSelectorMixin(schedule).asTarget(),
      signals.snapshots.volumeSnapshotSuccesses.withFilteringSelectorMixin(schedule).asTarget(),
      signals.snapshots.volumeSnapshotFailures.withFilteringSelectorMixin(schedule).asTarget(),
    ],
    '16': [
      signals.snapshots.csiSnapshotAttempts.withFilteringSelectorMixin(schedule).asTarget(),
      signals.snapshots.csiSnapshotSuccesses.withFilteringSelectorMixin(schedule).asTarget(),
      signals.snapshots.csiSnapshotFailures.withFilteringSelectorMixin(schedule).asTarget(),
    ],
    '19': [signals.backups.backupLastStatus.withFilteringSelectorMixin(schedule).withLegendFormat('Status').asTarget()],
    '28': [signals.backups.backupDuration.withFilteringSelectorMixin(schedule).withLegendFormat('').asTarget()],
    '27': [signals.backups.backupTarballSize.withFilteringSelectorMixin(schedule).asTarget()],
  };

  base {
    panels: [
      if std.objectHas(targetsByPanelId, std.toString(p.id))
      then p { targets: targetsByPanelId[std.toString(p.id)] }
      else p
      for p in base.panels
    ],
  }
