.PHONY: help test test-local test-mainnet test-polygon test-sepolia test-base test-arbitrum test-optimism install build clean

# Default RPC URLs (can be overridden with environment variables)
# Note: Variables from .env file are loaded in each recipe that needs them
MAINNET_RPC_URL ?= https://eth-mainnet.g.alchemy.com/v2/$(ALCHEMY_API_KEY)
POLYGON_RPC_URL ?= https://polygon-mainnet.g.alchemy.com/v2/$(ALCHEMY_API_KEY)
SEPOLIA_RPC_URL ?= https://eth-sepolia.g.alchemy.com/v2/$(ALCHEMY_API_KEY)
BASE_RPC_URL ?= https://base-mainnet.g.alchemy.com/v2/$(ALCHEMY_API_KEY)
ARBITRUM_RPC_URL ?= https://arb-mainnet.g.alchemy.com/v2/$(ALCHEMY_API_KEY)
OPTIMISM_RPC_URL ?= https://opt-mainnet.g.alchemy.com/v2/$(ALCHEMY_API_KEY)

# Default to local Anvil
LOCAL_RPC_URL ?= http://127.0.0.1:8545

# Test verbosity (can be overridden: make test VERBOSITY=-vvvv)
VERBOSITY ?= -vv

help: ## Show this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies
	forge install

build: ## Build the project
	forge build

clean: ## Clean build artifacts
	forge clean

test: test-local ## Run tests on local Anvil (default)

test-local: ## Run tests on local Anvil network
	@echo "Running tests on local Anvil network..."
	@if ! pgrep -x "anvil" > /dev/null; then \
		echo "Starting Anvil in background..."; \
		anvil > /dev/null 2>&1 & \
		sleep 2; \
	fi
	forge test --rpc-url $(LOCAL_RPC_URL) $(VERBOSITY)
	@echo "Tests completed on local network"

test-mainnet: ## Run tests on Ethereum Mainnet fork
	@[ -f .env ] && export $$(grep -v '^#' .env | grep -v '^$$' | xargs) || true; \
	echo "Running tests on Ethereum Mainnet fork..."; \
	if [ -z "$$ALCHEMY_API_KEY" ]; then \
		echo "Error: ALCHEMY_API_KEY environment variable is not set"; \
		echo "Usage: ALCHEMY_API_KEY=your_key make test-mainnet or add it to .env file"; \
		exit 1; \
	fi; \
	forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/$$ALCHEMY_API_KEY $(VERBOSITY); \
	echo "Tests completed on Mainnet fork"

test-polygon: ## Run tests on Polygon Mainnet fork
	@[ -f .env ] && export $$(grep -v '^#' .env | grep -v '^$$' | xargs) || true; \
	echo "Running tests on Polygon Mainnet fork..."; \
	if [ -z "$$ALCHEMY_API_KEY" ]; then \
		echo "Error: ALCHEMY_API_KEY environment variable is not set"; \
		echo "Usage: ALCHEMY_API_KEY=your_key make test-polygon or add it to .env file"; \
		exit 1; \
	fi; \
	forge test --fork-url https://polygon-mainnet.g.alchemy.com/v2/$$ALCHEMY_API_KEY $(VERBOSITY); \
	echo "Tests completed on Polygon fork"

test-sepolia: ## Run tests on Sepolia testnet fork
	@[ -f .env ] && export $$(grep -v '^#' .env | grep -v '^$$' | xargs) || true; \
	echo "Running tests on Sepolia testnet fork..."; \
	if [ -z "$$ALCHEMY_API_KEY" ]; then \
		echo "Error: ALCHEMY_API_KEY environment variable is not set"; \
		echo "Usage: ALCHEMY_API_KEY=your_key make test-sepolia or add it to .env file"; \
		exit 1; \
	fi; \
	forge test --fork-url https://eth-sepolia.g.alchemy.com/v2/$$ALCHEMY_API_KEY $(VERBOSITY); \
	echo "Tests completed on Sepolia fork"

test-base: ## Run tests on Base Mainnet fork
	@[ -f .env ] && export $$(grep -v '^#' .env | grep -v '^$$' | xargs) || true; \
	echo "Running tests on Base Mainnet fork..."; \
	if [ -z "$$ALCHEMY_API_KEY" ]; then \
		echo "Error: ALCHEMY_API_KEY environment variable is not set"; \
		echo "Usage: ALCHEMY_API_KEY=your_key make test-base or add it to .env file"; \
		exit 1; \
	fi; \
	forge test --fork-url https://base-mainnet.g.alchemy.com/v2/$$ALCHEMY_API_KEY $(VERBOSITY); \
	echo "Tests completed on Base fork"

test-arbitrum: ## Run tests on Arbitrum Mainnet fork
	@[ -f .env ] && export $$(grep -v '^#' .env | grep -v '^$$' | xargs) || true; \
	echo "Running tests on Arbitrum Mainnet fork..."; \
	if [ -z "$$ALCHEMY_API_KEY" ]; then \
		echo "Error: ALCHEMY_API_KEY environment variable is not set"; \
		echo "Usage: ALCHEMY_API_KEY=your_key make test-arbitrum or add it to .env file"; \
		exit 1; \
	fi; \
	forge test --fork-url https://arb-mainnet.g.alchemy.com/v2/$$ALCHEMY_API_KEY $(VERBOSITY); \
	echo "Tests completed on Arbitrum fork"

test-optimism: ## Run tests on Optimism Mainnet fork
	@[ -f .env ] && export $$(grep -v '^#' .env | grep -v '^$$' | xargs) || true; \
	echo "Running tests on Optimism Mainnet fork..."; \
	if [ -z "$$ALCHEMY_API_KEY" ]; then \
		echo "Error: ALCHEMY_API_KEY environment variable is not set"; \
		echo "Usage: ALCHEMY_API_KEY=your_key make test-optimism or add it to .env file"; \
		exit 1; \
	fi; \
	forge test --fork-url https://opt-mainnet.g.alchemy.com/v2/$$ALCHEMY_API_KEY $(VERBOSITY); \
	echo "Tests completed on Optimism fork"

test-all: test-local test-mainnet test-polygon test-sepolia ## Run tests on all networks (requires ALCHEMY_API_KEY)

test-gas: ## Run tests with gas reporting
	forge test --gas-report $(VERBOSITY)

test-match: ## Run tests matching a pattern (usage: make test-match MATCH=testName)
	@if [ -z "$(MATCH)" ]; then \
		echo "Error: MATCH variable is required"; \
		echo "Usage: make test-match MATCH=testName"; \
		exit 1; \
	fi
	forge test --match-test $(MATCH) $(VERBOSITY)

test-contract: ## Run tests for a specific contract (usage: make test-contract CONTRACT=ContractName)
	@if [ -z "$(CONTRACT)" ]; then \
		echo "Error: CONTRACT variable is required"; \
		echo "Usage: make test-contract CONTRACT=ContractName"; \
		exit 1; \
	fi
	forge test --match-contract $(CONTRACT) $(VERBOSITY)

fmt: ## Format code
	forge fmt

snapshot: ## Create gas snapshots
	forge snapshot

coverage: ## Generate test coverage report
	forge coverage

anvil: ## Start Anvil local node
	anvil

anvil-fork-mainnet: ## Start Anvil with Mainnet fork
	@[ -f .env ] && export $$(grep -v '^#' .env | grep -v '^$$' | xargs) || true; \
	if [ -z "$$ALCHEMY_API_KEY" ]; then \
		echo "Error: ALCHEMY_API_KEY environment variable is not set"; \
		echo "Usage: ALCHEMY_API_KEY=your_key make anvil-fork-mainnet or add it to .env file"; \
		exit 1; \
	fi; \
	anvil --fork-url https://eth-mainnet.g.alchemy.com/v2/$$ALCHEMY_API_KEY

anvil-fork-polygon: ## Start Anvil with Polygon fork
	@[ -f .env ] && export $$(grep -v '^#' .env | grep -v '^$$' | xargs) || true; \
	if [ -z "$$ALCHEMY_API_KEY" ]; then \
		echo "Error: ALCHEMY_API_KEY environment variable is not set"; \
		echo "Usage: ALCHEMY_API_KEY=your_key make anvil-fork-polygon or add it to .env file"; \
		exit 1; \
	fi; \
	anvil --fork-url https://polygon-mainnet.g.alchemy.com/v2/$$ALCHEMY_API_KEY

