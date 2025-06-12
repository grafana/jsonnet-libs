package signal

// Metrics aggregation level - determines how metrics are grouped
// - "none": no aggregation, show individual metrics
// - "instance": aggregate by instance (single entity/service instance)  
// - "group": aggregate by group (job/service level)
#aggLevel: "none" | "instance" | "group"

// Aggregation function used when aggLevel is set to "instance" or "group"
// Applied as: <aggFunction> by (<agg>) (<expression>)
#aggFunction: "avg" | "min" | "max" | "sum"

// Signal type determines automatic transformations applied to expressions:
// - "counter": wrapped with rate/increase functions, e.g. rate(<expr>[<interval>])
// - "gauge": no transformation, used as-is
// - "histogram": wrapped with histogram_quantile function
// - "info": no transformation, typically used for metadata
// - "raw": no transformation, preserves complex custom expressions
// - "stub": internal type for optional signals when source is missing
#signalType: "counter" | "gauge" | "histogram" | "info" | "raw" | "stub"

// Individual signal definition within a signal group
#signal: close({
	// Signal name used for panel titles and descriptions
	name!: string
	
    // Short name used for panel legends and table columns by default
    nameShort?: string

    // Signal type - determines automatic query transformations
    type!: #signalType

	// Optional description used for panel descriptions and tooltips
	description?: string
	
	// Signal type - determines automatic query transformations
	type!: #signalType
	
	// Units for the signal (bytes, seconds, percent, etc.)
	unit?: string
	
	// Mark signal as optional - won't cause validation errors if missing
	// When true, missing signals render as empty panels instead of errors
	optional?: bool
	
	// Override aggregation level from signal group default
	aggLevel?: #aggLevel
	
	// Override aggregation function from signal group default  
	aggFunction?: #aggFunction
	
	// Custom legend template to override automatic legend generation
	// Supports Grafana templating like {{instance}}, {{job}}
	legendCustomTemplate?: string
	
	// Signal sources - one per data source type (prometheus, opentelemetry, etc.)
	// Key is the source name, value contains the expression and configuration
	sources: {[string]: #signalSource}
})

// Signal group configuration - contains multiple related signals
#signalGroup: close({
	// Prometheus datasource name (default: "datasource")
	datasource?: string
	
	// Human-readable datasource label (default: "Data source")
	datasourceLabel?: string
	
	// Future: filtering selector for scoping metrics
	// filteringSelector?: [...string]
	
	// Future: labels used to identify groups (jobs/services)
	// groupLabels?: [...string]
	
	// Future: labels used to identify instances  
	// instanceLabels?: [...string]
	
	// Default aggregation function for all signals in this group
	aggFunction?: #aggFunction
	
	// Default aggregation level for all signals in this group
	aggLevel?: #aggLevel
	
	// Metrics used for variable discovery in dashboards
	// Key is source type, value is metric name (e.g. {"prometheus": "up"})
	discoveryMetric: {[string]: string}
	
	// Default custom legend template for all signals in this group
	legendCustomTemplate?: string
	
	// Interval used for counter/histogram transformations in dashboards
	// Supports Grafana variables like $__rate_interval, $__interval
	interval?: string
	
	// Interval used for counter/histogram transformations in alerts
	// Must be static value (5m, 1h) - Grafana variables not supported
	alertsInterval?: string
	
	// Collection of signals in this group
	signals: {[string]: #signal}
	
	// Future: enable ad hoc variable filters
	// varAdHocEnabled?: bool
	
	// Future: limit ad hoc filters to specific labels
	// varAdHocLabels?: [...string]
	
	// Future: enable Loki logs integration
	// enableLokiLogs?: bool
})

// Root schema - array of signal groups
signalGroup: [...#signalGroup]
