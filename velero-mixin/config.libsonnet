{
  local this = self,
  filteringSelector: 'job="integrations/velero"',
  groupLabels: ['job', 'cluster'],
  instanceLabels: ['instance'],
  uid: 'velero',
  metricsSource: 'prometheus',
  enableLokiLogs: false,

  legendCustomTemplate: std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)),

  signals+: {
    system: (import './signals/system.libsonnet')(this),
    backups: (import './signals/backups.libsonnet')(this),
    restores: (import './signals/restores.libsonnet')(this),
    snapshots: (import './signals/snapshots.libsonnet')(this),
  },
}
