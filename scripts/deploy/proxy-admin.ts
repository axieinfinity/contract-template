import { HardhatRuntimeEnvironment } from 'hardhat/types';

const deploy = async ({ getNamedAccounts, deployments, ethers }: HardhatRuntimeEnvironment) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  await deploy('ProxyAdmin', {
    contract: 'ProxyAdmin',
    from: deployer,
    log: true,
  });
};

deploy.tags = ['ProxyAdmin'];
deploy.dependencies = ['VerifyContracts'];

export default deploy;
