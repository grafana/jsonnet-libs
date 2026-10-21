include ../Makefile_mixin

.PHONY: test-sources
test: test-sources

test-sources:
	jsonnet -J vendor tests/source_config_test.jsonnet
