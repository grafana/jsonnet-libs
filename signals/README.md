# Signals Framework

A language-agnostic framework for defining, processing, and visualizing observability signals across multiple data sources and dashboard systems.

## Overview

The signals framework provides a standardized way to define observability metrics (signals) that can be processed into dashboard visualizations. It supports multiple data sources (Prometheus, Loki, OTEL) and can generate dashboards for various visualization systems.

## Language-Agnostic Interface Specifications

To ensure consistent implementation across all target languages, the framework provides formal interface specifications:

### 1. Method Interface Specification (`signal_methods.md`)

Defines the exact methods that must be implemented for the Signal class/object in every language:

- **Builder Methods**: `withTopK()`, `withExprWrappersMixin()`, `withOffset()`, etc.
- **Panel Rendering**: `asTimeSeries()`, `asStat()`, `asGauge()`, `asTable()`, etc.
- **Panel Composition**: `asPanelMixin()`, `asTarget()`, `asTableColumn()`, etc.
- **Expression Generation**: `asPanelExpression()`, `asRuleExpression()`
- **Utilities**: `getVariablesMultiChoice()`

### 2. OpenAPI Interface (`signal_interface.yaml`)

REST API specification that can be used to:
- Generate client stubs for each language
- Validate method signatures and data structures
- Ensure consistent input/output contracts

### 3. Core Schema (`signal.cue`, `signal_source.cue`)

CUE schema definitions that provide:
- Type-safe signal and signal group definitions
- Validation rules for all signal properties
- Data structure contracts for cross-language compatibility

## Implementation Strategy

### Language-Specific Implementation

Each target language must implement the Signal interface following these guidelines:

**Jsonnet** (Reference Implementation)
```jsonnet
local signals = signal.init(config);
signals.mySignal.withTopK(10).asTimeSeries()
```

**TypeScript** 
```typescript
const signal = new Signal(config);
signal.withTopK(10).asTimeSeries();
```

**Python**
```python
signal = Signal(config)
signal.with_top_k(10).as_time_series()
```

**Go**
```go
panel := signal.WithTopK(10).AsTimeSeries()
```

### Consistency Requirements

All implementations must:

1. **Method Signatures**: Match the interface specification exactly
2. **Expression Transformation**: Follow the same auto-transformation rules
3. **Template Expansion**: Support identical variable templates
4. **Panel Structure**: Generate compatible Grafana panel objects
5. **Testing**: Include comprehensive test suites

## Core Functions

The framework implements these core functions consistently across languages:

### 1. Signal Definition & Validation
```
Input: Signal configuration (JSON/YAML/Code)
Output: Validated Signal object with transformation rules
```

### 2. Expression Processing  
```
Input: Signal + context (datasource, aggregation level)
Output: PromQL/LogQL expressions with auto-transformations
```

### 3. Panel Generation
```
Input: Signal + panel type
Output: Complete Grafana panel configuration
```

### 4. Dashboard Assembly
```
Input: Signal collection + metadata
Output: Complete dashboard with panels and variables
```

## Expression Transformation Rules

All implementations follow these automatic transformations:

- **Counter**: `rate(metric[interval])` or similar range functions
- **Histogram**: `histogram_quantile(0.95, rate(metric[interval])) by (le)`  
- **Gauge/Info/Raw**: No transformation
- **Aggregation**: `sum by (labels) (expression)` when aggregation is enabled

## Supported Languages

- ✅ **Jsonnet** - Reference implementation (common-lib)
- 🔄 **TypeScript** - Web/Node.js environments  
- 🔄 **Python** - Data science and automation
- 🔄 **Go** - Performance-critical applications

## Schema Definitions

- **`signal.cue`** - Core signal and signal group schema with validation
- **`signal_source.cue`** - Data source-specific configuration schema
- **`signal_interface.yaml`** - OpenAPI specification for method contracts
- **`signal_methods.md`** - Detailed method interface documentation

## Getting Started

### 1. Define Signals
Create signal definitions using the CUE schema:
```jsonnet
{
  name: "CPU Usage",
  type: "gauge", 
  unit: "percent",
  sources: {
    prometheus: {
      expr: "100 - avg(rate(cpu_idle[5m])) * 100"
    }
  }
}
```

### 2. Validate Definitions
```bash
make test  # Validates against CUE schema
```

### 3. Implement Language Bindings
Use the interface specifications to implement Signal classes in your target language:

- Follow `signal_methods.md` for method signatures
- Use `signal_interface.yaml` for code generation
- Implement expression transformation rules
- Add comprehensive tests

### 4. Generate Dashboards
```typescript
const signal = new Signal(config);
const dashboard = new Dashboard()
  .addPanel(signal.asTimeSeries())
  .addVariables(Signal.getVariablesMultiChoice([signal]));
```

## File Structure

```
signals/
├── schema/
│   ├── signal.cue              # Core schema definitions
│   ├── signal_source.cue       # Source-specific schema  
│   ├── signal_interface.yaml   # OpenAPI method contracts
│   ├── signal_methods.md       # Method interface spec
│   └── tests/                  # Validation test files
├── gen/                        # Generated code output
├── architecture.md             # Architecture documentation
├── requirements.md             # Functional requirements
└── README.md                   # This file
```

## Development Workflow

1. **Schema First**: Define/modify schemas in CUE files
2. **Validate**: Ensure test files pass validation
3. **Interface**: Update method specifications if needed
4. **Implement**: Code language-specific implementations
5. **Test**: Verify cross-language compatibility
6. **Generate**: Use for dashboard/alert generation

This approach ensures that regardless of the implementation language, all Signal objects behave consistently and generate compatible dashboard outputs.