# contract-template

## Development

- Use Foundry:

```bash
forge install
forge test
```

- Use Hardhat:

```bash
npm install
npm run test
# or
yarn
yarn test
```

- Pull submodules:

```bash
git submodule update --init --recursive
```

## Deployment

- Saigon testnet:

    ```bash
    yarn deploy --network ronin-testnet
    ```

- Ronin mainnet:

    ```bash
    yarn deploy --network ronin-mainnet
    ```

## Features

- Write / run tests with either Hardhat or Foundry:

```bash
forge test
yarn test
```

- Use Hardhat's task framework

```bash
yarn hardhat example
```
