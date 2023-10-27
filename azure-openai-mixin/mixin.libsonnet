local azure_openai_lib = import './main.libsonnet';

local azure_openai =
  azure_openai_lib.new(
    filteringSelector='job="integrations/azure-openai"',
    uid='azure-openai',
    dashboardNamePrefix='Azure OpenAI ',
    groupLabels=['subscriptionID', 'resourceGroup'],
    instanceLabels=['resourceName'],
  )
  + azure_openai_lib.withConfigMixin(
    {
      // disable loki logs
      enableLokiLogs: false,
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: azure_openai.grafana.dashboards,
  prometheusAlerts+:: azure_openai.prometheus.alerts,
  prometheusRules+:: azure_openai.prometheus.recordingRules,
}
