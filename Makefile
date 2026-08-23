.DEFAULT_GOAL := help
.PHONY: help check link test

help: ## List available targets
	@grep -hE '^[a-zA-Z0-9_-]+:.*?## ' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-8s\033[0m %s\n", $$1, $$2}'

check: ## Validate all mod XML
	@find mods -name '*.xml' -print0 | xargs -0 -r xmllint --noout
	@echo "XML OK"

link: ## Symlink every mod into RimWorld's Mods/ directory
	@bin/link-mods.sh

test: ## Run the tests
	@bats tests/
