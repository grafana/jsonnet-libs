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
