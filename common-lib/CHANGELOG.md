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
