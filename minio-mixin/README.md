# MinIO mixin

Dashboards and alerts for MinIO, built on [common-lib signals](../common-lib/common/signal/README.md).

## Dashboards

- **MinIO distributed cluster metrics**: disk and bucket storage, S3 request rates, time to first byte and internode traffic.

## Alerts

| Alert | Severity | Fires when |
|---|---|---|
| `MinioDisksOffline` | critical | any disk is offline for 1m |
| `MinioStorageUsed` | warning | disk usage is above `alertsWarningStorageUsed` for 1m |

## Import as a library

```sh
jb install github.com/grafana/jsonnet-libs/minio-mixin
```

```jsonnet
local lib = import 'minio-mixin/main.libsonnet';

(lib.new()
 + lib.withConfigMixin({
   filteringSelector: 'job="integrations/minio"',
 })).asMonitoringMixin()
```

### Legacy `_config` usage

`mixin.libsonnet` still accepts `_config` overrides, for existing consumers:

```jsonnet
(import 'minio-mixin/mixin.libsonnet') { _config+:: { filteringSelector: 'job="integrations/minio"' } }
```

## Configuration

| Key | Default | Description |
|---|---|---|
| `filteringSelector` | `''` | Static selector for all queries and alerts. |
| `groupLabels` | `['job']` | |
| `instanceLabels` | `['instance']` | Storage queries also keep `disk`. |
| `uid` | `'minio'` | Prefix for the alert group name. Any value other than the default also sets the dashboard uid to `<uid>-overview`. |
| `dashboardNamePrefix` | `'MinIO '` | |
| `dashboardTags` | `['minio']` | |
| `dashboardPeriod` | `'now-1h'` | |
| `dashboardTimezone` | `'default'` | |
| `dashboardRefresh` | `'1m'` | |
| `metricsSource` | `['prometheus']` | |
| `alertsWarningStorageUsed` | `80` | % of disk capacity used. |
