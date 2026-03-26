{
  signalTypes: std.map(
    function(s)
      s {
        capitalized: std.asciiUpper(s.plural)[0] + std.substr(s.plural, 1, std.length(s.plural)),
      },
    [
      { plural: 'metrics', metric_id: 'metric_points', otel_signal: 'metrics' },
      { plural: 'logs', metric_id: 'log_records', otel_signal: 'logs' },
      { plural: 'spans', metric_id: 'spans', otel_signal: 'traces' },
    ]
  ),
  forAllTelemetryTypes(f): std.foldl(function(acc, t) acc + f(t), self.signalTypes, {}),
}
