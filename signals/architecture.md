# Architecture: How signals work

This document provides a high-level overview of the signals pattern, its flow in the system, and the language-agnostic implementation architecture.

## Schema Components

The signals schema consists of three main components:

### 1. Signal Group (`#signalGroup`)
Top-level container that defines:
- **Datasource configuration**: `datasource`, `datasourceLabel`
- **Aggregation settings**: `aggFunction`, `aggLevel` 
- **Discovery**: `discoveryMetric` for service discovery
- **Templating**: `legendCustomTemplate` for consistent labeling
- **Timing**: `interval`, `alertsInterval` for data collection
- **Signal collection**: `signals` map containing individual signal definitions

### 2. Signal (`#signal`)
Individual metric definition that specifies:
- **Identity**: `name` (required), `nameShort` (for legends/columns), `type` (counter/gauge/histogram/info/raw/stub)
- **Metadata**: `unit`, `description`, `optional` flag
- **Aggregation**: `aggLevel`, `aggFunction` for metric rollup
- **Visualization**: `legendCustomTemplate` for display formatting
- **Sources**: `sources` map linking to different data sources

### 3. Signal Source (`#signalSource`)
Data source-specific metric query configuration:
- **Query**: `expr` (required PromQL/LogQL expression)
- **Processing**: `exprWrappers` for query transformation
- **Functions**: `rangeFunction` (rate/irate/delta/etc), `aggFunction`
- **Filtering**: `aggKeepLabels` to preserve specific labels
- **Display**: `infoLabel`, `legendCustomTemplate` for visualization
- **Mapping**: `valueMappings` for value transformation
- **Quantiles**: `quantile` for histogram metrics (0-1 range)

## Language-Agnostic Implementation Architecture

The signals framework is designed for consistent implementation across multiple programming languages:

### Interface Specifications Layer

```
┌─────────────────────────────────────────────────────────┐
│                Interface Specifications                 │
├─────────────────────┬─────────────────────┬─────────────┤
│    CUE Schema       │                     │   Methods   │
│                     │                     │    Spec     │
└─────────────────────┴─────────────────────┴─────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────┐
│              Language Implementations                   │
├──────────────┬──────────────┬──────────────┬───-────────┤
│   Jsonnet    │  TypeScript  │    Python    │      Go    │
│Implementation│Implementation│Implementation│Implementa. │
└──────────────┴──────────────┴──────────────┴───────────-┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────┐
│                  Generated Outputs                      │
├─────────────────────-─────────────────────┬─────────────┤
│   Grafana Panels/Parts of panels          | Prometheus  │
│                                           │    Rules    │
└─────────────────────-─────────────────────┴─────────────┘
```

### Core Method Organization

Each language implementation organizes methods into two categories:

#### 1. **Root Signal Methods** - Core signal modifications and Prometheus output
- **Builder Methods**: `withTopK()`, `withOffset()`, `withQuantile()`, `withExprWrappersMixin()`, `withFilteringSelectorMixin()`
- **Rule Generation**: `asRuleExpression()`

#### 2. **Grafana Methods** (`.grafana` namespace) - Dashboard and panel generation
- **Panel Rendering**: `asTimeSeries()`, `asStat()`, `asGauge()`, `asTable()`, `asStatusHistory()`
- **Panel Composition**: `asPanelMixin()`, `asTarget()`, `asTableColumn()`, `asOverride()`
- **Expression Generation**: `asPanelExpression()`
- **Utility Functions**: `getVariablesMultiChoice()`

## Data Processing Flow

```
┌─────────────────┐    ┌─────────────────────┐    ┌──────────────────┐
│ Schema Definition│    │Language Implementation│    │Expression Transform│
│                 │    │                     │    │                  │
│ ┌─────────────┐ │    │ ┌─────────────────┐ │    │ ┌──────────────┐ │
│ │signalGroup  │─┼────┼▶│Signal Class/Obj │─┼────┼▶│Counter       │ │
│ └─────────────┘ │    │ └─────────────────┘ │    │ │Transform     │ │
│ ┌─────────────┐ │    │ ┌─────────────────┐ │    │ └──────────────┘ │
│ │signal       │─┼────┼▶│Expression       │ │    │ ┌──────────────┐ │
│ └─────────────┘ │    │ │Processor        │ │    │ │Histogram     │ │
│ ┌─────────────┐ │    │ └─────────────────┘ │    │ │Transform     │ │
│ │signalSource │─┼────┼▶│Panel Generator  │ │    │ └──────────────┘ │
│ └─────────────┘ │    │                     │    │ ┌──────────────┐ │
└─────────────────┘    └─────────────────────┘    │ │Aggregation   │ │
                                                  │ │Engine        │ │
                                                  │ └──────────────┘ │
                                                  │ ┌──────────────┐ │
                                                  │ │Template      │ │
                                                  │ │Expander      │ │
                                                  │ └──────────────┘ │
                                                  └──────────────────┘
                                                           │
                                                           ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        Output Generation                            │
├─────────────────────┬─────────────────────┬─────────────────────────┤
│    Panel Objects    │ Dashboard Variables │   Prometheus Rules      │
│                     │                     │                         │
│ • TimeSeries        │ • Multi-choice vars │ • Rule expressions      │
│ • Stat panels       │ • Instance filters  │ • Alert conditions      │
│ • Gauge panels      │ • Group filters     │ • Recording rules       │
│ • Table panels      │                     │                         │
└─────────────────────┴─────────────────────┴─────────────────────────┘
```

## Expression Transformation Pipeline

### 1. Base Expression Processing
```
Input: signal.sources[datasource].expr
Apply: Template variable expansion (%(queriesSelector)s, %(agg)s, etc.)
Output: Expanded base expression
```

### 2. Type-Specific Transformation
```
Counter:    <rangeFunction>(base_expr[<interval>])
Histogram:  histogram_quantile(<quantile>, <aggFunction>(rate(base_expr[<interval>])) by (le,<agg>))
Gauge:      base_expr (no transformation)
Info:       base_expr (no transformation)
Raw:        base_expr (no transformation)
Stub:       "" (empty expression for missing optional signals)
```

### 3. Aggregation Application
```
When aggLevel != "none":
  <aggFunction> by (<aggLabels> + <aggKeepLabels>) (<transformed_expr>)
```

### 4. Expression Wrappers
```
Apply exprWrappers: [["topk(10,", ")"]] → topk(10, <final_expr>)
Apply withTopK(): signal.withTopK(5) → topk(5, <final_expr>)
Apply withOffset(): signal.withOffset("5m") → <final_expr> offset 5m
```

## Multi-Language Consistency

### Implementation Pattern

All languages follow the same pattern for method organization:

```typescript
// Root signal methods (core modifications)
const modifiedSignal = signal
  .withTopK(10)
  .withOffset("5m")
  .withQuantile(0.95);

// Prometheus rule generation
const rule = modifiedSignal.asRuleExpression();

// Grafana panel generation
const panel = modifiedSignal.grafana.asTimeSeries();
const target = modifiedSignal.grafana.asTarget();
const mixin = modifiedSignal.grafana.asPanelMixin();
```

### Code Generation Strategy

```
┌─────────────────┐    ┌─────────────────────┐    ┌──────────────────┐
│   CUE Schema    │───▶│  Type Generation    │───▶│ Language Types   │
└─────────────────┘    └─────────────────────┘    └──────────────────┘
                                                   │                  │
┌─────────────────┐    ┌─────────────────────┐    │ • TypeScript     │
│  OpenAPI Spec   │───▶│ Client Generation   │───▶│ • Python         │
└─────────────────┘    └─────────────────────┘    │ • Go             │
                                                   │                  │
┌─────────────────┐    ┌─────────────────────┐    │ Client Stubs     │
│Method Interface │───▶│Implementation Guide │───▶│                  │
└─────────────────┘    └─────────────────────┘    └──────────────────┘
```

### Template Variable Support

Both root signal methods and Grafana methods support template expansion:

#### Grafana Methods (`.grafana` namespace)
Support all template variables including Grafana-specific ones:
- `%(queriesSelector)s` - Complete selector with filtering + instance + group labels
- `%(filteringSelector)s` - Filtering selector only
- `%(groupLabels)s`, `%(instanceLabels)s` - Label lists
- `%(agg)s`, `%(aggLegend)s` - Aggregation labels
- `%(aggFunction)s` - Aggregation function
- `%(interval)s` - Dashboard interval (Grafana-specific)
- `%(alertsInterval)s` - Alerts interval

#### Root Signal Methods (Prometheus-related)
Support all template variables except Grafana-specific ones:
- All variables above except `%(interval)s`
- Use `%(alertsInterval)s` instead for Prometheus rules

## Validation & Testing Strategy

Each language implementation must pass:

1. **Schema Validation Tests** - CUE schema compliance for all signal definitions
2. **Method Signature Tests** - Interface specification compliance across languages
3. **Expression Transformation Tests** - Consistent output for all signal types
4. **Template Expansion Tests** - Correct variable substitution in both contexts
5. **Panel Generation Tests** - Compatible Grafana panel structures
6. **Cross-Language Compatibility Tests** - Same inputs produce same outputs
7. **Namespace Isolation Tests** - Root methods don't affect Grafana methods

## Key Architecture Principles

### 1. **Method Organization**
- **Root Signal**: Core signal modifications and Prometheus output
- **Grafana Namespace**: Panel generation and dashboard-specific functionality
- **Clear Separation**: Logical grouping of functionality by target system

### 2. **Builder Pattern**
- **Fluent Interface**: Chain modifications with immutable signal objects
- **Type Safety**: Each method returns appropriate types for further chaining
- **Flexibility**: Mix root modifications with Grafana output generation

### 3. **Multi-Source Support**
- **Source Mapping**: Same signal can have different implementations per data source
- **Template Consistency**: Same templating system across all sources
- **Fallback Handling**: Optional signals gracefully handle missing sources

### 4. **Expression Processing**
- **Type-Driven Transformations**: Automatic query generation based on signal type
- **Layered Processing**: Base → Type → Aggregation → Wrappers
- **Template Expansion**: Context-aware variable substitution

### 5. **Language Agnostic Design**
- **Interface Contracts**: Formal specifications ensure compatibility
- **Code Generation**: Automated type and stub generation from schemas
- **Consistent Behavior**: Identical outputs across all language implementations

## Data Flow Summary

```
Schema Definition (CUE) 
    ↓
Language Implementation (Jsonnet/TS/Python/Go)
    ↓
Signal Object Creation
    ↓
Root Method Application (.withTopK(), .withOffset())
    ↓
Expression Transformation Pipeline
    ↓
Output Generation:
    ├── Prometheus Rules (.asRuleExpression())
    └── Grafana Panels (.grafana.asTimeSeries())
```

This architecture ensures consistent behavior across all programming languages while providing flexibility for different output formats and use cases.
