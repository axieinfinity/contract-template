import { HardhatRuntimeEnvironment } from 'hardhat/types';

const deploy = async ({ getNamedAccounts, deployments, network }: HardhatRuntimeEnvironment) => {
  const { deploy } = deployments;
  let { deployer } = await getNamedAccounts();

  await deploy('SampleERC721', {
    from: deployer,
    log: true,
    args: ['SampleERC721', 'NFT', 'http://example.com/'],
  });
};

deploy.tags = ['SampleERC721'];
deploy.dependencies = ['VerifyContracts'];

export default deploy;
