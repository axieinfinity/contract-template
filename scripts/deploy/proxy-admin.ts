import { HardhatRuntimeEnvironment } from 'hardhat/types';
import ProxyAdmin from 'hardhat-deploy/extendedArtifacts/ProxyAdmin.json';

const deploy = async ({ getNamedAccounts, deployments, ethers }: HardhatRuntimeEnvironment) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  await deploy('ProxyAdmin', {
    contract: ProxyAdmin,
    from: deployer,
    log: true,
    args: [deployer],
  });
};

deploy.tags = ['ProxyAdmin'];
deploy.dependencies = ['VerifyContracts'];

export default deploy;
