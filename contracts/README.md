# Managing the development environment for Smart Contracts

## Setup of the project
```bash
$ cd <repo root>/contracts
$ npm install --save-dev truffle                    # Installing development framework
$ npx truffle init                                  # Creating the project
$ npm install --save-dev @openzeppelin/contracts    # Adding libraries
$ npm install --save-dev ganache-cli                # Installing deployment tools
$ npm install --save-dev chai                       # Installing tools for automated tests
$ npm install --save-dev @openzeppelin/test-helpers # Adding extra libraries for automated tests
```

## Compile the smart contracts
```bash
$ cd <repo root>/contracts
$ npx truffle compile
```

## Deploy locally the smart contracts (will compile the code)
```bash
$ cd <repo root>/contracts
$ npx truffle migrate --network development
```
The network is running here: `http://localhost:8545`

```bash
$ npx ganache-cli --deterministic                   # Creating local accounts for testing purpose (it will lock the terminal)
```

## Interact locally with the smart contracts
You can interact manually:
```bash
$ cd <repo root>/contracts
$ npx truffle console --network development
truffle(development)> await ... .deployed()
truffle(development)> await ... .store(...)                # sending transaction
truffle(development)> await ()... .retrieve()).toString()  # querying state
```
... or using the available scripts:
```bash
$ cd <repo root>/contracts
$ npx truffle exec --network development ./scripts/badgedefinition_example.js
$ npx truffle exec --network development ./scripts/badgetoken_example.js
```

## Run automated tests
```bash
$ cd <repo root>/contracts
$ npx truffle test
```

## Deploy the smart contracts on a test network
```bash

```

## References from OpenZeppelin
See [ERC721 standard](https://ethereum.org/en/developers/docs/standards/tokens/erc-721).

See [ERC721 documentation](https://docs.openzeppelin.com/contracts/3.x/erc721).

See [ERC721 interfaces](https://docs.openzeppelin.com/contracts/3.x/api/token/erc721).

See [Source code of ERC721 interfaces](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/token/ERC721).

See [Developing smart contracts](https://docs.openzeppelin.com/learn/developing-smart-contracts?pref=truffle).

See [Deploying and interacting with smart contracts](https://docs.openzeppelin.com/learn/deploying-and-interacting).

See [Writing automated smart contract tests](https://docs.openzeppelin.com/learn/writing-automated-tests).

See [Solidity documentation](https://docs.soliditylang.org/en/develop/index.html).

See [Truffle homepage](https://www.trufflesuite.com/truffle).