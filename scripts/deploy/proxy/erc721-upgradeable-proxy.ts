import { ERC721CommonUpgradeable__factory } from '../../typechain-types';
import { HardhatRuntimeEnvironment } from 'hardhat/types';

const erc721Interface = ERC721CommonUpgradeable__factory.createInterface();

const deploy = async ({ getNamedAccounts, deployments, network }: HardhatRuntimeEnvironment) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const proxyAdmin = await deployments.get('ProxyAdmin');
  const logicContract = await deployments.get('SampleERC721CommonUpgradeableLogic');

  const data = erc721Interface.encodeFunctionData('initialize', ['SampleERC721', 'NFT', 'http://example.com/']);

  await deploy('SampleERC721CommonUpgradeableProxy', {
    contract: 'TransparentUpgradeableProxy',
    from: deployer,
    log: true,
    args: [logicContract.address, proxyAdmin, data],
  });
};

deploy.tags = ['SampleERC721CommonUpgradeableProxy'];
deploy.dependencies = ['VerifyContracts', 'ProxyAdmin', 'SampleERC721CommonUpgradeableLogic'];

export default deploy;
