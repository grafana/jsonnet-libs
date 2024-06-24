.PHONY: tests

jsonnetfile.lock.json: jsonnetfile.json
	jb install

vendor: jsonnetfile.lock.json
	jb install

tests: jsonnetfile.lock.json vendor
	jsonnet -J vendor/ test_*.libsonnet
