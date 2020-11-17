.ONESHELL:
.DELETE_ON_ERROR:
SHELL       := bash
SHELLOPTS   := -euf -o pipefail
MAKEFLAGS   += --warn-undefined-variables
MAKEFLAGS   += --no-builtin-rule

# Adapted from https://suva.sh/posts/well-documented-makefiles/
.PHONY: help
help: ## Display this help
help:
	@awk 'BEGIN {FS = ": ##"; printf "Usage:\n  make <target>\n\nTargets:\n"} /^[a-zA-Z0-9_\.\-\/%]+: ##/ { printf "  %-45s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: fmt
fmt: ## Format all files
fmt:
	cue fmt ./...
	jsonnetfmt -i mixin.libsonnet

.PHONY: lint
lint: ## Lint mixin
lint:
	mixtool lint mixin.libsonnet

build: ## Build rules and dashboards
build: alerts/general.yaml rules/rules.yaml dashboards/haproxy-overview.json dashboards/haproxy-backend.json dashboards/haproxy-frontend.json dashboards/haproxy-server.json

alerts/general.yaml: ## Export the general alert rules as YAML
alerts/general.yaml: alerts/general.cue $(wildcard cue.mod/**/github.com/prometheus/prometheus/pkg/rulefmt/*.cue)
	cue fmt $<
	cue vet -c $<
	cue export --out=yaml $< > $@

rules/rules.yaml: ## Export recording rules rules as YAML
rules/rules.yaml: rules/rules.cue $(wildcard cue.mod/**/github.com/prometheus/prometheus/pkg/rulefmt/*.cue)
	cue fmt $<
	cue vet -c $<
	cue export --out=yaml $< > $@

dashboards/%.json: ## Export a Grafana dashboard definition as JSON
dashboards/%.json: $(wildcard dashboards/*.cue) $(wildcard grafana/*.cue) $(wildcard grafana/panel/*.cue)
	cue export -e 'dashboards["$(subst dashboards/,,$@)"]' ./dashboards > $@

GRAFANA_URL := http://localhost:$(GRAFANA_PORT)
DASHBOARD   := haproxy-backend.json
.PHONY: post
post: ## Update a Grafana dashboard from a JSON file
post: dashboards/$(DASHBOARD)
	curl \
		-H 'Content-Type: application/json' \
		-H 'Accept: application/json' \
		-H "Authorization: Bearer $${GRAFANA_API_TOKEN}" \
		-d "$$(jq '{ "dashboard": ., "overwrite": true }' dashboards/$(DASHBOARD))" \
		$(GRAFANA_URL)/api/dashboards/db

.drone/drone.yml: ## Write out YAML drone configuration
.drone/drone.yml: .drone/drone.cue .drone/dump_tool.cue $(wildcard cue.mod/**/github.com/drone/drone-yaml/yaml/*.cue)
	cue fmt $<
	cue vet -c $<
	cue cmd dump ./.drone/ > $@
	drone lint $@

.PHONY: haproxy-mixin-build-image
haproxy-mixin-build-image: ## Build the haproxy-mixin-build-image
haproxy-mixin-build-image: build-image.nix common.nix $(wildcard nix/*nix)
	docker load --input $$(nix-build build-image.nix)

.PHONY: inspect-build-image
inspect-build-image: ## Inspect the haproxy-mixin-build-image
inspect-build-image:
	docker save jdbgrafana/haproxy-mixin-build-image | tar x --to-stdout --wildcards '*/layer.tar' | tar tv | sort -nr -k3

dist:
	mkdir -p dist

dist/haproxy-mixin.tar.gz: ## Create a release of the haproxy-mixin artifacts
dist/haproxy-mixin.tar.gz: $(wildcard dashboards/*.json) $(wildcard alerts/*yaml) $(wildcard rules/*.yaml) | dist
	tar -c -f $@ $^
