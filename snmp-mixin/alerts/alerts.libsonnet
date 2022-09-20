{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'snmp',
        rules: [
                 {
                   alert: 'SNMPTargetDown',
                   expr: 'up{job_snmp=~"integrations/snmp.*"} == 0',
                   labels: {
                     severity: 'critical',
                   },
                   annotations: {
                     summary: 'SNMP target {{$labels.snmp_target}} on instance {{$labels.instance}} from job {{$labels.job}} is down.',
                     description: 'SNMP Target {{$labels.snmp_target}} is down.',
                   },
                   'for': '5m',
                 },
                 {
                   alert: 'SNMPTargetInterfaceDown',
                   expr: 'ifOperStatus{job_snmp=~"integrations/snmp.*"} == 0',
                   labels: {
                     severity: 'warning',
                   },
                   annotations: {
                     summary: 'SNMP interface {{$labels.ifDescr}} on target {{$labels.snmp_target}} on instance {{$labels.instance}} from job {{$labels.job}} is down.',
                     description: 'SNMP interface {{$labels.ifDescr}} on target {{$labels.snmp_target}} is down.',
                   },
                   'for': '5m',
                 },
               ]
      },
    ],
  },
}
