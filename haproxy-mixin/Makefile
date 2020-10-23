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

define cue_export
	cue fmt $(1)
	cue vet -c $(1)
	cue export --out=yaml $(1) > $(2)
endef

build: ## Build rules and dashboards
build: alerts/general.yaml rules/rules.yaml

alerts/general.yaml: ## Export the general alert rules as YAML
alerts/general.yaml: alerts/general.cue $(wildcard cue.mod/**/github.com/prometheus/prometheus/pkg/rulefmt/*.cue)
	$(call cue_export,$<,$@)

rules/rules.yaml: ## Export recording rules rules as YAML
rules/rules.yaml: rules/rules.cue $(wildcard cue.mod/**/github.com/prometheus/prometheus/pkg/rulefmt/*.cue)
	$(call cue_export,$<,$@)
