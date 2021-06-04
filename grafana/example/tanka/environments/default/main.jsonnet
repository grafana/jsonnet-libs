local grafana = import '../../../grafana.libsonnet';

grafana
+ grafana.withTheme('dark')
