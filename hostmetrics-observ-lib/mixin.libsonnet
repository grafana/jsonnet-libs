local hostmetricslib = import './main.libsonnet';

local hostmetrics =
  hostmetricslib.new()
  + hostmetricslib.withConfigMixin({
    filteringSelector: 'job=~".+"',
    uid: 'hostmetrics',
    dashboardNamePrefix: 'Hostmetrics / ',
    dashboardTags: ['hostmetrics'],
  });

hostmetrics.asMonitoringMixin()
