include ../../testing/make_common.mk

MODULEPATH:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: test
test: smoke-test ## Run all tests

.PHONY: smoke-test
smoke-test: ## Run all smoke-tests
	../../../bin/metaschema-xslt xspec-batch folder=$(MODULEPATH)/testing/tests recurse=yes

# .PHONY: clean
# clean: ## Remove test output
# 	rm -fr $(output_folder)/*