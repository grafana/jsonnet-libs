// Ignore smelly selectors for alerts that legitimately need to match istiod pods by prefix
rule {
  match {
    kind = "alerting"
    name = "IstioGalleyValidationFailuresWarning"
  }
  disable = ["promql/regexp"]
}

rule {
  match {
    kind = "alerting"
    name = "IstioListenerConfigConflictsCritical"
  }
  disable = ["promql/regexp"]
}

rule {
  match {
    kind = "alerting"
    name = "IstioXDSConfigRejectionsWarning"
  }
  disable = ["promql/regexp"]
}
