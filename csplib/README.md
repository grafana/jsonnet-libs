# CSPlib

A collection of dashboards and their component parts for cloud service provider SaaS services.

# Notes

## Blob Storage
* GCP - https://cloud.google.com/monitoring/api/metrics_gcp#gcp-storage
  * The `quota` metrics are alpha, and don't seem to be getting fetched by alloy, even when enabled as a metrics prefix. Perhaps this needs to be enabled for a project?
  * `replication` metrics are beta. The only metric which is being retrieved by alloy is `replication/meeting_rpo` which is consistently 1 for all buckets. It may not make sense to graph these metrics, but perhaps it's useful to have an alert?
  * `storage` metrics (object_count, total_bytes), have a "v2" which is beta. As such, this lib is using the (implied) v1 metrics which are GA.
* Azure - https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/microsoft-storage-storageaccounts-blobservices-metrics
  * `Availability` is an available metric. It may not make sense to graph this, but perhaps it is useful to have an alert?
  * There are latency metrics. In our test environment there is very little (no?) traffic. What I have observed is that E2E latency, and server latency is the same value in our limited dataset. Perhaps this should only show a delta, I.E. if E2E is greater than server.
  * Network throughput (ingress/egress) metrics for azure are gauges, not counters. Right now, the promql uses rate, which produces "odd" results. The other option, using `deriv` produces negative values with the available data, which is also suboptimal. We *could* just put the raw gauge value on the timeseries, and call it a day. :thinking:
* AWS - TODO