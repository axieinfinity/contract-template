import { HardhatRuntimeEnvironment } from 'hardhat/types';

const deploy = async ({ getNamedAccounts, deployments }: HardhatRuntimeEnvironment) => {
  const { deploy } = deployments;
  let { deployer } = await getNamedAccounts();

  await deploy('Erc1155DangDang', {
    from: deployer,
    log: true,
    args: [
      'Erc1155DangDang',
      'Erc1155DangDang',
      'https://raw.githubusercontent.com/HoangNguyen17193/cdn/main/',
      ['0xb4b58cdc14edbf998762e1592f457e3385885818'],
    ],
  });
};

deploy.tags = ['Erc1155DangDang'];
deploy.dependencies = ['VerifyContracts'];

export default deploy;
