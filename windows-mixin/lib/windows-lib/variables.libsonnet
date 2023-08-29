// variables.libsonnet
local g = import './g.libsonnet';
local var = g.dashboard.variable;
local utils = import './utils.libsonnet';

{
    new(
        filterSelector,
        groupLabels,
        instanceLabels,
        ): {

        local this = self,
        local varMetric = 'windows_os_info',
        local variablesFromLabels(groupLabels, instanceLabels, filterSelector, multiInstance=true) =
            local chainVarProto(index, chainVar) =
                var.query.new(chainVar.label)
                + var.query.withDatasourceFromVariable(this.datasource)
                + var.query.queryTypes.withLabelValues(
                chainVar.label,
                '%s{%s}' % [varMetric, chainVar.chainSelector],
                )
                
                + var.query.selectionOptions.withIncludeAll(
                    value=if (!multiInstance && std.member(instanceLabels, chainVar.label)) then false else true,
                    customAllValue=if index>0 then '.+' else null,
                )
                + var.query.selectionOptions.withMulti(
                    if (!multiInstance && std.member(instanceLabels, chainVar.label)) then false else true,
                )
                + var.query.withRefresh(2)
                + var.query.withSort(
                    i=1,
                    type='alphabetical',
                    asc=true,
                    caseInsensitive=false
                );
                std.mapWithIndex(chainVarProto, utils.chainLabels(groupLabels+instanceLabels, [filterSelector])),

        datasource:
            var.datasource.new('datasource', 'prometheus')
            + var.datasource.generalOptions.withLabel('Data Source'),

        multiInstance:
            [self.datasource]
            + variablesFromLabels(groupLabels, instanceLabels, filterSelector),
        singleInstance:
            [self.datasource]
            + variablesFromLabels(groupLabels, instanceLabels, filterSelector, multiInstance=false),

        queriesSelector:
        '%s,%s' % [
            filterSelector,
            utils.labelsToPromQLSelector(groupLabels+instanceLabels),
        ],
    }
}