import { expect } from "chai";
import { ethers } from "hardhat";
import { SampleERC721__factory } from "../../scripts/typechain-types/factories/src/mock/SampleERC721__factory";

const name = "SampleERC721";
const symbol = "NFT";
const baseURI = "http://example.com/";

describe("Token", function () {
  it("Should return name Token", async function () {
    const [deployer] = await ethers.getSigners();
    const Token = new SampleERC721__factory(deployer);
    const token = await Token.deploy(name, symbol, baseURI);
    await token.deployed();

    expect(await token.name()).to.equal(name);
  });
});
