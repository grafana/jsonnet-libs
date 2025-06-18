local g = import './g.libsonnet';
local var = g.dashboard.variable;
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

// Generates chained variables to use on all dashboards
{
  new(this, varMetric):
    {
      local filteringSelector = this.config.filteringSelector,
      local groupLabels = this.config.groupLabels,
      local instanceLabels = this.config.instanceLabels,

      local root = self,
      // Helper function to create variables from specific label list
      local variablesFromSpecificLabels(labels, filteringSelector, multiInstance=true) =
        local chainVarProto(index, chainVar) =
          var.query.new(chainVar.label)
          + var.query.withDatasourceFromVariable(root.datasources.prometheus)
          + var.query.queryTypes.withLabelValues(
            chainVar.label,
            // Combine filteringSelector with chainSelector, avoiding duplicate label filters
            local combinedSelector = 
              if std.length(std.stripChars(filteringSelector, ' ')) == 0 then chainVar.chainSelector
              else if std.length(chainVar.chainSelector) == 0 then std.stripChars(filteringSelector, ' ')
              else
                // Both exist - need to merge intelligently to avoid duplicates
                local filteringParts = std.split(std.stripChars(filteringSelector, ' '), ',');
                local filteringLabels = std.set([
                  std.stripChars(std.split(std.stripChars(part, ' '), '=')[0], ' ')
                  for part in filteringParts
                  if std.length(std.split(part, '=')) > 1
                ]);
                local chainParts = std.split(chainVar.chainSelector, ',');
                local chainFiltered = std.filter(function(part)
                  local label = std.stripChars(std.split(std.stripChars(part, ' '), '=')[0], ' ');
                  !std.setMember(label, filteringLabels),
                  chainParts
                );
                std.join(',', std.filter(function(x) std.length(x) > 0, [std.stripChars(filteringSelector, ' ')] + chainFiltered));
            '%s{%s}' % [varMetric, combinedSelector],
          )
          + var.query.generalOptions.withLabel(utils.toSentenceCase(chainVar.label))
          + var.query.selectionOptions.withIncludeAll(
            value=true,
            customAllValue='.+'
          )
          + var.query.selectionOptions.withMulti(multiInstance)
          + var.query.refresh.onTime()
          + var.query.withSort(
            i=1,
            type='alphabetical',
            asc=true,
            caseInsensitive=false
          );

        // Create variables for all labels, let chainLabels handle the chaining without filteringSelector
        std.mapWithIndex(chainVarProto, utils.chainLabels(labels, [])),

      datasources: {
        prometheus:
          var.datasource.new('prometheus_datasource', 'prometheus')
          + var.datasource.generalOptions.withLabel('Prometheus data source')
          + var.datasource.withRegex(''),
        loki:
          var.datasource.new('loki_datasource', 'loki')
          + var.datasource.generalOptions.withLabel('Loki data source')
          + var.datasource.withRegex(''),
      },

      // Dashboard-specific variable sets
      clusterVariables:
        [root.datasources.prometheus]
        + variablesFromSpecificLabels(this.config.dashboardVariables.cluster, filteringSelector, multiInstance=false),

      nodeVariables:
        [root.datasources.prometheus]
        + variablesFromSpecificLabels(this.config.dashboardVariables.node, filteringSelector, multiInstance=true),

      bucketVariables:
        [root.datasources.prometheus]
        + variablesFromSpecificLabels(this.config.dashboardVariables.bucket, filteringSelector, multiInstance=true),

      clusterSelector:
        '%s' % [
          utils.labelsToPromQLSelector(this.config.dashboardVariables.cluster),
        ],

      nodeSelector:
        '%s' % [
          utils.labelsToPromQLSelector(this.config.dashboardVariables.node),
        ],

      bucketSelector:
        '%s' % [
          utils.labelsToPromQLSelector(this.config.dashboardVariables.bucket),
        ],
    },
}
