// Concrete values used throughout dashboards.
package dashboards

_datasource:       "prometheus"

_instanceMatcher:  "instance=~\"$instance\""
_jobMatcher:       "job=~\"$job\""
_frontendMatcher:  "proxy=~\"$frontend\""
_backendMatcher:   "proxy=~\"$backend\""
_serverMatcher:    "server=~\"$server\""
_baseMatchers:     "\(_instanceMatcher),\(_jobMatcher)"
_frontendMatchers: "\(_baseMatchers),\(_frontendMatcher)"
_backendMatchers:  "\(_baseMatchers),\(_backendMatcher)"
_serverMatchers:   "\(_baseMatchers),\(_backendMatcher),\(_serverMatcher)"
