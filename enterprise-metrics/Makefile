.ONESHELL:
.DELETE_ON_ERROR:
export SHELL     := bash
export SHELLOPTS := pipefail:errexit
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rule

# Adapted from https://suva.sh/posts/well-documented-makefiles/
.PHONY: help
help: ## Display this help.
help:
	@awk 'BEGIN {FS = ": ##"; printf "Usage:\n  make <target>\n\nTargets:\n"} /^[a-zA-Z0-9_\.\-\/%]+: ##/ { printf "  %-45s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)


test/vendor: ## Vendor the test Jsonnet libraries.
test/vendor: test/jsonnetfile.json test/jsonnetfile.lock.json
	cd test
	jb install

.PHONY: test
test: ## Run library tests.
test: test/vendor
	jsonnet -J test/lib -J test/vendor -J vendor main_test.jsonnet

docs/README.md: ## Remake the library README file.
docs/README.md: main.libsonnet
	docsonnet -J lib -J vendor docs.libsonnet -o ./docs
