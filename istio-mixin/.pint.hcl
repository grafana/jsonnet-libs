// Ignore smelly selectors for alerts that legitimately match HTTP response code
// ranges. Istio emits response_code as a single value, so 5xx/4xx ranges can
// only be expressed via regexp.
rule {
  match {
    kind = "alerting"
    name = "IstioHigh5xxResponseRatio"
  }
  disable = ["promql/regexp"]
}

rule {
  match {
    kind = "alerting"
    name = "IstioHigh4xxResponseRatio"
  }
  disable = ["promql/regexp"]
}
