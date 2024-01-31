include ../../testing/make_common.mk

MODULEPATH:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
XSPEC_SCRIPT=$(realpath $(MODULEPATH)/../../../support/xspec-dev/mvn-saxon-xspec-batch.sh)

.PHONY: test
test: smoke-test ## Run all tests

.PHONY: smoke-test
smoke-test: ## Run all smoke-tests
	$(XSPEC_SCRIPT) "baseURI=file:$(XSPEC_SCRIPT)" "folder=$(MODULEPATH)/testing/tests" "recurse=yes"

# .PHONY: clean
# clean: ## Remove test output
# 	rm -fr $(output_folder)/*