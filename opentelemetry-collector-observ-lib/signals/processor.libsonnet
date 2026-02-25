local common = import './common.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

local emptyProcessorQuery = |||
  or
  (
    count by (service_name,processor) ({%(queriesSelector)sprocessor!=""}) * 0
  )
|||;

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'sum',
    signals:
      {
        count: {
          name: 'Processor count',
          description: 'Total number of processors',
          type: 'raw',
          unit: 'short',
          sources: {
            otelcol: {
              legendCustomTemplate: 'Processors',
              expr: |||
                count(count by (processor) ({%(queriesSelector)s,__name__=~"otelcol_processor_(incoming|outgoing)_items_total"}))
              |||,
            },
          },
        },
        outgoingByProcessor: {
          name: 'Outgoing items',
          description: 'Rate of outgoing items',
          type: 'counter',
          unit: 'cps',
          sources: {
            otelcol: {
              aggKeepLabels: ['processor', 'otel_signal'],
              expr: 'otelcol_processor_outgoing_items_total{%(queriesSelector)s}',
            },
          },
        },
      }
      + std.foldl(
        function(acc, signal) acc {
          [signal.plural]: {
            name: signal.capitalized,
            description: 'Total rate of %(plural)s entering processors' % signal,
            type: 'counter',
            unit: 'cps',
            sources: {
              otelcol: {
                legendCustomTemplate: signal.capitalized,
                expr: |||
                  otelcol_processor_incoming_items_total{otel_signal="%(otel_signal)s",%%(queriesSelector)s}
                ||| % signal,
              },
            },
          },
        },
        common.signalTypes,
        {}
      )
      + std.foldl(
        function(acc, opts)
          local signal = opts.signal;
          local direction = opts.direction;
          local capitalizedSignal = std.asciiUpper(signal[0]) + std.substr(signal, 1, std.length(signal));
          local capitalizedDirection = std.asciiUpper(direction[0]) + std.substr(direction, 1, std.length(direction));
          acc {
            ['%(direction)s%(signal)sByProcessor' % { signal: capitalizedSignal, direction: direction }]: {
              name: '%s %s' % [capitalizedDirection, signal],
              description: 'Rate of %s %s' % [direction, signal],
              type: 'counter',
              unit: 'cps',
              sources: {
                otelcol: {
                  legendCustomTemplate: '{{processor}}',
                  aggKeepLabels: ['processor'],
                  exprWrappers: [['', 'or (count by (service_name,processor) ({processor!="",%(queriesSelector)s})*0)']],
                  expr: 'otelcol_processor_' + direction + '_items_total{otel_signal="' + signal + '",%(queriesSelector)s}',
                },
              },
            },
          }, [
          { direction: d, signal: s }
          for s in [
            'metrics',
            'logs',
            'traces',
          ]
          for d in ['incoming', 'outgoing']
        ], {}
      ),
  }
