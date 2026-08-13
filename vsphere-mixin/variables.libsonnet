local g = import './g.libsonnet';
local var = g.dashboard.variable;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

// vSphere's inventory is a five-level hierarchy (datacenter > cluster > ESXi host >
// resource pool / virtual app > VM), deeper than the group/instance split
// commonlib.variables models, and a VM's parent may be a resource pool OR a virtual
// app OR neither. The chained variables below are therefore built here; datasources
// come from commonlib.
local extendedUtils = utils {
  // commonlib's toSentenceCase only uppercases the first character. vSphere labels are
  // long and fully qualified (vcenter_datacenter_name), so drop the vendor prefix and
  // the trailing 'name' to get a readable dashboard label ('Datacenter').
  toSentenceCase(string)::
    local noUnderscore = std.join(' ', std.split(string, '_'));
    local noNameSuffix = if std.endsWith(noUnderscore, ' name') then std.substr(noUnderscore, 0, std.length(noUnderscore) - 5) else noUnderscore;
    local noVcenterPrefix = if std.startsWith(noNameSuffix, 'vcenter ') then std.substr(noNameSuffix, 8, std.length(noNameSuffix) - 8) else noNameSuffix;
    std.asciiUpper(noVcenterPrefix[0]) + std.slice(noVcenterPrefix, 1, std.length(noVcenterPrefix), 1),
};

// Generates chained variables to use on all dashboards
{
  new(this):
    {
      local filteringSelector = this.config.filteringSelector,
      local groupLabels = this.config.groupLabels,
      local datacenterLabels = this.config.datacenterLabels,
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
      // The goal for this query is to combine the VM name with its parent Inventory Path (Resource Pool or Virtual App).
      // Needs different label joins/label replace whether the Resource Pool Inventory Path exists for the VM,
      // whether the Virtual App Inventory Path exists for the VM,
      // or (hopefully this never actually occurs) if neither exists for the VM.
      local vmQuery = 'query_result((sum(label_join(sgn(sum by(vcenter_resource_pool_inventory_path,vcenter_vm_name) (vcenter_vm_memory_usage_mebibytes{job=~"$job",vcenter_datacenter_name=~"$vcenter_datacenter_name",vcenter_cluster_name=~"$vcenter_cluster_name|",vcenter_host_name=~"$vcenter_host_name",vcenter_resource_pool_inventory_path=~"$vcenter_resource_pool_inventory_path",vcenter_resource_pool_inventory_path!=""})),"vm_path","/","vcenter_resource_pool_inventory_path","vcenter_vm_name")) by (vm_path,vcenter_vm_name)) or (sum(label_join(sgn(sum by(vcenter_virtual_app_inventory_path,vcenter_vm_name) (vcenter_vm_memory_usage_mebibytes{job=~"$job",vcenter_datacenter_name=~"$vcenter_datacenter_name",vcenter_cluster_name=~"$vcenter_cluster_name|",vcenter_host_name=~"$vcenter_host_name",vcenter_virtual_app_inventory_path=~"$vcenter_virtual_app_inventory_path",vcenter_virtual_app_inventory_path!=""})),"vm_path","/","vcenter_virtual_app_inventory_path","vcenter_vm_name")) by (vm_path,vcenter_vm_name)) or (sum(label_replace(sgn(sum by(vcenter_resource_pool_inventory_path,vcenter_virtual_app_inventory_path,vcenter_vm_name) (vcenter_vm_memory_usage_mebibytes{job=~"$job",vcenter_datacenter_name=~"$vcenter_datacenter_name",vcenter_cluster_name=~"$vcenter_cluster_name|",vcenter_host_name=~"$vcenter_host_name",vcenter_resource_pool_inventory_path="",vcenter_virtual_app_inventory_path=""})),"vm_path","$1","vcenter_vm_name","(.*)")) by (vm_path,vcenter_vm_name)))',
      local vmRegex = '/vcenter_vm_name="(?<value>[^"]*)",vm_path="(?<text>[^"]*)"/',

      // Present on every vSphere deployment, so it is a safe basis for the chained
      // job/datacenter variables.
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

      datasources:
        commonlib.variables.new(
          filteringSelector=filteringSelector,
          groupLabels=groupLabels,
          instanceLabels=datacenterLabels,
          varMetric=varMetric,
          enableLokiLogs=this.config.enableLokiLogs,
          prometheusDatasourceName='prometheus_datasource',
          prometheusDatasourceLabel='Data source',
        ).datasources,

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
    },
}
