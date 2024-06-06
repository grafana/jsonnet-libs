local g = import './g.libsonnet';
local var = g.dashboard.variable;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

local extendedUtils = utils {
  toSentenceCase(string)::
    local noUnderscore = std.join(' ', std.split(string, '_'));
    local noNameSuffix = if std.endsWith(noUnderscore, ' name') then std.substr(noUnderscore, 0, std.length(noUnderscore) - 5) else noUnderscore;
    local noVcenterPrefix = if std.startsWith(noNameSuffix, 'vcenter ') then std.substr(noNameSuffix, 8, std.length(noNameSuffix) - 8) else noNameSuffix;
    std.asciiUpper(noVcenterPrefix[0]) + std.slice(noVcenterPrefix, 1, std.length(noVcenterPrefix), 1),

  labelsToPromQLSelector(labels, optionalLabels)::
    std.join(
      ',',
      [
        if std.member(optionalLabels, label)
        then '%s=~"$%s|"' % [label, label]
        else '%s=~"$%s"' % [label, label]
        for label in labels
      ]
    ),

  labelsToPromQLSelectorWithEmptyOptions(labels, optionalLabels, emptyLabels)::
    std.join(
      ',',
      [
        if std.member(optionalLabels, label)
        then '%s=~"$%s|"' % [label, label]
        else if std.member(emptyLabels, label)
        then '%s=""' % [label]
        else '%s=~"$%s"' % [label, label]
        for label in labels
      ]
    ),
};

// Generates chained variables to use on on all dashboards
{
  new(this, varMetric):
    {
      local filteringSelector = this.config.filteringSelector,
      local groupLabels = this.config.groupLabels,
      local datacenterLabels = this.config.datacenterLabels,
      local clusterLabels = this.config.clusterLabels,
      local hostLabels = this.config.hostLabels,
      local hostOptionalLabels = ['vcenter_cluster_name'],
      local virtualMachineLabels = this.config.virtualMachineLabels,
      local virtualMachineOptionalLabels = ['vcenter_cluster_name', 'vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path'],
      local clusterLabel = 'vcenter_cluster_name',
      local clusterSelector = 'job=~"integrations/vsphere",job=~"$job",vcenter_datacenter_name=~"$vcenter_datacenter_name"',
      local hostLabel = 'vcenter_host_name',
      local hostQuery = 'query_result(sum(vcenter_vm_memory_usage_mebibytes{job=~"$job",vcenter_datacenter_name=~"$vcenter_datacenter_name",vcenter_cluster_name=~"$vcenter_cluster_name|"}) by (vcenter_host_name))',
      local hostRegex = '/vcenter_host_name="([^"]*)/',
      local resourcePoolLabel = 'vcenter_resource_pool_inventory_path',
      local resourcePoolSelector = 'job=~"integrations/vsphere",job=~"$job",vcenter_datacenter_name=~"$vcenter_datacenter_name",vcenter_cluster_name=~"$vcenter_cluster_name|",vcenter_host_name=~"$vcenter_host_name"',
      local virtualAppLabel = 'vcenter_virtual_app_inventory_path',
      local virtualAppSelector = 'job=~"integrations/vsphere",job=~"$job",vcenter_datacenter_name=~"$vcenter_datacenter_name",vcenter_cluster_name=~"$vcenter_cluster_name|",vcenter_host_name=~"$vcenter_host_name"',
      local vmLabel = 'vcenter_vm_name',
      local vmQuery = 'query_result((sum(label_join(sgn(sum by(vcenter_resource_pool_inventory_path,vcenter_vm_name)(vcenter_vm_memory_usage_mebibytes{job=~"$job",vcenter_datacenter_name=~"$vcenter_datacenter_name",vcenter_cluster_name=~"$vcenter_cluster_name|",vcenter_host_name=~"$vcenter_host_name",vcenter_resource_pool_inventory_path=~"$vcenter_resource_pool_inventory_path",vcenter_resource_pool_inventory_path!=""})),"vm_path","/","vcenter_resource_pool_inventory_path","vcenter_vm_name")) by (vm_path,vcenter_vm_name)) or (sum(label_join(sgn(sum by(vcenter_virtual_app_inventory_path,vcenter_vm_name)(vcenter_vm_memory_usage_mebibytes{job=~"$job",vcenter_datacenter_name=~"$vcenter_datacenter_name",vcenter_cluster_name=~"$vcenter_cluster_name|",vcenter_host_name=~"$vcenter_host_name",vcenter_virtual_app_inventory_path=~"$vcenter_virtual_app_inventory_path",vcenter_virtual_app_inventory_path!=""})),"vm_path","/","vcenter_virtual_app_inventory_path","vcenter_vm_name")) by (vm_path,vcenter_vm_name)) or (sum(label_replace(sgn(sum by(vcenter_resource_pool_inventory_path,vcenter_virtual_app_inventory_path,vcenter_vm_name)(vcenter_vm_memory_usage_mebibytes{job=~"$job",vcenter_datacenter_name=~"$vcenter_datacenter_name",vcenter_cluster_name=~"$vcenter_cluster_name|",vcenter_host_name=~"$vcenter_host_name",vcenter_resource_pool_inventory_path="",vcenter_virtual_app_inventory_path=""})),"vm_path","$1","vcenter_vm_name","(.*)")) by (vm_path,vcenter_vm_name)))',
      local vmRegex = '/vcenter_vm_name="(?<value>[^"]*)",vm_path="(?<text>[^"]*)"/',

      local varMetric = 'vcenter_vm_memory_usage_mebibytes',
      local topResourceSelector =
        var.custom.new(
          'top_resource_count',
          values=[2, 4, 6, 8, 10],
        )
        + var.custom.generalOptions.withDescription(
          'This variable allows for modification of top resource value.'
        )
        + var.custom.generalOptions.withLabel('Top resource count'),
      local root = self,
      local groupVariablesFromLabels(groupLabels, filteringSelector) =
        local chainVarProto(index, chainVar) =
          var.query.new(chainVar.label)
          + var.query.withDatasourceFromVariable(root.datasources.prometheus)
          + var.query.queryTypes.withLabelValues(
            chainVar.label,
            '%s{%s}' % [varMetric, chainVar.chainSelector],
          )
          + var.query.generalOptions.withLabel(extendedUtils.toSentenceCase(chainVar.label))
          + var.query.selectionOptions.withIncludeAll(
            value=true,
            customAllValue='.+'
          )
          + var.query.selectionOptions.withMulti(
            true,
          )
          + var.query.refresh.onTime()
          + var.query.withSort(
            i=1,
            type='alphabetical',
            asc=true,
            caseInsensitive=false
          );
        std.mapWithIndex(chainVarProto, utils.chainLabels(groupLabels, [filteringSelector])),
      datasources: {
        prometheus:
          var.datasource.new('prometheus_datasource', 'prometheus')
          + var.datasource.generalOptions.withLabel('Data source')
          + var.datasource.withRegex(''),
        loki:
          var.datasource.new('loki_datasource', 'loki')
          + var.datasource.generalOptions.withLabel('Loki data source')
          + var.datasource.withRegex('(?!grafanacloud.+usage-insights|grafanacloud.+alert-state-history).+')
          + var.datasource.generalOptions.showOnDashboard.withNothing(),
      },

      local createQueryVariable(name, displayName, query, regex, includeAll) =
        local variable =
          var.query.new(name, query)
          + var.query.generalOptions.withLabel(displayName)
          + var.query.withDatasourceFromVariable(root.datasources.prometheus)
          + var.query.withRegex(regex)
          + var.query.selectionOptions.withIncludeAll(value=includeAll)
          + var.query.selectionOptions.withMulti(true)
          + var.query.refresh.onTime()
          + var.query.withSort(
            i=1,
            type='alphabetical',
            asc=true,
            caseInsensitive=false,
          );
        [variable],
      local createLabelValueVariable(name, displayName, metric, selector, label, includeAll) =
        local variable =
          var.query.new(name)
          + var.query.generalOptions.withLabel(displayName)
          + var.query.withDatasourceFromVariable(root.datasources.prometheus)
          + var.query.queryTypes.withLabelValues(
            label,
            '%s{%s}' % [metric, selector],
          )
          + var.query.selectionOptions.withIncludeAll(value=includeAll)
          + var.query.selectionOptions.withMulti(true)
          + var.query.refresh.onTime()
          + var.query.withSort(
            i=1,
            type='alphabetical',
            asc=true,
            caseInsensitive=false,
          );
        [variable],

      overviewVariables:
        [root.datasources.prometheus]
        + groupVariablesFromLabels(groupLabels + datacenterLabels, filteringSelector) + [topResourceSelector],
      clusterVariables:
        [root.datasources.prometheus]
        + groupVariablesFromLabels(groupLabels + datacenterLabels, filteringSelector)
        + createLabelValueVariable(clusterLabel, 'vSphere cluster', varMetric, clusterSelector, clusterLabel, true),
      hostsVariable:
        [root.datasources.prometheus]
        + groupVariablesFromLabels(groupLabels + datacenterLabels, filteringSelector)
        + createLabelValueVariable(clusterLabel, 'vSphere cluster', varMetric, clusterSelector, clusterLabel, true)
        + createQueryVariable(hostLabel, 'ESXi host', hostQuery, hostRegex, true),
      virtualMachinesVariables:
        [root.datasources.prometheus]
        + groupVariablesFromLabels(groupLabels + datacenterLabels, filteringSelector)
        + createLabelValueVariable(clusterLabel, 'vSphere cluster', varMetric, clusterSelector, clusterLabel, true)
        + createQueryVariable(hostLabel, 'ESXi host', hostQuery, hostRegex, true)
        + createLabelValueVariable(resourcePoolLabel, 'Resource pool', varMetric, resourcePoolSelector, resourcePoolLabel, true)
        + createLabelValueVariable(virtualAppLabel, 'Virtual app', varMetric, virtualAppSelector, virtualAppLabel, true)
        + createQueryVariable(vmLabel, 'Virtual machine', vmQuery, vmRegex, true),

      queriesSelector:
        '%s' % [
          utils.labelsToPromQLSelector(groupLabels + datacenterLabels),
        ],
      clusterQueriesSelector:
        '%s' % [
          utils.labelsToPromQLSelector(groupLabels + datacenterLabels + clusterLabels),
        ],
      clusterNoRPoolQueriesSelector:
        '%s' % [
          extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + clusterLabels + ['vcenter_resource_pool_inventory_path'], [], ['vcenter_resource_pool_inventory_path']),
        ],
      clusterNoVAppQueriesSelector:
        '%s' % [
          extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + clusterLabels + ['vcenter_virtual_app_inventory_path'], [], ['vcenter_virtual_app_inventory_path']),
        ],
      clusterNoRPoolOrVAppQueriesSelector:
        '%s' % [
          extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + clusterLabels + ['vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path'], [], ['vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path']),
        ],
      hostQueriesSelector:
        '%s' % [
          extendedUtils.labelsToPromQLSelector(groupLabels + datacenterLabels + hostLabels, hostOptionalLabels),
        ],
      hostWithClusterQueriesSelector:
        '%s' % [
          utils.labelsToPromQLSelector(groupLabels + datacenterLabels + hostLabels),
        ],
      hostNoClusterQueriesSelector:
        '%s' % [
          extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + hostLabels, [], hostOptionalLabels),
        ],
      hostNoRPoolQueriesSelector:
        '%s' % [
          extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + hostLabels + ['vcenter_resource_pool_inventory_path'], ['vcenter_cluster_name'], ['vcenter_resource_pool_inventory_path']),
        ],
      hostNoVAppQueriesSelector:
        '%s' % [
          extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + hostLabels + ['vcenter_virtual_app_inventory_path'], ['vcenter_cluster_name'], ['vcenter_virtual_app_inventory_path']),
        ],
      hostNoRPoolOrVAppQueriesSelector:
        '%s' % [
          extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + hostLabels + ['vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path'], ['vcenter_cluster_name'], ['vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path']),
        ],
      virtualMachinesQueriesSelector:
        '%s' % [
          extendedUtils.labelsToPromQLSelector(groupLabels + datacenterLabels + virtualMachineLabels, virtualMachineOptionalLabels),
        ],
      virtualMachinesNoRPoolQueriesSelector:
        '%s' % [
          extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + virtualMachineLabels, ['vcenter_cluster_name'], ['vcenter_resource_pool_inventory_path']),
        ],
      virtualMachinesNoVAppQueriesSelector:
        '%s' % [
          extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + virtualMachineLabels, ['vcenter_cluster_name'], ['vcenter_virtual_app_inventory_path']),
        ],
      virtualMachinesNoRPoolOrVAppQueriesSelector:
        '%s' % [
          extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + virtualMachineLabels, ['vcenter_cluster_name'], ['vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path']),
        ],
      queriesGroupSelectorAdvanced:
        '%s' % [
          utils.labelsToPromQLSelectorAdvanced(groupLabels + datacenterLabels),
        ],
    },
}
