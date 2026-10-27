// job_snmp is matched by prefix in these alerts
rule {
  match {
    kind = "alerting"
    name = "SNMPTargetDown"
  }
  disable = ["promql/regexp"]
}

rule {
  match {
    kind = "alerting"
    name = "SNMPTargetInterfaceDown"
  }
  disable = ["promql/regexp"]
}
