# Anthropic Mixin

A Grafana dashboard mixin for monitoring Anthropic API usage and observability.

## Features

This mixin provides comprehensive monitoring for Anthropic API usage including:

- **Cost Monitoring**: Real-time cost tracking with configurable thresholds
- **Token Usage**: Input/output token consumption analysis  
- **Workspace Analytics**: Multi-workspace usage patterns
- **Model Distribution**: Usage breakdown by different Claude models
- **Service Tier Utilization**: Analysis of API tier usage patterns
- **Performance Metrics**: Token processing rates and latency

## Dashboard Panels

### Summary Statistics
- Total token cost with threshold-based color coding
- Total tokens processed counter
- Active workspaces count

### Cost Analysis
- Daily cost breakdown by workspace (bar chart)
- Cost trends over time by workspace (time series)
- Service tier utilization (pie chart)

### Token Analytics  
- Input vs output token consumption (stacked time series)
- Token processing rate by model (time series)
- Model usage distribution (bar gauge)

## Metrics Requirements

This dashboard expects the following Prometheus metrics to be available:

- `gen_ai_cost` - Cost metrics with labels:
  - `job`
  - `gen_ai_anthropic_workspace_id`
  
- `gen_ai_usage_tokens_total` - Token usage metrics with labels:
  - `job`
  - `gen_ai_anthropic_workspace_id` 
  - `gen_ai_response_model`
  - `gen_ai_token_type` (input/output)
  - `gen_ai_anthropic_service_tier`

## Variables

The dashboard includes the following template variables:

- **prometheus**: Prometheus datasource selector
- **job**: Job filter (multi-select)
- **workspace**: Workspace ID filter (multi-select)  
- **model**: Model filter (multi-select)

## Usage

Import this mixin in your jsonnet configuration:

```jsonnet
local anthropicMixin = import 'anthropic-mixin/mixin.libsonnet';

anthropicMixin.grafanaDashboards
```

## Configuration

The dashboard is configured with:
- 30-second refresh rate
- 3-hour default time range
- Grafana templating for dynamic filtering
- Cost thresholds: Green (0-$1000), Yellow ($1000-$5000), Red (>$5000)
- Token thresholds: Green (0-100k), Yellow (100k-1M), Red (>1M)
