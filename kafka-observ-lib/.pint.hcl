//ignore fragile promql selectors for JVM memory alerts
checks {
  disabled = ["promql/fragile"]
}
