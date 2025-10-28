# Cloudflare Workers Mixin

The Cloudflare Workers mixin is a set of configurable Grafana dashboards for monitoring Cloudflare Workers using structured logs from Cloudflare Workers Observability.

The Cloudflare Workers mixin contains the following dashboard:

- Cloudflare Workers

## Cloudflare Workers Dashboard Overview
The Cloudflare Workers dashboard provides comprehensive observability into your serverless functions deployed on Cloudflare's edge network. 
It leverages the rich structured metadata from Cloudflare Workers logs to deliver insights across multiple dimensions:

### Key Metrics & Statistics
- Request Volume: Total requests, request rate (req/sec), and unique request tracking via Ray IDs
Log Severity: Breakdown of info, warning, and error logs with color-coded indicators
Geographic Distribution: Unique countries, colos (edge locations), and FaaS execution regions
- Client Insights: Browser types, device vendors, and unique client diversity metrics

### Request Analytics
- HTTP Methods: Distribution and trends of GET, POST, and other HTTP verbs
- URL Paths: Endpoint-level request analysis showing which routes receive traffic
- Network Protocols: HTTPS vs HTTP usage monitoring
- Request Triggers: FaaS trigger type analysis (http, scheduled, etc.)

### Geographic & Network Intelligence
- World Map: Interactive geomap showing request distribution by country
- Edge Location Analysis: Cloudflare colo distribution with heatmaps and charts
- Continental Distribution: Traffic breakdown by continent (AS, EU, NA, etc.)
- Timezone Analysis: Request patterns across different time zones
- ISP Tracking: Autonomous System Number (ASN) distribution for network analysis
- City & Region: State/province and city-level geographic breakdown

### Client & Browser Analytics
- Browser Distribution: Usage across Chrome, Firefox, Safari, Edge, etc.
- Browser Versions: Detailed version tracking for compatibility monitoring
- Rendering Engines: Blink, Gecko, WebKit distribution
- Operating Systems: macOS, Windows, Linux, mobile OS breakdown
- Device Vendors: Apple, Samsung, and other device manufacturer tracking
- Language Preferences: Accept-Language header analysis for internationalization insights
- Performance & Operations
- Log Volume Trends: Time series showing log patterns by severity level
- Request Rate Analysis: Temporal patterns by method, path, region, and colo
- Regional Performance: FaaS execution region distribution and rates
- Request Heatmaps: Time-based patterns across edge locations

## Tools
To use them, you need to have `mixtool` and `jsonnetfmt` installed. If you have a working Go development environment, it's easiest to run the following:

```bash
$ go get github.com/monitoring-mixins/mixtool/cmd/mixtool
$ go get github.com/google/go-jsonnet/cmd/jsonnetfmt
```

You can then build a directory `dashboard_out` with the JSON dashboard files for Grafana:

```bash
$ make build
```

For more advanced uses of mixins, see [Prometheus Monitoring Mixins docs](https://github.com/monitoring-mixins/docs).
