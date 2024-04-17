import { HardhatRuntimeEnvironment } from 'hardhat/types';

const deploy = async ({ getNamedAccounts, deployments, ethers }: HardhatRuntimeEnvironment) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  await deploy('SampleERC721CommonUpgradeableLogic', {
    contract: 'ERC721CommonUpgradeable',
    from: deployer,
    log: true,
  });
};

deploy.tags = ['SampleERC721CommonUpgradeableLogic'];
deploy.dependencies = ['VerifyContracts'];

export default deploy;
