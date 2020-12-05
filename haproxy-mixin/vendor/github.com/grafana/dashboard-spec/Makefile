SPEC_VERSION ?= 7.0

validate:
	@swagger-cli validate \
		--no-schema \
		specs/${SPEC_VERSION}/spec.yml

bundle: validate
	@swagger-cli bundle \
		--dereference \
		--outfile _gen/${SPEC_VERSION}/spec.json \
		specs/${SPEC_VERSION}/spec.yml

.PHONY: validate bundle
