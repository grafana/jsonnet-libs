//ignore smelly selectors only for specific disk alerts with legitimate volume filtering
rule {
  match {
    kind = "alerting"
    name = "WindowsDiskAlmostOutOfSpace"
  }
  disable = ["promql/regexp"]
}