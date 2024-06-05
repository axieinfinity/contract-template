import { HardhatRuntimeEnvironment } from 'hardhat/types';

const deploy = async ({ getNamedAccounts, deployments, ethers }: HardhatRuntimeEnvironment) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  await deploy('SampleERC721UpgradeableLogic', {
    contract: 'SampleERC721Upgradeable',
    from: deployer,
    log: true,
  });
};

deploy.tags = ['SampleERC721UpgradeableLogic'];
deploy.dependencies = ['VerifyContracts'];

export default deploy;
