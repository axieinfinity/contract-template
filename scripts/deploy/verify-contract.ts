import { TASK_SOURCIFY } from 'hardhat-deploy';
import { network } from 'hardhat';
import { HardhatRuntimeEnvironment } from 'hardhat/types';
import { Network } from '../utils';

const deploy = async (hre: HardhatRuntimeEnvironment) => {
  if (network.name == Network.Mainnet || network.name == Network.Testnet) {
    await hre.run(TASK_SOURCIFY, { endpoint: 'https://sourcify.roninchain.com/server' });
  }
};

deploy.tags = ['VerifyContracts'];
deploy.runAtTheEnd = true;

export default deploy;
