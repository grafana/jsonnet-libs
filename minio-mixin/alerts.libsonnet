{
  new(this): {
    local signals = this.signals,
    local instanceLabel = std.reverse(this.config.instanceLabels)[0],
    local vars = this.config { instanceLabel: instanceLabel },

    groups: [
      {
        name: this.config.uid + '-alerts',
        rules: [
          {
            alert: 'MinioDisksOffline',
            expr: '(%s) != 0' % signals.overview.disksOffline.asRuleExpression(),
            'for': '1m',
            labels: { severity: 'critical' },
            annotations: {
              summary: 'MinIO disks offline.',
              description: "MinIO '{{ $labels.%(instanceLabel)s }}' has {{ $value }} disks offline." % vars,
            },
          },
          {
            alert: 'MinioStorageUsed',
            expr: '100 * (%s) > %s' % [signals.storage.usedRatio.asRuleExpression(), this.config.alertsWarningStorageUsed],
            'for': '1m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'MinIO disks high storage used percentage.',
              description: "MinIO disk '{{ $labels.disk }}' on '{{ $labels.%(instanceLabel)s }}' has {{ printf \"%%.1f\" $value }}%% storage used, above the threshold of %(alertsWarningStorageUsed)s%%." % vars,
            },
          },
        ],
      },
    ],
  },
}
