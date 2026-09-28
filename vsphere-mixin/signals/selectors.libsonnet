// Builds the bespoke per-context PromQL selector strings used by the vSphere
// signal expressions. Ported verbatim from variables.libsonnet so the rendered
// selectors are byte-identical to the legacy targets.libsonnet output.
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

local extendedUtils = utils {
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

function(this)
  local groupLabels = this.groupLabels;
  local datacenterLabels = this.datacenterLabels;
  local clusterLabels = this.clusterLabels;
  local hostLabels = this.hostLabels;
  local virtualMachineLabels = this.virtualMachineLabels;
  local hostOptionalLabels = ['vcenter_cluster_name'];
  local virtualMachineOptionalLabels = ['vcenter_cluster_name', 'vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path'];
  // Every selector is built from a non-empty label list, so filteringSelector is appended
  // last and only when set: the blank default cannot produce a leading or doubled comma.
  // Applied to the whole object below so a new selector cannot miss it.
  local withFilter(selector) =
    if this.filteringSelector != '' then selector + ',' + this.filteringSelector else selector;
  local rawSelectors = {
    queriesSelector:
      utils.labelsToPromQLSelector(groupLabels + datacenterLabels),
    clusterQueriesSelector:
      utils.labelsToPromQLSelector(groupLabels + datacenterLabels + clusterLabels),
    clusterNoRPoolQueriesSelector:
      extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + clusterLabels + ['vcenter_resource_pool_inventory_path'], [], ['vcenter_resource_pool_inventory_path']),
    clusterNoVAppQueriesSelector:
      extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + clusterLabels + ['vcenter_virtual_app_inventory_path'], [], ['vcenter_virtual_app_inventory_path']),
    clusterNoRPoolOrVAppQueriesSelector:
      extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + clusterLabels + ['vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path'], [], ['vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path']),
    hostQueriesSelector:
      extendedUtils.labelsToPromQLSelector(groupLabels + datacenterLabels + hostLabels, hostOptionalLabels),
    hostWithClusterQueriesSelector:
      utils.labelsToPromQLSelector(groupLabels + datacenterLabels + hostLabels),
    hostNoClusterQueriesSelector:
      extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + hostLabels, [], hostOptionalLabels),
    hostNoRPoolQueriesSelector:
      extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + hostLabels + ['vcenter_resource_pool_inventory_path'], ['vcenter_cluster_name'], ['vcenter_resource_pool_inventory_path']),
    hostNoVAppQueriesSelector:
      extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + hostLabels + ['vcenter_virtual_app_inventory_path'], ['vcenter_cluster_name'], ['vcenter_virtual_app_inventory_path']),
    hostNoRPoolOrVAppQueriesSelector:
      extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + hostLabels + ['vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path'], ['vcenter_cluster_name'], ['vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path']),
    virtualMachinesQueriesSelector:
      extendedUtils.labelsToPromQLSelector(groupLabels + datacenterLabels + virtualMachineLabels, virtualMachineOptionalLabels),
    virtualMachinesNoRPoolQueriesSelector:
      extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + virtualMachineLabels, ['vcenter_cluster_name'], ['vcenter_resource_pool_inventory_path']),
    virtualMachinesNoVAppQueriesSelector:
      extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + virtualMachineLabels, ['vcenter_cluster_name'], ['vcenter_virtual_app_inventory_path']),
    virtualMachinesNoRPoolOrVAppQueriesSelector:
      extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + virtualMachineLabels, ['vcenter_cluster_name'], ['vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path']),
  };
  {
    [name]: withFilter(rawSelectors[name])
    for name in std.objectFields(rawSelectors)
  }
