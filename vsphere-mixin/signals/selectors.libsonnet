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
  // config.libsonnet promises filteringSelector applies to panel queries too, not just to
  // the dashboard variables. Every selector below is built from a non-empty label list, so
  // filteringSelector is appended LAST, with the blank default it contributes nothing and
  // can never produce a leading or doubled comma.
  local withFilter(selector) =
    if this.filteringSelector != '' then selector + ',' + this.filteringSelector else selector;
  {
    queriesSelector:
      withFilter(utils.labelsToPromQLSelector(groupLabels + datacenterLabels)),
    clusterQueriesSelector:
      withFilter(utils.labelsToPromQLSelector(groupLabels + datacenterLabels + clusterLabels)),
    clusterNoRPoolQueriesSelector:
      withFilter(extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + clusterLabels + ['vcenter_resource_pool_inventory_path'], [], ['vcenter_resource_pool_inventory_path'])),
    clusterNoVAppQueriesSelector:
      withFilter(extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + clusterLabels + ['vcenter_virtual_app_inventory_path'], [], ['vcenter_virtual_app_inventory_path'])),
    clusterNoRPoolOrVAppQueriesSelector:
      withFilter(extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + clusterLabels + ['vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path'], [], ['vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path'])),
    hostQueriesSelector:
      withFilter(extendedUtils.labelsToPromQLSelector(groupLabels + datacenterLabels + hostLabels, hostOptionalLabels)),
    hostWithClusterQueriesSelector:
      withFilter(utils.labelsToPromQLSelector(groupLabels + datacenterLabels + hostLabels)),
    hostNoClusterQueriesSelector:
      withFilter(extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + hostLabels, [], hostOptionalLabels)),
    hostNoRPoolQueriesSelector:
      withFilter(extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + hostLabels + ['vcenter_resource_pool_inventory_path'], ['vcenter_cluster_name'], ['vcenter_resource_pool_inventory_path'])),
    hostNoVAppQueriesSelector:
      withFilter(extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + hostLabels + ['vcenter_virtual_app_inventory_path'], ['vcenter_cluster_name'], ['vcenter_virtual_app_inventory_path'])),
    hostNoRPoolOrVAppQueriesSelector:
      withFilter(extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + hostLabels + ['vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path'], ['vcenter_cluster_name'], ['vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path'])),
    virtualMachinesQueriesSelector:
      withFilter(extendedUtils.labelsToPromQLSelector(groupLabels + datacenterLabels + virtualMachineLabels, virtualMachineOptionalLabels)),
    virtualMachinesNoRPoolQueriesSelector:
      withFilter(extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + virtualMachineLabels, ['vcenter_cluster_name'], ['vcenter_resource_pool_inventory_path'])),
    virtualMachinesNoVAppQueriesSelector:
      withFilter(extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + virtualMachineLabels, ['vcenter_cluster_name'], ['vcenter_virtual_app_inventory_path'])),
    virtualMachinesNoRPoolOrVAppQueriesSelector:
      withFilter(extendedUtils.labelsToPromQLSelectorWithEmptyOptions(groupLabels + datacenterLabels + virtualMachineLabels, ['vcenter_cluster_name'], ['vcenter_resource_pool_inventory_path', 'vcenter_virtual_app_inventory_path'])),
  }
