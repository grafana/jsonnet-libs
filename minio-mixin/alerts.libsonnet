{
  prometheusAlerts+: {
    groups+: [{
      name: 'minio',
      rules: [
        {
          alert: 'minioDisksOffline',
          expr: |||
            minio_disks_offline != 0
          |||,
          'for': '1m',
          labels: {
            severity: 'critical',
          },
          annotations: {
            message: "MinIO '{{ $labels.instance }}' has disks offline",
            description: "MinIO '{{ $labels.instance }}' has disks offline",
            summary: "MinIO disks offline."
          },
        },
        {
          alert: 'minioStorageUsed',
          expr: |||
            disk_storage_used / disk_storage_total > 0.8
          |||,
          'for': '1m',
          labels: {
            severity: 'warning',
          },
          annotations: {
            message: "MinIO disk '{{ $labels.disk }}' has more than 80% storaged used",
            description: "MinIO disk '{{ $labels.disk }}' has more than 80% storaged used",
            summary: "MinIO disks high storage used percentage."
          },
        },
      ],
    }],
  },
}
