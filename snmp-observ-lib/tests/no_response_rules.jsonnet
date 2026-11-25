// SNMPExporterNoResponse is generated only when filteringSelector is set.
local snmplib = import '../main.libsonnet';
local snmp =
  snmplib.new()
  + snmplib.withConfigMixin({ filteringSelector: 'job=~"integrations/snmp.*"' });
{
  groups: [
    group { rules: std.filter(function(rule) rule.alert == 'SNMPExporterNoResponse', group.rules) }
    for group in snmp.prometheus.alerts.groups
    if std.length(std.filter(function(rule) rule.alert == 'SNMPExporterNoResponse', group.rules)) > 0
  ],
}
