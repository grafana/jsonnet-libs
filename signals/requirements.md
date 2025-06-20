# Signals Framework Requirements

This document defines the functional and technical requirements for the signals observability framework.

## Goals

The signals framework aims to achieve the following high-level objectives:

### 1. **Unified Observability Interface**
- Provide a single, consistent abstraction layer for defining monitoring signals across different data sources and visualization systems

### 2. **Multi-Stack Compatibility**
- Support seamless migration between monitoring stacks (Prometheus ↔ OpenTelemetry ↔ Loki) without redefining signals
- Enable hybrid monitoring environments where different teams use different tools but share signal definitions

### 3. **Developer Experience Excellence**
- Offer intuitive, type-safe APIs in multiple programming languages (Jsonnet, TypeScript, Python, Go)
- Provide fluent, chainable interfaces that make common tasks simple and complex tasks possible
- Enable rapid prototyping and iteration on monitoring configurations with immediate feedback

### 4. **Configuration as Code**
- Support version-controlled, peer-reviewed monitoring configurations through code
- Enable automated testing and validation of monitoring setups before deployment
- Provide deterministic, reproducible monitoring infrastructure across environments

### 5. **Extensibility and Future-Proofing**
- Design plugin-friendly architecture that supports new data sources and visualization systems
- Enable custom signal types and transformations for specialized use cases
- Provide stable APIs that can evolve without breaking existing implementations

### 7. **Operational Efficiency**
- Reduce the time-to-value for new monitoring implementations from weeks to hours
- Minimize maintenance overhead through automated configuration generation
- Enable consistent monitoring practices across teams and projects within organizations

### 8. **Quality and Reliability**
- Ensure high confidence in monitoring configurations through comprehensive validation
- Provide consistent behavior across all supported languages and platforms
- Enable thorough testing of monitoring setups before production deployment

These goals drive all technical decisions and prioritization within the signals framework development.

## Functional Requirements

### 1. Multi-Source Signal Support
- **MUST** support multiple data sources per signal (Prometheus, OpenTelemetry, Loki, etc.)
- **MUST** allow same signal definition to work across different monitoring stacks
- **MUST** support source-specific query expressions and configurations
- **MUST** handle missing sources gracefully with optional signals

### 2. Signal Type Support
- **MUST** support counter signals with automatic rate/increase transformations
- **MUST** support gauge signals with pass-through expressions
- **MUST** support histogram signals with quantile calculations
- **MUST** support info signals for metadata extraction
- **MUST** support raw signals for custom expressions without transformation
- **MUST** support stub signals for missing optional sources

### 3. Expression Processing
- **MUST** support template variable expansion (%(queriesSelector)s, %(agg)s, etc.)
- **MUST** apply type-specific automatic transformations
- **MUST** support configurable aggregation levels (none, instance, group)
- **MUST** support configurable aggregation functions (avg, min, max, sum)
- **MUST** support expression wrappers for custom query modifications
- **MUST** support offset and topK query modifications

### 4. Visualization Support
- **MUST** generate Grafana TimeSeries, Stat, Gauge, Table, and StatusHistory panels
- **MUST** support panel composition with mixins and targets
- **MUST** generate dashboard variables for filtering
- **MUST** support custom legend templates and value mappings
- **MUST** handle units and display formatting automatically
- **MUST** support Grafana Scenes VizPanel generation for TypeScript implementation
- **MUST** integrate with Grafana Scenes PanelBuilders API for standard visualizations
- **MUST** support Grafana Scenes field configuration and overrides
- **MUST** support Grafana Scenes custom panel plugins and runtime registration

### 5. Alerting Support
- **MUST** generate Prometheus-compatible rule expressions
- **MUST** support alert-specific intervals (excluding Grafana variables)
- **MUST** maintain expression consistency between dashboards and alerts

## Technical Requirements

### 6. Programming Language Support
- **MUST** support Jsonnet implementation
- **MUST** support TypeScript implementation
- **MUST** support Python implementation
- **MUST** support Go implementation
- **MUST** maintain identical behavior across all language implementations

### 7. Schema Validation
- **MUST** use CUE schema for validation and type safety
- **MUST** validate signal definitions at compile time
- **MUST** provide clear error messages for schema violations
- **MUST** support schema evolution and backward compatibility

### 8. Method Organization
- **MUST** provide root signal methods for core modifications
- **MUST** provide Grafana namespace for dashboard-specific functionality
- **MUST** maintain clear separation between modification and output generation
- **MUST** support fluent chaining interface patterns

### 9. API Consistency
- **MUST** use identical method signatures across all languages
- **MUST** follow language-specific naming conventions (camelCase, snake_case, PascalCase)
- **MUST** return appropriate types for method chaining
- **MUST** maintain immutability in signal modifications

### 10. Template Variable Context
- **MUST** support different template variables for Grafana vs Prometheus contexts
- **MUST** include %(interval)s for Grafana dashboard generation
- **MUST** exclude %(interval)s from Prometheus rule generation
- **MUST** support all common variables: %(queriesSelector)s, %(agg)s, %(aggFunction)s

### 11. Grafana Scenes Integration (TypeScript)
- **MUST** generate VizPanel objects compatible with @grafana/scenes library
- **MUST** support PanelBuilders API for all standard Grafana visualizations
- **MUST** support SceneDataProvider integration for data binding
- **MUST** support field configuration with custom properties and overrides
- **MUST** support override matchers (name, regex, type, query, value, comparison)
- **MUST** support custom panel plugin registration with sceneUtils.registerRuntimePanelPlugin
- **MUST** support panel header actions and menu customization
- **MUST** support mixin functions for common visualization configurations
- **MUST** integrate with SceneQueryRunner for data source queries
- **MUST** support EmbeddedScene and SceneFlexLayout integration

## Quality Requirements

### 12. Testing Coverage
- **MUST** provide schema validation tests for all signal types
- **MUST** provide cross-language compatibility tests
- **MUST** provide expression transformation tests
- **MUST** provide template expansion tests
- **MUST** provide panel generation tests
- **MUST** provide namespace isolation tests

### 13. Documentation Standards
- **MUST** provide comprehensive API documentation for all languages
- **MUST** include working examples for all signal types
- **MUST** document template variable usage and context
- **MUST** provide migration guides for schema changes

### 14. Performance Requirements
- **MUST** generate expressions efficiently without excessive string manipulation
- **MUST** support lazy evaluation where possible
- **MUST** minimize memory allocation in method chaining
- **SHOULD** cache compiled expressions when appropriate

## Interface Requirements

### 15. Code Generation Support
- **MUST** support automated type generation from CUE schema
- **MUST** generate language-specific client stubs

### 16. Extension Points
- **MUST** support custom signal types through extension
- **MUST** support custom expression wrappers
- **MUST** support custom aggregation functions
- **SHOULD** support plugin architecture for new data sources

### 17. Configuration Management
- **MUST** support JSON/YAML configuration files
- **MUST** support environment-specific overrides
- **MUST** support signal grouping and organization
- **MUST** validate configuration against schema

## Compatibility Requirements

### 18. Dashboard System Agnostic
- **MUST** generate Grafana-compatible panel JSON
- **SHOULD** support extension to other dashboard systems
- **MUST** maintain clean separation between signal logic and visualization

### 19. Monitoring Stack Agnostic
- **MUST** support Prometheus metrics and PromQL
- **MUST** support OpenTelemetry metrics
- **MUST** support Loki logs and LogQL
- **SHOULD** support extension to other monitoring systems

### 20. Version Compatibility
- **MUST** maintain backward compatibility for schema changes
- **MUST** provide clear deprecation warnings
- **MUST** support gradual migration between versions
- **MUST** version API specifications

## Security Requirements

### 21. Input Validation
- **MUST** validate all user inputs against schema
- **MUST** sanitize expressions to prevent injection attacks
- **MUST** validate template variable expansion
- **MUST** provide safe defaults for all configurations

### 22. Access Control
- **SHOULD** support role-based access to signals
- **SHOULD** support data source access controls
- **SHOULD** audit signal configuration changes

## Future Requirements

### 23. Planned Features
- **SHOULD** support ad-hoc variable filters
- **SHOULD** support Loki logs integration
- **SHOULD** support additional dashboard systems
- **SHOULD** support real-time signal validation
- **SHOULD** support signal dependency tracking

These requirements ensure the signals framework provides a robust, scalable, and maintainable solution for observability across multiple programming languages and monitoring stacks.
