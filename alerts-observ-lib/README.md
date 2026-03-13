# Alerts observability library

Single ALERTS signal with one alerts-overview dashboard (alertlist panel grouped by configurable labels).

## Example

```jsonnet
local alertslib = import 'alerts-observ-lib/main.libsonnet';

alertslib.new()
+ alertslib.withConfigMixin({
  filteringSelector: 'job="integrations/myapp"',
  groupLabels: ['cluster', 'container'],
  instanceLabels: ['instance'],
  uid: 'myapp',
})
| asMonitoringMixin()
```
