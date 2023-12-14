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

```shell
$ forge test
```

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


Note:
There are 2 type of contracts
  1: This is Foundry + Hardhat NFT-Marketplace smart contract.
  2: The contract that have inner mint function (inside the contract)
  3: The contract that use ERC721 and integrate in the marketplace contract. In this case,
     approval is needed.
  4: The test cases both of the smart contracts are written in Foundry.
  5: This smart contract is deployed on Goerli testnet with      address:0x78297fdCaE16842772034c86387522d03d2F3197
  6: This is the Proxy Contract(upgradable contract)
  7: make file is also included, through which you can perform multiple tasks with Foundry  shortcuts.
  