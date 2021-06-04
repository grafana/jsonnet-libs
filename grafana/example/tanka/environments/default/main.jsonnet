local grafana = import '../../../grafana.libsonnet';
local nyc_dashboard = import 'dashboards/nyc.json';
local datasources = import 'datasources.libsonnet';
local mixins = import 'mixins.libsonnet';

grafana
+ grafana.withImage('grafana/grafana:8.0.0-beta3')
+ grafana.withRootUrl('http://grafana.example.com')
+ grafana.withTheme('dark')
+ grafana.withAnonymous()

// Plugins
+ grafana.addPlugin('fetzerch-sunandmoon-datasource')

// Datasources
+ grafana.addDatasource('Prometheus', datasources.prometheus)
+ grafana.addDatasource('NYC', datasources.sun_and_moon)

// Dashboards
+ grafana.addDashboard('NYC', nyc_dashboard, 'Sun and Moon')

// Mixins
+ grafana.addMixinDashboards(mixins)
