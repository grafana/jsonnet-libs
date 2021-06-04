local grafana = import '../../../grafana.libsonnet';
local datasources = import 'datasources.libsonnet';
local mixins = import 'mixins.libsonnet';

grafana
+ grafana.withImage('grafana/grafana:8.0.0-beta3')
+ grafana.withRootUrl('http://grafana.example.com')
+ grafana.withTheme('dark')
+ grafana.withAnonymous()

// Datasources
+ grafana.addDatasource('Prometheus', datasources.prometheus)

// Mixins
+ grafana.addMixinDashboards(mixins)
