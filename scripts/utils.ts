export enum Network {
  Hardhat = 'hardhat',
  Testnet = 'ronin-testnet',
  Mainnet = 'ronin-mainnet',
}

export type LiteralNetwork = Network | string;
