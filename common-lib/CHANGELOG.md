# 0.6.2
- [Panels] chore: panel requests.stat.errors use default palette color if there are no errors and red color if erorrs > 0.

# 0.6.1
- [Signal] chore: bump grafonnet to 11.4.0.
- [Panels] chore: add tests for generic panels.

# 0.6.0
- [Signal] feat: add new type of aggregation "aggKeepLabels" in addition to "group", "instance", "none".
- [Signal] feat: updated legend default format: "<aggLabel>: <nameShort> (<keepLabels>)".
- [Signal] feat: quantile=0.95 is removed from args of unmarshallJsonMulti(). Instead .withQuantile(q=0.95) modifier function is introduced, allowing multiple quantiles to be rendered from the single signal.
- [Signal] feat: introduce modifier signal functions: withLegendFormat, withHideNameInLegend, withName, withNameShort, withAgglevel, withAggFunction, withInstanceLabels, withInstanceLabelsMixin, withGroupLabels, withGroupLabelsMixin, withInterval, withAlertsInterval, withRangeFunction, withUnit. This boosts singals flexibility, allowing them to be modified just before rendering in panels/alerts.
- [Signal] feat: If signals of type=counter are rendered into tables (as columns etc...) their sum interval is changed from $__interval to $__range by default to accumulate sum of the full dashboard range.
- [Signal] feat: If multiple signals are being rendered into single panel, the panel is now populated with all signals' descriptions. All of them are appended with signals' short names.
- [Signal] chore: all renderer functions use this.signalName as name.

# 0.5.3
- [Panels] feat: generic.timeSeries.threshold now allow overriding colors.
- [Panels] feat: network.timeSeries.base: update withNegateOutPackets filter.

# 0.5.2
- [Signal] feat: Add helper getVariables() function.
- [Annotations] feat: Add new functions for "info","warning","critical" severity alerts.

# 0.5.1
- [Signal] fix: Fix info labels rendering as table columns.

# 0.5.0
- [Panels] feat: Move style choices (colors, line styles) to design tokens directory.

# 0.4.3
- [Signal] fix: No longer aggregates histogram signals after histogram_quantile() as it is pointless aggregation. Aggregation before applying histogram_quantile() is kept and works as expected.

# 0.4.2
- [Panels] Add table rows styles in requests panels.

# 0.4.1
- [Utils] Add optional separator='/' attribute to labelsToPanelLegend.
- 
# 0.4.0
- [Signal] Add defaultSignalSource param to set default signal source.

# 0.3.5
- [Variables] Add queriesSelectorGroupOnly, queriesSelectorFilterOnly attributes
- [Signal] Add %(queriesSelectorGroupOnly)s, %(queriesSequeriesSelectorFilterOnly)s templates
- [Signal] Fix legend rendering when aggLevel is none
- [Panel] Fix id conflict if topkPercentage panel is used with signal.asTarget()

# 0.3.4
- [Signal] Fix interval template for increase/delta functions.

# 0.3.3
- [Signal] Add `withQuantile(quantile=0.95)` to histogram signals.

# 0.3.2
- [Signal] Fix combining info metrics.

# 0.3.1
- [Signal] Fix optional signals (type=stub).
- [Signal] Add optional signals documentation.

# 0.3.0

- [Signal] Add new signal `log`.
- [Signal] Add enableLokiLogs=true|false to signals init.
- [Signal] `withExprWrappersMixin(offset)` - wrap signal expression into additional function on top of existing wrappers.

# 0.2.0

- [Signal] `withOffset(offset)` - add offset modifier to the expression.
- [Signal] `withFilteringSelectorMixin(mixin)` - add additional selector to filteringSelector used.

# 0.1.0

- [Variables] Add support for optional ad hoc variabels
- [Signal] Add support for info metrics in asTableColumn(format='table), now properly showing info metric as one more column
- [Signal] asTable() update: Order and rename Instance/Group labes as first columns in table
- [Signal] Add new attribute "nameShort". if defined this optional alias is used in legends and table column names.
- [Signal] Introduce new class of functions called "modifiers" and first member .withTopK(limit). They don't render signal immediately, instead, they modify the signal. Can be used in builder patterns before finally rendering final panel. Very useful when signals should be rendered a little bit different on different dashboards:
i..e
on fleet dashboard:
`signal.withTopK(25).asTimeSeries()`
on signle host dashboard:
`signal.asTimeSeries()`
- [Signals] fix: group aggregations are now properly applied to info type metrics as well.
