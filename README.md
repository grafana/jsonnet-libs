# Grafana Labs Jsonnet Libraries: Programmable Observability at Scale

Modern infrastructure demands sophisticated observability solutions that can adapt, scale, and evolve with your systems. **Grafana Labs' Jsonnet Libraries** provide a comprehensive toolkit for building maintainable, reusable, and declarative monitoring configurations that eliminate the complexity of managing observability at scale.

This repository represents a paradigm shift from static configuration files to **programmable observability**—where monitoring infrastructure is defined as code using powerful abstractions, composable patterns, and battle-tested libraries that have been refined through years of production use at Grafana Labs and across the open-source community.

## Core Philosophy

At the heart of this toolkit lies a fundamental principle: **observability configurations should be as maintainable, testable, and reusable as application code**. By leveraging Jsonnet's functional programming capabilities and the builder pattern, these libraries enable teams to:

- **Eliminate Configuration Drift**: Declarative, version-controlled monitoring definitions that ensure consistency across environments
- **Accelerate Development**: Pre-built, idiomatic patterns that reduce time-to-monitoring from weeks to minutes
- **Scale Effortlessly**: Composable abstractions that grow with your infrastructure complexity
- **Maintain Quality**: Integrated linting, testing, and validation tools that prevent configuration errors before deployment

---

## 🏗️ Core Foundation Libraries

### **prometheus-ksonnet**
A comprehensive library of extensible configurations for deploying and managing **Prometheus** on Kubernetes. Built using the builder pattern, it provides declarative abstractions for complex Prometheus deployments while maintaining full customizability for advanced use cases.

**Key Benefits:**
- Idiomatic Kubernetes resource definitions with sensible defaults
- Extensible configuration patterns for multi-tenant environments
- Production-hardened settings derived from real-world deployments

### **grafana-builder**
The cornerstone library for programmatically constructing **Grafana dashboards** using Jsonnet. This library eliminates the boilerplate associated with dashboard creation while enforcing consistency and best practices across your visualization layer.

**Key Benefits:**
- Builder pattern implementation for composable dashboard construction
- Type-safe panel definitions that prevent common configuration errors
- Standardized layouts and styling that ensure visual consistency
- Extensible architecture supporting custom panel types and data sources

### **ksonnet-util**
A sophisticated overlay and utility collection designed to streamline **Kubernetes** resource management. This library provides higher-level abstractions that simplify complex Kubernetes patterns while maintaining the flexibility needed for advanced deployments.

**Key Benefits:**
- Simplified resource composition with intelligent defaults
- Advanced deployment patterns (rolling updates, canary deployments)
- Cross-cutting concerns (security policies, resource limits) applied consistently

### **oauth2-proxy**
A production-ready Jsonnet configuration for deploying **OAuth2 Proxy** on Kubernetes, providing authentication and authorization layers for your monitoring infrastructure with enterprise-grade security patterns.

---

## 📊 Monitoring Patterns: From Mixins to Modern Libraries

### **Monitoring Mixins**
Following the standardized format described at [monitoring.mixins.dev](https://monitoring.mixins.dev/), **monitoring mixins** provide complete, ready-to-deploy monitoring solutions for specific technologies. Each mixin encapsulates dashboards, alerts, and recording rules in a cohesive package that can be easily integrated into existing monitoring stacks.

**Featured Mixins:**
- **consul-mixin**: Comprehensive monitoring for HashiCorp Consul clusters
- **memcached-mixin**: Performance and reliability dashboards for Memcached deployments  
- **nodejs-mixin**: Application-level observability for Node.js services
- **caddy-mixin**: Web server monitoring with detailed request analytics
- **jira-mixin**: Service desk performance and availability monitoring

*Discover additional mixins in directories with the `-mixin` suffix.*

### **Observability Libraries: The Next Generation**
**Observability Libraries** represent an evolution beyond traditional mixins, offering a **modular, composable approach** to monitoring configuration. These libraries can be seamlessly imported into other libraries or mixins, enabling sophisticated dependency management and code reuse patterns.

Built on the foundation of the **[common-lib](common-lib/)**, these libraries ensure consistent styling, behavior, and architectural patterns across your entire observability stack.

#### **Signal Extension: Declarative Metrics Management**
The experimental **[Signal](common-lib/common/signal#signal)** extension introduces a revolutionary approach to metrics declaration. Define metrics (signals) once, then render them across multiple visualization types (time series, stat panels, tables) and alert rules—achieving true separation of concerns between data definition and presentation.

**Signal-Enabled Libraries:**
- **docker-mixin**: Container runtime observability with signal-based metrics
- **kafka-observ-lib**: Streaming platform monitoring with advanced signal patterns
- **jvm-observ-lib**: JVM performance monitoring across multiple runtime environments
- **snmp-observ-lib**: Network device monitoring with standardized SNMP signal definitions
- **process-observ-lib**: System-level process monitoring with signal abstraction
- **golang-observ-lib**: Go application observability with runtime-specific signals
- **windows-observ-lib**: Windows system monitoring with comprehensive signal coverage

*Find additional observability libraries in directories with the `-observ-lib` suffix.*

---

## 🛠️ Tooling & Quality Assurance

### **Configuration Linting: Ensuring Excellence**
Quality monitoring configurations require rigorous validation. This repository integrates industry-leading linting tools into every CI/CD pipeline:

- **[mixtool](https://github.com/monitoring-mixins/mixtool)**: Validates monitoring mixin structure, syntax, and compliance with standardized formats
- **[pint](https://github.com/cloudflare/pint)**: Advanced Prometheus rule linting that catches performance issues, syntax errors, and anti-patterns before deployment

### **Prometheus Rules Testing: Confidence Through Validation**
Complex PromQL queries and alert conditions demand comprehensive testing. The **[promtool test rules](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules)** integration provides:

- **Automated Test Execution**: Tests run in GitHub Actions and via `make test` commands
- **Standardized Test Structure**: Place test files in `tests/` directories named `prometheus_*.yaml`
- **Real-World Validation**: Test scenarios based on actual production alert conditions

**Example Implementation:** [windows-observ-lib prometheus tests](windows-observ-lib/tests/prometheus_alerts_test.yaml)

---

## 🤝 Contributing to the Future of Observability

This repository represents the collective expertise of the observability community. Whether you're contributing new libraries, enhancing existing patterns, or improving documentation, your contributions help advance the state of **observability as code**.

**Getting Started:**
1. Explore existing libraries to understand established patterns
2. Follow the testing and linting guidelines for quality assurance  
3. Consider the Signal extension for new observability libraries
4. Submit pull requests with comprehensive test coverage

---

## 📄 License

Licensed under the [Apache-2.0](LICENSE) license, ensuring open collaboration and enterprise adoption.

---

*Transform your monitoring from reactive maintenance to proactive engineering. Start building with Grafana Labs' Jsonnet Libraries today.*
