.DEFAULT_GOAL := help

.PHONY: run
run: ## Run Python Script
	@rye run uvicorn app.main:app --reload --port 8080

.PHONY: fmt
fmt: ## Format python code
	@rye run fmt

.PHONY: lint
lint: ## Lint python code
	@rye run lint

.PHONY: test
test: ## Run test
	@rye run test

.PHONY: help
help: ## Show help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
