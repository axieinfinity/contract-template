import { SampleERC721Upgradeable__factory } from '../../typechain-types';
import { HardhatRuntimeEnvironment } from 'hardhat/types';
import TransparentUpgradeableProxy from 'hardhat-deploy/extendedArtifacts/TransparentUpgradeableProxy.json';

const erc721Interface = SampleERC721Upgradeable__factory.createInterface();

const deploy = async ({ getNamedAccounts, deployments, network }: HardhatRuntimeEnvironment) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const proxyAdmin = await deployments.get('ProxyAdmin');
  const logicContract = await deployments.get('SampleERC721UpgradeableLogic');

  const data = erc721Interface.encodeFunctionData('initialize', ['SampleERC721', 'NFT', 'http://example.com/']);

  await deploy('SampleERC721CommonUpgradeableProxy', {
    contract: TransparentUpgradeableProxy,
    from: deployer,
    log: true,
    args: [logicContract.address, proxyAdmin.address, data],
  });
};

deploy.tags = ['SampleERC721UpgradeableProxy'];
deploy.dependencies = ['VerifyContracts', 'ProxyAdmin', 'SampleERC721UpgradeableLogic'];

export default deploy;
