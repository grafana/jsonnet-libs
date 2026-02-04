//ignore fragile promql selectors for OpenSearch latency alerts
checks {
  disabled = ["promql/fragile"]
}
