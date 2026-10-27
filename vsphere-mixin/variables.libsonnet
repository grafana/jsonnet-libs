local g = import './g.libsonnet';
local var = g.dashboard.variable;
local commonlib = import 'common-lib/common/main.libsonnet';

// vSphere's inventory is a five-level hierarchy (datacenter > cluster > ESXi host >
// resource pool / virtual app > VM), deeper than the group/instance split
// commonlib.variables models, and a VM's parent may be a resource pool OR a virtual
// app OR neither. The datasource and the job -> datacenter chain come from commonlib;
// the levels below the datacenter are built here.

// Generates chained variables to use on all dashboards
{
  new(this):
    {
      local filteringSelector = this.config.filteringSelector,
      local groupLabels = this.config.groupLabels,
      local datacenterLabels = this.config.datacenterLabels,
      // filteringSelector is appended LAST, and only when non-blank, so that the blank
      // default in config.libsonnet can never render a leading or doubled comma. It is
      // never spelled out as a literal here -- config.libsonnet is the only place a job
      // filter is set.
      local withFilter(selector) =
        if filteringSelector != '' then selector + ',' + filteringSelector else selector,

      local datacenterSelector = 'job=~"$job",vcenter_datacenter_name=~"$vcenter_datacenter_name"',
      local upToClusterSelector = datacenterSelector + ',vcenter_cluster_name=~"$vcenter_cluster_name|"',
      local upToHostSelector = upToClusterSelector + ',vcenter_host_name=~"$vcenter_host_name"',

      local clusterLabel = 'vcenter_cluster_name',
      local clusterSelector = withFilter(datacenterSelector),
      local hostLabel = 'vcenter_host_name',
      local hostQuery = 'query_result(sum(vcenter_vm_memory_usage_mebibytes{' + withFilter(upToClusterSelector) + '}) by (vcenter_host_name))',
      local hostRegex = '/vcenter_host_name="([^"]*)/',
      local resourcePoolLabel = 'vcenter_resource_pool_inventory_path',
      local resourcePoolSelector = withFilter(upToHostSelector),
      local virtualAppLabel = 'vcenter_virtual_app_inventory_path',
      local virtualAppSelector = withFilter(upToHostSelector),
      local vmLabel = 'vcenter_vm_name',
      // The goal for this query is to combine the VM name with its parent Inventory Path (Resource Pool or Virtual App).
      // Needs different label joins/label replace whether the Resource Pool Inventory Path exists for the VM,
      // whether the Virtual App Inventory Path exists for the VM,
      // or (hopefully this never actually occurs) if neither exists for the VM.
      // Each of the three branches carries its own matcher list, so filteringSelector is
      // appended last to each of them independently.
      local vmInResourcePoolSelector = withFilter(upToHostSelector + ',vcenter_resource_pool_inventory_path=~"$vcenter_resource_pool_inventory_path",vcenter_resource_pool_inventory_path!=""'),
      local vmInVirtualAppSelector = withFilter(upToHostSelector + ',vcenter_virtual_app_inventory_path=~"$vcenter_virtual_app_inventory_path",vcenter_virtual_app_inventory_path!=""'),
      local vmInNeitherSelector = withFilter(upToHostSelector + ',vcenter_resource_pool_inventory_path="",vcenter_virtual_app_inventory_path=""'),
      local vmQuery =
        'query_result('
        + '(sum(label_join(sgn(sum by(vcenter_resource_pool_inventory_path,vcenter_vm_name) (vcenter_vm_memory_usage_mebibytes{' + vmInResourcePoolSelector + '})),"vm_path","/","vcenter_resource_pool_inventory_path","vcenter_vm_name")) by (vm_path,vcenter_vm_name))'
        + ' or (sum(label_join(sgn(sum by(vcenter_virtual_app_inventory_path,vcenter_vm_name) (vcenter_vm_memory_usage_mebibytes{' + vmInVirtualAppSelector + '})),"vm_path","/","vcenter_virtual_app_inventory_path","vcenter_vm_name")) by (vm_path,vcenter_vm_name))'
        + ' or (sum(label_replace(sgn(sum by(vcenter_resource_pool_inventory_path,vcenter_virtual_app_inventory_path,vcenter_vm_name) (vcenter_vm_memory_usage_mebibytes{' + vmInNeitherSelector + '})),"vm_path","$1","vcenter_vm_name","(.*)")) by (vm_path,vcenter_vm_name))'
        + ')',
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

      // The job -> datacenter chain, the datasource variable and the blank-selector
      // guarding are all standard, so they come straight from common-lib. Everything
      // below the datacenter (cluster -> host -> resource pool | virtual app -> VM) is
      // deeper and more branched than commonlib.variables can model, and is built here.
      local commonVariables =
        commonlib.variables.new(
          filteringSelector=filteringSelector,
          groupLabels=groupLabels,
          instanceLabels=datacenterLabels,
          varMetric=varMetric,
          enableLokiLogs=this.config.enableLokiLogs,
          prometheusDatasourceName='prometheus_datasource',
          prometheusDatasourceLabel='Data source',
        ),
      datasources: commonVariables.datasources,
      // The job -> datacenter chain comes straight from common-lib, labels and all.
      // commonlib also appends the Loki datasource here when enableLokiLogs is set; it is
      // hidden and unreferenced on these Prometheus dashboards, so it rides along rather
      // than being filtered back out.
      local baseVariables = commonVariables.multiInstance,

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
        baseVariables + [topResourceSelector],
      clusterVariables:
        baseVariables
        + createLabelValueVariable(clusterLabel, 'vSphere cluster', varMetric, clusterSelector, clusterLabel, true),
      hostsVariable:
        baseVariables
        + createLabelValueVariable(clusterLabel, 'vSphere cluster', varMetric, clusterSelector, clusterLabel, true)
        + createQueryVariable(hostLabel, 'ESXi host', hostQuery, hostRegex, true),
      virtualMachinesVariables:
        baseVariables
        + createLabelValueVariable(clusterLabel, 'vSphere cluster', varMetric, clusterSelector, clusterLabel, true)
        + createQueryVariable(hostLabel, 'ESXi host', hostQuery, hostRegex, true)
        + createLabelValueVariable(resourcePoolLabel, 'Resource pool', varMetric, resourcePoolSelector, resourcePoolLabel, true)
        + createLabelValueVariable(virtualAppLabel, 'Virtual app', varMetric, virtualAppSelector, virtualAppLabel, true)
        + createQueryVariable(vmLabel, 'Virtual machine', vmQuery, vmRegex, true),
    },
}
