# Signal Methods Interface Specification

This document defines the exact methods that must be implemented for the Signal class/object in every target language (Jsonnet, TypeScript, Python, Go).

The methods are organized by their target system:
- **Root Signal Methods** - Core signal modifications and Prometheus rule generation
- **Grafana Methods** - Dashboard and panel generation (`.grafana` namespace)

## Signal Object Properties

```
Signal {
  name: string                    // Signal name for panel titles
  nameShort: string              // Short name for legends  
  type: enum                     // counter|gauge|histogram|info|raw|stub
  unit: string                   // Units (bytes, seconds, etc.)
  description: string            // Panel description
  optional: boolean              // Whether signal is optional
  aggLevel: enum                 // none|instance|group
  aggFunction: enum              // avg|min|max|sum
  sourceMaps: SignalSource[]     // Array of source configurations
}

SignalSource {
  expr: string                   // Base PromQL/LogQL expression
  exprWrappers: string[][]       // [["left", "right"]] wrapper pairs
  rangeFunction: enum            // rate|irate|delta|idelta|increase
  aggKeepLabels: string[]        // Labels to keep during aggregation
  infoLabel: string              // Label for info type metrics
  valueMappings: object[]        // Grafana value mappings
  legendCustomTemplate: string   // Custom legend template
  quantile: number               // 0.0-1.0 for histogram metrics
}
```

## Root Signal Methods

### Query Modification Methods

These methods modify the signal and return a new modified signal object (fluent interface):

| Method | Signature | Description |
|--------|-----------|-------------|
| `withTopK` | `signal.withTopK(limit: number = 25) -> Signal` | Wrap expression with topk() |
| `withExprWrappersMixin` | `signal.withExprWrappersMixin(wrapper: string[]) -> Signal` | Add expression wrapper |
| `withOffset` | `signal.withOffset(offset: string) -> Signal` | Add offset to expression |
| `withFilteringSelectorMixin` | `signal.withFilteringSelectorMixin(mixin: string) -> Signal` | Add filtering selector |
| `withQuantile` | `signal.withQuantile(quantile: number = 0.95) -> Signal` | Set quantile for histograms |

### Rule Generation Methods

These methods return Prometheus-specific expressions:

| Method | Signature | Description |
|--------|-----------|-------------|
| `asRuleExpression` | `signal.asRuleExpression() -> string` | Prometheus rule expression (no Grafana vars) |

## Grafana Methods (.grafana namespace)

### Panel Rendering Methods

These methods return complete Grafana panel objects:

| Method | Signature | Description |
|--------|-----------|-------------|
| `asTimeSeries` | `signal.grafana.asTimeSeries() -> Panel` | Render as Grafana TimeSeries panel |
| `asStat` | `signal.grafana.asStat() -> Panel` | Render as Grafana Stat panel |
| `asGauge` | `signal.grafana.asGauge() -> Panel` | Render as Grafana Gauge panel |
| `asStatusHistory` | `signal.grafana.asStatusHistory() -> Panel` | Render as Grafana StatusHistory panel |
| `asTable` | `signal.grafana.asTable(format: string = "table") -> Panel` | Render as Grafana Table panel |

### Panel Composition Methods

These methods return objects that can be mixed into existing Grafana panels:

| Method | Signature | Description |
|--------|-----------|-------------|
| `asPanelMixin` | `signal.grafana.asPanelMixin() -> {targets: Target[], overrides: Override[]}` | Panel mixin with targets and overrides |
| `asTableColumn` | `signal.grafana.asTableColumn(format: string = "table") -> {targets: Target[], overrides: Override[]}` | Table column mixin |
| `asTarget` | `signal.grafana.asTarget() -> Target` | Query target object |
| `asTableTarget` | `signal.grafana.asTableTarget() -> Target` | Table-formatted target |
| `asOverride` | `signal.grafana.asOverride() -> Override` | Panel field override |

### Expression Methods

These methods return Grafana-specific expressions:

| Method | Signature | Description |
|--------|-----------|-------------|
| `asPanelExpression` | `signal.grafana.asPanelExpression() -> string` | Panel query expression (with Grafana variables) |

### Utility Methods

Static/class methods for working with collections of signals in Grafana:

| Method | Signature | Description |
|--------|-----------|-------------|
| `getVariablesMultiChoice` | `Signal.grafana.getVariablesMultiChoice(signals: Signal[]) -> Variable[]` | Generate Grafana dashboard variables |

## Expression Transformation Rules

All implementations must follow these automatic expression transformation rules:

1. **Counter signals**: Wrap with `<rangeFunction>(<expr>[<interval>])`
2. **Histogram signals**: Wrap with `histogram_quantile(<quantile>, <aggFunction>(rate(<expr>[<interval>])) by (le,<agg>))`
3. **Gauge/Info/Raw signals**: No automatic transformation
4. **Aggregation**: When `aggLevel` is `group` or `instance`, wrap with `<aggFunction> by (<agg>) (<expr>)`

## Variable Template Expansion

Support these template variables in expressions:

- `%(queriesSelector)s` - filteringSelector + instanceLabels + groupLabels matchers
- `%(filteringSelector)s` - filteringSelector matchers only  
- `%(groupLabels)s` - groupLabels list
- `%(instanceLabels)s` - instanceLabels list
- `%(agg)s` - aggregation labels based on aggLevel + aggKeepLabels
- `%(aggLegend)s` - aggregation labels in legend format `{{label}}`
- `%(aggFunction)s` - aggregation function name
- `%(interval)s` - interval value
- `%(alertsInterval)s` - alerts interval value


## Builder Pattern Flow

The approach enables clear separation and fluent chaining:

```typescript
// Example workflow
const baseSignal = new Signal(config);

// Build modifications on root signal - returns new Signal for chaining
const modifiedSignal = baseSignal
  .withTopK(10)
  .withOffset("5m")
  .withQuantile(0.99);

// Generate outputs for different systems
const prometheusRule = modifiedSignal.asRuleExpression();
const grafanaPanel = modifiedSignal.grafana.asTimeSeries();
const grafanaTarget = modifiedSignal.grafana.asTarget();

// Original signal unmodified for different use
const basicPanel = baseSignal.grafana.asStat();

// Single-line builder pattern examples
const quickPanel = baseSignal.withTopK(10).withOffset("5m").grafana.asTimeSeries();
const compositePanel = baseSignal.withQuantile(0.95).withFilteringSelectorMixin('env="prod"').grafana.asStat();
```

## Testing Requirements

Each language implementation must include:

1. **Unit tests** for all methods in each namespace
2. **Integration tests** with sample signal configurations
3. **Expression transformation tests** for all signal types
4. **Template expansion tests** for both Grafana and Prometheus contexts
5. **Panel generation tests** comparing Grafana output structure
6. **Rule generation tests** comparing Prometheus output structure
7. **Namespace isolation tests** ensuring modifications don't affect other namespaces

## Code Generation

For consistent implementation across languages:

1. Use the OpenAPI spec (`signal_interface.yaml`) to generate client stubs
2. Implement the actual logic following the transformation rules above
3. Ensure method signatures match exactly across all languages
4. Use consistent naming conventions (camelCase, snake_case, PascalCase per language standards)
5. Organize methods with core signal modifications on root object and Grafana methods in `.grafana` namespace
6. Ensure isolation - modifications create new signal instances and don't affect the original signal

## Implementation Requirements by Language

### Jsonnet
```jsonnet
// Constructor
local signals = signal.init(config);
signals.addSignal(name, type, ...)

// Root signal methods (formerly prom namespace)
local signalMethods = {
  withTopK(limit=25):: { /* Returns new signal with modified config */ },
  withOffset(offset):: { /* Returns new signal with modified config */ },
  withQuantile(quantile=0.95):: { /* Returns new signal with modified config */ },
  withExprWrappersMixin(wrapper):: { /* Returns new signal with modified config */ },
  withFilteringSelectorMixin(mixin):: { /* Returns new signal with modified config */ },
  
  // Prometheus-specific output
  asRuleExpression():: { /* Returns rule expression string */ },
};

// Grafana namespace methods (unchanged)
local grafanaNamespace = {
  asTimeSeries():: { /* Returns panel object */ },
  asStat():: { /* Returns panel object */ },
  asGauge():: { /* Returns panel object */ },
  asTable(format='table'):: { /* Returns panel object */ },
  asPanelMixin():: { /* Returns mixin object */ },
  asTarget():: { /* Returns target object */ },
  asPanelExpression():: { /* Returns expression string */ },
};

// Usage with fluent chaining
local modifiedSignal = signals.mySignal.withTopK(10).withOffset("5m");

// Use modified signal for Prometheus rules
local rule = modifiedSignal.asRuleExpression();

// Use modified signal for Grafana panels
local panel = modifiedSignal.grafana.asTimeSeries();

// Or use original signal directly
local originalPanel = signals.mySignal.grafana.asTimeSeries();

// Builder pattern: Chain modifications with grafana rendering
local quickPanel = signals.mySignal.withTopK(10).withOffset("5m").grafana.asTimeSeries();
local statPanel = signals.cpuSignal.withQuantile(0.99).grafana.asStat();
local mixedPanel = signals.memorySignal.withExprWrappersMixin(['sum(', ')']).grafana.asPanelMixin();
local tablePanel = signals.diskSignal.withFilteringSelectorMixin('env="prod"').grafana.asTable();
```

### TypeScript
```typescript
// Class-based approach with Grafana namespace
class Signal {
  constructor(config: SignalConfig) { 
    this.config = config;
    this.grafana = new GrafanaNamespace(this);
  }
  
  // Root methods (formerly prom namespace)
  withTopK(limit = 25): Signal { 
    return new Signal({...this.config, topK: limit});
  }
  
  withOffset(offset: string): Signal { 
    return new Signal({...this.config, offset});
  }
  
  withQuantile(quantile = 0.95): Signal {
    return new Signal({...this.config, quantile});
  }
  
  withExprWrappersMixin(wrapper: string[]): Signal {
    return new Signal({...this.config, exprWrappers: [...(this.config.exprWrappers || []), wrapper]});
  }
  
  withFilteringSelectorMixin(mixin: string): Signal {
    return new Signal({...this.config, filteringSelector: mixin});
  }
  
  asRuleExpression(): string { 
    // Return Prometheus rule expression 
    return ""; 
  }
  
  // Grafana namespace
  public grafana: GrafanaNamespace;
  private config: SignalConfig;
}

class GrafanaNamespace {
  constructor(private signal: Signal) {}
  
  asTimeSeries(): Panel { ... }
  asPanelMixin(): {targets: Target[], overrides: Override[]} { ... }
  asTarget(): Target { ... }
  asPanelExpression(): string { ... }
  
  static getVariablesMultiChoice(signals: Signal[]): Variable[] { ... }
}

// Usage with fluent chaining on root signal
const signal = new Signal(config);
const modifiedSignal = signal.withTopK(10).withOffset("5m");

// Use modified signal for Prometheus rules
const rule = modifiedSignal.asRuleExpression();

// Use modified signal for Grafana panels
const panel = modifiedSignal.grafana.asTimeSeries();

// Or use original signal directly
const originalPanel = signal.grafana.asTimeSeries();

// Builder pattern: Chain modifications with grafana rendering
const quickPanel = signal.withTopK(10).withOffset("5m").grafana.asTimeSeries();
const statPanel = cpuSignal.withQuantile(0.99).grafana.asStat();
const targetPanel = memorySignal.withExprWrappersMixin(['avg(', ')']).grafana.asTarget();
const compositePanel = basePanel.withFilteringSelectorMixin('env="prod"').grafana.asPanelMixin();
const tablePanel = diskSignal.withTopK(5).withOffset("1h").grafana.asTable("time_series");
```

### Python
```python
# Class-based approach with Grafana namespace
class Signal:
    def __init__(self, config: SignalConfig):
        self.config = config
        self.grafana = GrafanaNamespace(self)
    
    # Root methods (formerly prom namespace)
    def with_top_k(self, limit: int = 25) -> 'Signal':
        new_config = {**self.config, 'top_k': limit}
        return Signal(new_config)
    
    def with_offset(self, offset: str) -> 'Signal':
        new_config = {**self.config, 'offset': offset}
        return Signal(new_config)
    
    def with_quantile(self, quantile: float = 0.95) -> 'Signal':
        new_config = {**self.config, 'quantile': quantile}
        return Signal(new_config)
    
    def with_expr_wrappers_mixin(self, wrapper: list[str]) -> 'Signal':
        existing_wrappers = self.config.get('expr_wrappers', [])
        new_config = {**self.config, 'expr_wrappers': existing_wrappers + [wrapper]}
        return Signal(new_config)
    
    def with_filtering_selector_mixin(self, mixin: str) -> 'Signal':
        new_config = {**self.config, 'filtering_selector': mixin}
        return Signal(new_config)
    
    def as_rule_expression(self) -> str:
        # Return Prometheus rule expression
        return ""

class GrafanaNamespace:
    def __init__(self, signal: 'Signal'):
        self._signal = signal
    
    def as_time_series(self) -> Panel: ...
    def as_panel_mixin(self) -> dict: ...
    def as_target(self) -> Target: ...
    def as_panel_expression(self) -> str: ...
    
    @staticmethod
    def get_variables_multi_choice(signals: list['Signal']) -> list[Variable]: ...

# Usage with fluent chaining on root signal
signal = Signal(config)
modified_signal = signal.with_top_k(10).with_offset("5m")

# Use modified signal for Prometheus rules
rule = modified_signal.as_rule_expression()

# Use modified signal for Grafana panels
panel = modified_signal.grafana.as_time_series()

# Or use original signal directly
original_panel = signal.grafana.as_time_series()

# Builder pattern: Chain modifications with grafana rendering
quick_panel = signal.with_top_k(10).with_offset("5m").grafana.as_time_series()
stat_panel = cpu_signal.with_quantile(0.99).grafana.as_stat()
target_panel = memory_signal.with_expr_wrappers_mixin(['sum(', ')']).grafana.as_target()
gauge_panel = disk_signal.with_filtering_selector_mixin('instance="server1"').grafana.as_gauge()
table_panel = network_signal.with_top_k(5).with_offset("1h").grafana.as_table("time_series")
```

### Go
```go
// Struct with Grafana namespace
type Signal struct {
    Config SignalConfig
    Grafana *GrafanaNamespace
}

func NewSignal(config SignalConfig) *Signal {
    s := &Signal{Config: config}
    s.Grafana = &GrafanaNamespace{signal: s}
    return s
}

// Root methods (formerly prom namespace)
func (s *Signal) WithTopK(limit int) *Signal {
    newConfig := s.Config
    newConfig.TopK = limit
    return NewSignal(newConfig)
}

func (s *Signal) WithOffset(offset string) *Signal { 
    newConfig := s.Config
    newConfig.Offset = offset
    return NewSignal(newConfig)
}

func (s *Signal) WithQuantile(quantile float64) *Signal {
    newConfig := s.Config
    newConfig.Quantile = quantile
    return NewSignal(newConfig)
}

func (s *Signal) WithExprWrappersMixin(wrapper []string) *Signal {
    newConfig := s.Config
    newConfig.ExprWrappers = append(newConfig.ExprWrappers, wrapper)
    return NewSignal(newConfig)
}

func (s *Signal) WithFilteringSelectorMixin(mixin string) *Signal {
    newConfig := s.Config
    newConfig.FilteringSelector = mixin
    return NewSignal(newConfig)
}

func (s *Signal) AsRuleExpression() string { 
    // Return Prometheus rule expression
    return ""
}

type GrafanaNamespace struct {
    signal *Signal
}

func (g *GrafanaNamespace) AsTimeSeries() *Panel { ... }
func (g *GrafanaNamespace) AsPanelMixin() *PanelMixin { ... }
func (g *GrafanaNamespace) AsTarget() *Target { ... }
func (g *GrafanaNamespace) AsPanelExpression() string { ... }

func GetVariablesMultiChoice(signals []*Signal) []*Variable { ... }

// Usage with fluent chaining on root signal
signal := NewSignal(config)
modifiedSignal := signal.WithTopK(10).WithOffset("5m")

// Use modified signal for Prometheus rules
rule := modifiedSignal.AsRuleExpression()

// Use modified signal for Grafana panels
panel := modifiedSignal.Grafana.AsTimeSeries()

// Or use original signal directly
originalPanel := signal.Grafana.AsTimeSeries()

// Builder pattern: Chain modifications with grafana rendering
quickPanel := signal.WithTopK(10).WithOffset("5m").Grafana.AsTimeSeries()
statPanel := cpuSignal.WithQuantile(0.99).Grafana.AsStat()
targetPanel := memorySignal.WithExprWrappersMixin([]string{"sum(", ")"}).Grafana.AsTarget()
gaugePanel := diskSignal.WithFilteringSelectorMixin(`instance="server1"`).Grafana.AsGauge()
tablePanel := networkSignal.WithTopK(5).WithOffset("1h").Grafana.AsTable("time_series")
``` 