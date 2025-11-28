## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

#### Local Testing
```shell
$ forge test
# Or using Makefile
$ make test
```

#### Testing on Different Chains
This project includes a Makefile for running tests on different blockchain networks:

```shell
# Local Anvil network (default)
make test
make test-local

# Fork testing (requires ALCHEMY_API_KEY)
ALCHEMY_API_KEY=your_key make test-mainnet
ALCHEMY_API_KEY=your_key make test-polygon
ALCHEMY_API_KEY=your_key make test-sepolia
ALCHEMY_API_KEY=your_key make test-base
ALCHEMY_API_KEY=your_key make test-arbitrum
ALCHEMY_API_KEY=your_key make test-optimism

# Other test commands
make test-gas              # Run tests with gas reporting
make test-match MATCH=testName  # Run specific test
make help                  # Show all available commands
```

**Setup:**
1. Copy `.env.example` to `.env`
2. Add your Alchemy API key: `ALCHEMY_API_KEY=your_key`
3. Source the file: `source .env` (or use `export ALCHEMY_API_KEY=your_key`)

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

## Makefile Commands

This project includes a comprehensive Makefile for common development tasks:

### Testing
- `make test` - Run tests on local Anvil (default)
- `make test-mainnet` - Run tests on Ethereum Mainnet fork
- `make test-polygon` - Run tests on Polygon fork
- `make test-sepolia` - Run tests on Sepolia testnet fork
- `make test-base` - Run tests on Base fork
- `make test-arbitrum` - Run tests on Arbitrum fork
- `make test-optimism` - Run tests on Optimism fork
- `make test-gas` - Run tests with gas reporting
- `make test-match MATCH=testName` - Run specific test
- `make test-contract CONTRACT=ContractName` - Run tests for specific contract

### Development
- `make build` - Build the project
- `make install` - Install dependencies
- `make clean` - Clean build artifacts
- `make fmt` - Format code
- `make snapshot` - Create gas snapshots
- `make coverage` - Generate test coverage report

### Anvil
- `make anvil` - Start Anvil local node
- `make anvil-fork-mainnet` - Start Anvil with Mainnet fork
- `make anvil-fork-polygon` - Start Anvil with Polygon fork

### Help
- `make help` - Show all available commands

## Environment Setup

1. Copy `.env.example` to `.env`:
   ```shell
   cp .env.example .env
   ```

2. Add your Alchemy API key to `.env`:
   ```
   ALCHEMY_API_KEY=your_alchemy_api_key_here
   ```

3. Source the environment variables:
   ```shell
   source .env
   ```

Or export directly:
```shell
export ALCHEMY_API_KEY=your_key
```

# StableCoin
