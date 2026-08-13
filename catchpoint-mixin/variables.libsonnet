local commonlib = import 'common-lib/common/main.libsonnet';

// Chained variables for the three dashboards, composed from commonlib.
//
// Catchpoint reports one series per test per node, so each drilldown pins one of
// those two labels and leaves the other multi-select. The pinned label joins the
// job/instance chain; the free label is queried unchained, so switching tests
// never empties the node picker (and vice versa).
{
  new(this, varMetric):
    local config = this.config;
    local chain(groupLabels, instanceLabels) =
      commonlib.variables.new(
        filteringSelector=config.filteringSelector,
        groupLabels=groupLabels,
        instanceLabels=instanceLabels,
        varMetric=varMetric,
        customAllValue='.+',
        prometheusDatasourceName='prometheus_datasource',
      );
    // A standalone multi-select variable, with commonlib's leading datasource dropped.
    local unchained(label) = chain([], [label]).multiInstance[1:];

    chain(config.groupLabels, config.instanceLabels)
    + {
      overviewVariables:
        chain(config.groupLabels, config.instanceLabels + config.testNameLabel).multiInstance,
      testNameVariables:
        chain(config.groupLabels, config.instanceLabels + config.testNameLabel).singleInstance
        + unchained(config.nodeNameLabel[0]),
      nodeNameVariables:
        chain(config.groupLabels, config.instanceLabels + config.nodeNameLabel).singleInstance
        + unchained(config.testNameLabel[0]),
    },
}
