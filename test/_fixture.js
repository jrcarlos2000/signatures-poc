const { ethers } = require("hardhat");
const hre = require("hardhat");

async function defaultFixture() {
  await deployments.fixture();
  const dummyToken = await ethers.getContract("DummyToken");
  const priceFeed = await ethers.getContract("MockChainlinkOracleFeed");
  const cSignatureTester = await ethers.getContract("SignatureTester");
  const bob = (await ethers.getSigners())[0];

  return {
    dummyToken,
    priceFeed,
    bob,
    cSignatureTester,
  };
}

module.exports = {
  defaultFixture,
};
